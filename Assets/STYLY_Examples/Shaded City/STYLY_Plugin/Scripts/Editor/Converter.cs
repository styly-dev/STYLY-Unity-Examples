using System.IO;
using System;
using System.Net;
using UnityEditor;
using UnityEngine;
using System.Text;
using System.IO.Compression;
using System.Collections.Specialized;
using UnityEngine.Networking;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace STYLY.Uploader
{
	public class Converter
	{
		private UnityEngine.Object asset;
		private string assetPath;
		private string assetTitle;

		private string email;
		private string apiKey;
		private string unityVersion;
		private string unityGuid;

		private bool isAdministrator = false;

		private string stylyGuid;
		private string stylyHash;
		private Dictionary<string, string> signedUrls = new Dictionary<string, string> ();

		public Error error;

		private string renamedAssetPath;

		public Converter (UnityEngine.Object asset)
		{
            this.email = EditorPrefs.GetString(Settings.STYLY_EMAIL);
            this.apiKey = EditorPrefs.GetString(Settings.STYLY_API_KEY);

            isAdministrator = this.email.Equals("info@styly.cc");

            string assetType = asset.GetType().ToString();

            if (isAdministrator || assetType == "UnityEditor.SceneAsset")
            {
                if (isAdministrator)
                {
                    this.unityGuid = AssetDatabase.AssetPathToGUID(AssetDatabase.GetAssetPath(asset));
                }
                else
                {
                    this.unityGuid = Guid.NewGuid().ToString("D");
                }
                // 管理者はスクリプトをあげることがあるので、親オブジェクトを付けない
                this.asset = asset;
                this.assetPath = AssetDatabase.GetAssetPath(this.asset);
                this.assetTitle = System.IO.Path.GetFileNameWithoutExtension(this.assetPath);
                this.unityVersion = UnityEngine.Application.unityVersion;
			} else {
				this.unityGuid = Guid.NewGuid().ToString("D");
                // ユーザー向けにはupload用のオブジェクトを作成して親に空のGameObjectを付ける
                var copy = PrefabUtility.InstantiateAttachedAsset(asset);
                ((GameObject)copy).transform.position = Vector3.zero;
                var uploadPrefab = new GameObject();
                ((GameObject)copy).transform.parent = uploadPrefab.transform;

                if (!AssetDatabase.IsValidFolder("Assets/" + Config.STYLY_TEMP_DIR))
                {
                    AssetDatabase.CreateFolder("Assets", Config.STYLY_TEMP_DIR);
                }

                this.asset = PrefabUtility.CreatePrefab(string.Format(Config.UploadPrefabName, asset.name), uploadPrefab, ReplacePrefabOptions.ConnectToPrefab);
                UnityEditor.AssetDatabase.SaveAssets();
                Editor.DestroyImmediate(uploadPrefab);
                this.assetPath = AssetDatabase.GetAssetPath(this.asset);
                this.assetTitle = System.IO.Path.GetFileNameWithoutExtension(this.assetPath);
                this.unityVersion = UnityEngine.Application.unityVersion;
            }
        }

		public bool BuildAsset ()
		{

            RollbarNotifier.SetUserID (this.email);

			CheckError ();
			if (this.error != null)
				return false;

			GetAzureSignedUrls ();
			if (this.error != null)
				return false;
			
			RenameAssetForBuild ();

			//フォルダのクリーンアップ
			Delete (Config.OutputPath + "STYLY_ASSET");

			CopyPackage ();

			MakeThumbnail ();

			foreach (RuntimePlatform platform in Config.PlatformList) {
				bool result = Build (platform);
				if (result == false) {
					AssetDatabase.MoveAsset (renamedAssetPath, assetPath);
					return false;
				}
			}

			UploadAssets ();
			if (this.error != null)
				return false;

			PostUploadComplete ();
			if (this.error != null)
				return false;

			// Prefab名を戻す
			AssetDatabase.MoveAsset (this.renamedAssetPath, assetPath);
			AssetDatabase.Refresh ();

            string assetType = this.asset.GetType().ToString();
            if ((!isAdministrator) && (assetType == "UnityEngine.GameObject"))
            {
                UnityEngine.Object.DestroyImmediate(this.asset, true);
            }

            if (isAdministrator) {
				Debug.Log ("[Admin]STYLY_GUID: " + this.stylyGuid);
			}

			DeleteCamera ();

			return true;
		}

		public void CheckError ()
		{

            // unity version check
            bool isUnSupportedVersion = true;
			foreach (string version in Config.UNITY_VERSIONS) {
				if (Application.unityVersion.Contains (version)) {
					isUnSupportedVersion = false;
				}
			}
			if (isUnSupportedVersion) {
                Debug.Log("isUnSupportedVersion");
                this.error = new Error ("Please use Unity " + string.Join(", ", Config.UNITY_VERSIONS) + ".");
				return;
			}

			if (this.email == null || this.email.Length == 0
				|| this.asset == null || this.apiKey.Length == 0) {
                Debug.Log("You don't have a account settings. [STYLY/Asset Uploader Settings]");
                this.error = new Error ("You don't have a account settings. [STYLY/Asset Uploader Settings]");
				return;
			}

			//もしSTYLYアセット対応拡張子ではなかったらエラー出して終了
			if (Array.IndexOf (Config.AcceptableExtentions, System.IO.Path.GetExtension (assetPath)) < 0) {
                Debug.Log("Unsupported format ");
                this.error = new Error ("Unsupported format " + System.IO.Path.GetExtension (assetPath));
				return;
			}

            string assetType = this.asset.GetType().ToString();
            if ((!isAdministrator) && (assetType == "UnityEngine.GameObject")) {
				GameObject assetObj = AssetDatabase.LoadAssetAtPath (assetPath, typeof(GameObject)) as GameObject;
				Transform[] childTransforms = assetObj.GetComponentsInChildren<Transform> ();
				foreach (Transform t in childTransforms) {
					//禁止アセットのチェック
					if (Config.ProhibitedTags.Contains (t.gameObject.tag)) {
						this.error = new Error (string.Format ("{0} can not be used as a tag.", t.tag));
						return;
					}
					//禁止レイヤーのチェック
					//Defaultレイヤー以外使用できない
					if (t.gameObject.layer != 0) {
						this.error = new Error ("Object needs to be in Default layer. You use " + LayerMask.LayerToName (t.gameObject.layer));
						return;
					}
                }
			}
		}


        /// <summary>
        /// ウェブサーバーにフォームデータをPOSTして結果を得る関数
        /// 
        ///利用方法
        ///IEnumerator t = PostToServer(Config.AzureSignedUrls, form);
        ///while (t.MoveNext()){}
        ///string responseString = t.Current.ToString().Trim();
        ///
        /// </summary>
        /// <param name="url"></param>
        /// <param name="formcollection"></param>
        /// <returns></returns>
        public IEnumerator PostToServer(string url, NameValueCollection formcollection)
        {
            WWWForm form = new WWWForm();
            foreach (string key in formcollection)
            {
                form.AddField(key, formcollection[key]);
            }
            using (UnityWebRequest request = UnityWebRequest.Post(url, form))
            {
                yield return request.SendWebRequest();
                while (!request.isDone)
                {
                    yield return 0;
                }

                if (request.isNetworkError)
                {
                    Debug.Log(request.error);
                }
                else
                {
                    if (request.responseCode == 200)
                    {
                        string response = request.downloadHandler.text;
                        yield return response;
                    }
                }
            }
        }


        public void GetAzureSignedUrls ()
		{

            NameValueCollection form = new NameValueCollection ();
			form ["bu_email"] = this.email;
            form["bu_api_key"] = this.apiKey;
            form["sa_unity_version"] = this.unityVersion;
            form["sa_unity_guid"] = this.unityGuid;

            try {

                //Post to server
                IEnumerator t = PostToServer(Config.AzureSignedUrls,form);
                while (t.MoveNext()){}
                string responseString = t.Current.ToString().Trim();
                
                Dictionary<string, object> dict = Json.Deserialize (responseString) as Dictionary<string, object>;

                this.stylyGuid = (string)dict["styly_guid"];
                this.stylyHash = (string)dict["styly_hash"];
                this.signedUrls.Add("Package", (string)dict["url_package"]);
                this.signedUrls.Add("Thumbnail", (string)dict["url_thumbnail"]);
                Dictionary<string, object> platforms = (Dictionary<string, object>)dict["platforms"];
                this.signedUrls.Add("Android", (string)platforms["Android"]);
                this.signedUrls.Add("iOS", (string)platforms["iOS"]);
                this.signedUrls.Add("OSX", (string)platforms["OSX"]);
                this.signedUrls.Add("Windows", (string)platforms["Windows"]);
                this.signedUrls.Add("WebGL", (string)platforms["WebGL"]);

                if (isAdministrator)
                {
                    Debug.Log("[Admin]" + Json.Serialize(this.signedUrls));
                }
                } catch (WebException e) {
                    string errorMessage = getErrorMessageFromResponseJson(e);
                    Debug.LogError("[STYLY]" + errorMessage);
                    this.error = new Error(errorMessage + " \n\nAuthentication failed." + e.Message);
            }
        }

        /// <summary>
        /// エラーが出た際、JSONにErrorメッセージがあれば取得する
        /// サーバーはStatus400を返すため本文にJSONがあってもWebExceptionが発生します
        /// </summary>
        /// <param name="e"></param>
        /// <returns></returns>
        private string getErrorMessageFromResponseJson(WebException e)
        {
            string ret = "";
            try
            {
                Stream s = e.Response.GetResponseStream();
                StreamReader sr = new StreamReader(s);
                string responseString = sr.ReadToEnd();
                Dictionary<string, object> dict = Json.Deserialize(responseString) as Dictionary<string, object>;
                if (dict.ContainsKey("error"))
                {
                    ret = (string)dict["error"];
                }
            }
            catch
            {
                ret = "Unknown error";
            }
            return ret;
        }
        

		//Prefab名をSTYLY GUIDに一時的に変更
		private void RenameAssetForBuild ()
		{
            Debug.Log("RenameAssetForBuild");

            this.renamedAssetPath = System.IO.Path.GetDirectoryName (assetPath) + "/" + stylyGuid + System.IO.Path.GetExtension (assetPath);
			AssetDatabase.MoveAsset (assetPath, this.renamedAssetPath);
			AssetDatabase.SaveAssets ();
			AssetDatabase.Refresh ();
		}

		private void CopyPackage ()
		{
            Debug.Log("CopyPackage");


            //パッケージ形式でバックアップ用にExport
            if (!Directory.Exists (Config.OutputPath + "/STYLY_ASSET/Packages/"))
				Directory.CreateDirectory (Config.OutputPath + "/STYLY_ASSET/Packages/");

			var exportPackageFile = Config.OutputPath + "/STYLY_ASSET/Packages/" + this.stylyGuid + ".unitypackage";

			// これを入れないとMacだと落ちる。
			// なぜなら、AssetDatabase.ExportPackage メソッドなどがプログレスウィンドウを表示しようとするので、すでにプログレスウィンドウがあると問題になる模様。
			EditorUtility.ClearProgressBar ();

			AssetDatabase.ExportPackage (this.renamedAssetPath, exportPackageFile, ExportPackageOptions.IncludeDependencies);
		}

		private void MakeThumbnail ()
		{
            Debug.Log("MakeThumbnail");

            if (!Directory.Exists (Config.OutputPath + "/STYLY_ASSET/Thumbnails/"))
				Directory.CreateDirectory (Config.OutputPath + "/STYLY_ASSET/Thumbnails/");

            //Dummyサムネイルのコピー
            File.Copy(Application.dataPath + "/STYLY_Plugin/Resources/dummy_thumbnail.png", Config.OutputPath + "/STYLY_ASSET/Thumbnails/" + this.stylyGuid + "2.png");

            try { 
                GameObject targetObj = AssetDatabase.LoadAssetAtPath (this.renamedAssetPath, typeof(GameObject)) as GameObject;
			    GameObject unit = UnityEngine.Object.Instantiate (targetObj, Vector3.zero, Quaternion.identity) as GameObject;
			    string thumbnailPath = System.IO.Directory.GetParent (Application.dataPath) + "/" + Config.OutputPath + "/STYLY_ASSET/Thumbnails/" + this.stylyGuid + ".png";
			    Thumbnail.MakeThumbnail (unit, thumbnailPath, Config.ThumbnailWidth, Config.ThumbnailHeight);
            }
            catch { }

        }

		/// アップロード後にサーバーに通知
		private void PostUploadComplete ()
		{

            try
            {
				NameValueCollection form = new NameValueCollection ();
				form ["bu_email"] = this.email;
				form ["bu_api_key"] = this.apiKey;
				form ["sa_unity_version"] = this.unityVersion;
				form ["sa_unity_guid"] = this.unityGuid;
				form ["sa_title"] = this.assetTitle;
				form ["styly_hash"] = this.stylyHash;
				form ["styly_guid"] = this.stylyGuid;

                //Post to server
                IEnumerator t = PostToServer(Config.StylyAssetUploadCompleteUrl, form);
                while (t.MoveNext()) { }
                string responseString = t.Current.ToString().Trim();

            } catch (Exception e) {
				this.error = new Error (e.Message);
			}
		}

		public bool UploadAssets ()
		{
            Debug.Log("UploadAssets");

            string AssetBundlesOutputPath = Config.OutputPath + "STYLY_ASSET";

			bool uploadResult = true;
			uploadResult = UploadToStorage (this.signedUrls ["Package"],
				System.IO.Directory.GetParent (Application.dataPath) + "/" + AssetBundlesOutputPath + "/Packages/" + this.stylyGuid + ".unitypackage");
        
			if (uploadResult == false) {
				return false;
			}
				
			uploadResult = UploadToStorage (this.signedUrls ["Thumbnail"],
				System.IO.Directory.GetParent (Application.dataPath) + "/" + AssetBundlesOutputPath + "/Thumbnails/" + this.stylyGuid + ".png");
        	
			if (uploadResult == false) {
				return false;
			}

			foreach (var platform in Config.PlatformList) {
				string platformString = GetPlatformName (platform);
				uploadResult = UploadToStorage (this.signedUrls [platformString], 
					System.IO.Directory.GetParent (Application.dataPath) + "/" + AssetBundlesOutputPath + "/" + platformString + "/" + this.stylyGuid);
				if (uploadResult == false) {
					return false;
				}
			}
			return true;
		}


		private bool UploadToStorage (string url, string filePath)
		{

            try
            {
				byte[] myData = LoadBinaryData (filePath);

				ServicePointManager.Expect100Continue = true;
				ServicePointManager.CheckCertificateRevocationList = false;
				ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls;
				ServicePointManager.ServerCertificateValidationCallback = RemoteCertificateValidationCallback;
	            
				HttpWebRequest client = WebRequest.Create (url) as HttpWebRequest;
				client.Timeout = 10 * 60 * 1000;
	            client.KeepAlive = true;
				client.Method = "PUT";
				client.ContentLength = myData.Length;
				client.Credentials = CredentialCache.DefaultCredentials;
	            client.Headers.Add ("x-ms-blob-type", "BlockBlob");
	            client.Headers.Add ("x-ms-date", DateTime.UtcNow.ToString("R", System.Globalization.CultureInfo.InvariantCulture));

	            using (Stream requestStream = client.GetRequestStream ()) {
	                requestStream.Write (myData, 0, myData.Length);
				}

				using (HttpWebResponse res = client.GetResponse () as HttpWebResponse) {
	                bool isOK = true;
					if (res.StatusCode != HttpStatusCode.Created) {
						isOK = false;
					}
					using (StreamReader reader = new StreamReader (res.GetResponseStream ())) {
	                    string data = reader.ReadToEnd ();
						if (!isOK) {
							this.error = new Error (data, new Dictionary<string, string> {
								{ "url", url },
								{ "file_path", filePath }
							});
							return false;
						}
					}
				}
			} catch (Exception e) {
				this.error = new Error (e);
				return false;
			}
			return true;
		}

		private static bool RemoteCertificateValidationCallback (object sender,
		                                                         System.Security.Cryptography.X509Certificates.X509Certificate certificate,
		                                                         System.Security.Cryptography.X509Certificates.X509Chain chain,
		                                                         System.Net.Security.SslPolicyErrors sslPolicyErrors)
		{
			return true;
		}


		static byte[] LoadBinaryData (string path)
		{


            FileStream fs = null;
			try {
				fs = new FileStream (path, FileMode.Open);
			} catch (FileNotFoundException e) {
				if (path.IndexOf ("/Thumbnails/") >= 0) {
					fs = new FileStream (Application.dataPath + "/STYLY_Plugin/Resources/dummy_thumbnail.png", FileMode.Open);
				} else {
					throw e;
				}
			}

			BinaryReader br = new BinaryReader (fs);
			byte[] buf = br.ReadBytes ((int)br.BaseStream.Length);
			br.Close ();
			return buf;
		}


		public bool Build (RuntimePlatform platform)
		{
            Debug.Log("Build");


            //対象プラットフォームごとに出力フォルダ作成
            string outputPath = Path.Combine (Config.OutputPath + "STYLY_ASSET", GetPlatformName (platform));
			if (!Directory.Exists (outputPath)) {
				Directory.CreateDirectory (outputPath);
			}
          	
			bool switchResult = true;

			if (platform == RuntimePlatform.WindowsPlayer) {
				// プラットフォームとGraphic APIを常に同じにする
				switchResult = EditorUserBuildSettings.SwitchActiveBuildTarget (BuildTargetGroup.Standalone, BuildTarget.StandaloneWindows64);
				//PlayerSettings.colorSpace = ColorSpace.Gamma;
				PlayerSettings.SetUseDefaultGraphicsAPIs (BuildTarget.StandaloneWindows64, false);
				PlayerSettings.SetGraphicsAPIs (BuildTarget.StandaloneWindows64, new UnityEngine.Rendering.GraphicsDeviceType[] {
					//UnityEngine.Rendering.GraphicsDeviceType.Direct3D9,
					UnityEngine.Rendering.GraphicsDeviceType.Direct3D11
				});
			} else if (platform == RuntimePlatform.Android) {

				switchResult = EditorUserBuildSettings.SwitchActiveBuildTarget (BuildTargetGroup.Android, BuildTarget.Android);
				EditorUserBuildSettings.androidBuildSystem = AndroidBuildSystem.Gradle;

				//PlayerSettings.colorSpace = ColorSpace.Gamma;
				PlayerSettings.SetUseDefaultGraphicsAPIs (BuildTarget.Android, false);
				PlayerSettings.SetGraphicsAPIs (BuildTarget.Android, new UnityEngine.Rendering.GraphicsDeviceType[] {
					UnityEngine.Rendering.GraphicsDeviceType.OpenGLES2,
					UnityEngine.Rendering.GraphicsDeviceType.OpenGLES3
				});
			} else if (platform == RuntimePlatform.IPhonePlayer) {
				switchResult = EditorUserBuildSettings.SwitchActiveBuildTarget (BuildTargetGroup.iOS, BuildTarget.iOS);
				//PlayerSettings.colorSpace = ColorSpace.Gamma;
				PlayerSettings.SetUseDefaultGraphicsAPIs (BuildTarget.iOS, false);
				PlayerSettings.SetGraphicsAPIs (BuildTarget.iOS, new UnityEngine.Rendering.GraphicsDeviceType[] {
					UnityEngine.Rendering.GraphicsDeviceType.OpenGLES2,
					UnityEngine.Rendering.GraphicsDeviceType.Metal
				});
			} else if (platform == RuntimePlatform.OSXPlayer) {
				switchResult = EditorUserBuildSettings.SwitchActiveBuildTarget (BuildTargetGroup.Standalone, BuildTarget.StandaloneOSX);
				//PlayerSettings.colorSpace = ColorSpace.Gamma;
				PlayerSettings.SetUseDefaultGraphicsAPIs (BuildTarget.StandaloneOSX, false);
				PlayerSettings.SetGraphicsAPIs (BuildTarget.StandaloneOSX, new UnityEngine.Rendering.GraphicsDeviceType[] {
					UnityEngine.Rendering.GraphicsDeviceType.OpenGLES2,
					UnityEngine.Rendering.GraphicsDeviceType.Metal
				});
			} else if (platform == RuntimePlatform.WebGLPlayer) {

				switchResult = EditorUserBuildSettings.SwitchActiveBuildTarget (BuildTargetGroup.WebGL, BuildTarget.WebGL);
				//PlayerSettings.colorSpace = ColorSpace.Gamma;
				PlayerSettings.SetUseDefaultGraphicsAPIs (BuildTarget.WebGL, true);
				// web gl 1.0, web gl 2.0 がUnityEngine.Rendering.GraphicsDeviceTypeにないからautoで設定している
			}

			if (switchResult == false) {
				this.error = new Error ("Can not switch Build target to " + GetPlatformName (platform) + ".\n"
				+ "Make sure you have installed the target build module.\n"
				+ "This tool requires Android, iOS, OSX, WebGL, Windows platforms.");
				return false;
			} 
            
			AssetBundleBuild[] buildMap = new AssetBundleBuild[1];
			buildMap [0].assetBundleName = this.stylyGuid;
			buildMap [0].assetNames = new string[] { this.renamedAssetPath };

			AssetBundleManifest buildResult = BuildPipeline.BuildAssetBundles (outputPath, buildMap, BuildAssetBundleOptions.ChunkBasedCompression, GetBuildTarget (platform));
			if (buildResult == null) {
				this.error = new Error ("Buid asset bundle failed for platform " + GetPlatformName (platform));
				return false;
			}
			return true;
		}

		private void DeleteCamera() {


            UnityEditor.EditorApplication.delayCall += () => {
				var deleteCamera = GameObject.Find (Thumbnail.STYLY_Thumbnail_Camera_Name);
				if (deleteCamera) {
					UnityEngine.Object.DestroyImmediate (deleteCamera);
				}
				var deleteObject = GameObject.Find (Thumbnail.STYLY_Thumbnail_Object_Name);
				if (deleteObject) {
					UnityEngine.Object.DestroyImmediate (deleteObject);
				}
			};
		}

		public BuildTarget GetBuildTarget (RuntimePlatform platform)
		{
            Debug.Log("GetBuildTarget");


            switch (platform) {
			case RuntimePlatform.Android:
				return BuildTarget.Android;
			case RuntimePlatform.IPhonePlayer:
				return BuildTarget.iOS;
			case RuntimePlatform.WebGLPlayer:
				return BuildTarget.WebGL;
			case RuntimePlatform.WindowsPlayer:
				return BuildTarget.StandaloneWindows64;
			case RuntimePlatform.OSXPlayer:
				return BuildTarget.StandaloneOSX;
			default:
				return BuildTarget.StandaloneWindows64;
			}
		}


		public string GetPlatformName (RuntimePlatform platform)
		{


            switch (platform) {
			case RuntimePlatform.Android:
				return "Android";
			case RuntimePlatform.IPhonePlayer:
				return "iOS";
			case RuntimePlatform.WebGLPlayer:
				return "WebGL";
			case RuntimePlatform.WindowsEditor:
			case RuntimePlatform.WindowsPlayer:
				return "Windows";
			case RuntimePlatform.OSXPlayer:
			case RuntimePlatform.OSXEditor:
				return "OSX";
			default:
				return null;
			}
		}


		/// 指定したディレクトリとその中身を全て削除する
		/// http://kan-kikuchi.hatenablog.com/entry/DirectoryProcessor
		public static void Delete (string targetDirectoryPath)
		{
            Debug.Log("Delete");

            if (!Directory.Exists (targetDirectoryPath)) {
				return;
			}

			//ディレクトリ以外の全ファイルを削除
			string[] filePaths = Directory.GetFiles (targetDirectoryPath);
			foreach (string filePath in filePaths) {
				File.SetAttributes (filePath, FileAttributes.Normal);
				File.Delete (filePath);
			}

			//ディレクトリの中のディレクトリも再帰的に削除
			string[] directoryPaths = Directory.GetDirectories (targetDirectoryPath);
			foreach (string directoryPath in directoryPaths) {
				Delete (directoryPath);
			}

			//中が空になったらディレクトリ自身も削除
			Directory.Delete (targetDirectoryPath, false);
		}


	}
}
