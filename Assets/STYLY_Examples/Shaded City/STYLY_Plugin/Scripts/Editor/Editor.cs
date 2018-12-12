using System.Collections;
using System.Collections.Generic;
using System.IO;
using System;
using UnityEngine;
using UnityEditor;


namespace STYLY.Uploader
{
	[InitializeOnLoad]
	public class Editor : MonoBehaviour
	{

		static Editor()
		{
			EditorApplication.update += Startup;
		}


		static void Startup()
		{
			EditorApplication.update -= Startup;

			bool requirementSatisfied = true;
			string email = EditorPrefs.GetString (Settings.STYLY_EMAIL);
			string api_key = EditorPrefs.GetString (Settings.STYLY_API_KEY);
			if (email.Length == 0 || api_key.Length == 0) {
				requirementSatisfied = false;
			}
			// http://answers.unity3d.com/questions/1324195/detect-if-build-target-is-installed.html
			var moduleManager = System.Type.GetType("UnityEditor.Modules.ModuleManager,UnityEditor.dll");
			var isPlatformSupportLoaded = moduleManager.GetMethod("IsPlatformSupportLoaded", System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.NonPublic);
			var getTargetStringFromBuildTarget = moduleManager.GetMethod("GetTargetStringFromBuildTarget", System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.NonPublic);
			GUIStyle platformStyle = new GUIStyle();
			GUIStyleState platformStyleState = new GUIStyleState();
			platformStyleState.textColor = Color.red;
			platformStyle.normal = platformStyleState;
			if (!(bool)isPlatformSupportLoaded.Invoke (null, new object[] { (string)getTargetStringFromBuildTarget.Invoke (null, new object[] { BuildTarget.StandaloneWindows64 }) })) {
				requirementSatisfied = false;
			}
			if (!(bool)isPlatformSupportLoaded.Invoke (null, new object[] { (string)getTargetStringFromBuildTarget.Invoke (null, new object[] { BuildTarget.Android }) })) {
				requirementSatisfied = false;
			}
			if (!(bool)isPlatformSupportLoaded.Invoke (null, new object[] { (string)getTargetStringFromBuildTarget.Invoke (null, new object[] { BuildTarget.iOS }) })) {
				requirementSatisfied = false;
			}
			if (!(bool)isPlatformSupportLoaded.Invoke (null, new object[] { (string)getTargetStringFromBuildTarget.Invoke (null, new object[] { BuildTarget.StandaloneOSX }) })) {
				requirementSatisfied = false;
			}
			if (!(bool)isPlatformSupportLoaded.Invoke (null, new object[] { (string)getTargetStringFromBuildTarget.Invoke (null, new object[] { BuildTarget.WebGL }) })) {
				requirementSatisfied = false;
			}
			if (requirementSatisfied == false) {
				OpenSettings ();
			}
		}

		//http://baba-s.hatenablog.com/entry/2014/05/13/213143
		/// <summary>
		/// 選択中のPrefabアセットをアセットバンドルとしてビルドしてアップロードする。
		/// </summary>
		[MenuItem(@"Assets/STYLY/Upload prefab or scene to STYLY", false, 10000)]
		private static void BuildAndUpload() {
			RollbarNotifier.Init ();
			if (CheckSelectedObjectIsPrefab()) {
				// 選択中のPrefabアセットパス, アセット名を取得
				Converter converter = new Converter (Selection.objects [0]);
				if (converter.BuildAsset () == false && converter.error != null) {
					//RollbarNotifier.Instance.SendError (converter.error);
					converter.error.ShowDialog ();
				} else {
					Editor.ShowUploadSucessDialog ();
				}
			}
		}

		/// <summary>
		/// 選択中のPrefab他アセットのサイズを調べます
		/// </summary>
		[MenuItem (@"Assets/STYLY/Check File Size", false, 10001)]
		private static void CheckFileSize ()
		{
			if (CheckSelectedObjectIsPrefab()) {
				var asset = Selection.objects [0];
				var assetPath = AssetDatabase.GetAssetPath (asset);
				string AssetBundlesOutputPath = Config.OutputPath + "STYLY_ASSET";
				//フォルダのクリーンアップ
				Converter.Delete (AssetBundlesOutputPath);
				//パッケージ形式でExport
				if (!Directory.Exists (AssetBundlesOutputPath + "/Packages/"))
					Directory.CreateDirectory (AssetBundlesOutputPath + "/Packages/");
				var exportPackageFile = AssetBundlesOutputPath + "/Packages/" + "temp_for_for_filesize_check" + ".unitypackage";
				AssetDatabase.ExportPackage (assetPath, exportPackageFile, ExportPackageOptions.IncludeDependencies);
				//ファイルサイズチェック
				System.IO.FileInfo fi = new System.IO.FileInfo (exportPackageFile);
				long fileSize = fi.Length;
                //Debug.Log("File Size: " + fileSize.ToString("#,0") + " Byte");
                if (fileSize < 1024 * 1024)
                {
                    Editor.ShowFileSizeDialog(((fileSize / 1024).ToString("#,0") + " KByte"));
                }
                else
                {
                    Editor.ShowFileSizeDialog(((fileSize / (1024*1024)).ToString("#,0") + " MByte"));
                }
			}
		}

		[MenuItem (@"Assets/STYLY/Settings", false, 10002)]
		private static void OpenSettings ()
		{
			var settings = ScriptableObject.CreateInstance<Settings> ();
			settings.Show ();
		}

		[MenuItem ("STYLY/Asset Uploader Settings")]
		static void ShowSettingView ()
		{
			var settings = ScriptableObject.CreateInstance<Settings> ();
			settings.Show ();
		}

		static bool CheckSelectedObjectIsPrefab () {
			// check only one prefab selected
			Error error = null;
			if (Selection.objects.Length == 0) {
				error = new Error ("There is no prefab selected.");
			} else if (Selection.objects.Length > 1) {
				error = new Error ("Multiple assets selected. Please select only one prefab.");
			}
			//} else if (!(PrefabUtility.GetPrefabParent(Selection.objects [0]) == null && PrefabUtility.GetPrefabObject(Selection.objects [0]) != null)) {
			//	error = new Error ("Selected object is not prefab.");
			//}
			if (error != null) {
				error.ShowDialog ();
				return false;
			}
			return true;
		}

		public static void ShowUploadProgress (string description, float t)
		{
//			EditorUtility.DisplayProgressBar ("STYLY Asset Uploader", description, t);
//			if (t >= 1f) {
//				EditorUtility.ClearProgressBar ();
//			}
		}

		public static void ShowWaringDialog (string description)
		{
			ShowDialog ("Warning", description, "OK");
		}

		public static void ShowErrorDialog (string description)
		{
			ShowDialog ("Asset Upload failed", description, "OK");
		}

		public static void ShowFileSizeDialog (string size)
		{
			ShowDialog ("Asset File Size", size, "OK");
		}

		public static void ShowUploadSucessDialog ()
		{
			ShowDialog ("Asset Upload", "Upload succeeded.", "OK");
		}

		private static void ShowDialog (string title, string description, string buttonName)
		{
			EditorUtility.ClearProgressBar ();
			EditorUtility.DisplayDialog (title, description, buttonName);
		}
	}

	public class Settings : EditorWindow
	{
		public const string STYLY_EMAIL = "SUITE.STYLY.CC.ASSET_UPLOADER_EMAIL";
		public const string STYLY_API_KEY = "SUITE.STYLY.CC.API_KEY";

		public string email;
		public string api_key;

        /// <summary>
        /// Return cache server status 
        /// </summary>
        /// <returns>"Local", "Remote", "Disable"</returns>
        public static string checkCacheServer()
        {
            string[] CacheServerModeString = new string[3] { "Local", "Remote", "Disable" };
            var CacheServerMode = EditorPrefs.GetInt("CacheServerMode", (int)(EditorPrefs.GetBool("CacheServerEnabled") ? 1 : 2));
            return CacheServerModeString[CacheServerMode];
        }

        void Awake ()
		{
            this.minSize = new Vector2(400,300);
			email = EditorPrefs.GetString (STYLY_EMAIL);
			api_key = EditorPrefs.GetString (STYLY_API_KEY);
		}

		void OnGUI ()
		{
			GUILayout.Label ("Unity plugin for STYLY", EditorStyles.boldLabel);
			GUIStyle style = new GUIStyle(GUI.skin.label);
			style.wordWrap = true;
			EditorGUILayout.LabelField ("Right click on a prefab and select \"STYLY\"-\"Upload prefab or scene to STYLY\". Your prefab will appear in \"3D Model\"-\"My Models\" section in STYLY. ", style);

            GUILayout.BeginHorizontal("box");
            if (GUILayout.Button ("Get STYLY API Key", GUILayout.Width (120))) {
				Application.OpenURL("https://webeditor.styly.cc/api_key");
			}
            if (GUILayout.Button("Open Tutorial", GUILayout.Width(120)))
            {
                Application.OpenURL("http://docs.styly.cc/category/unity-uploader/");
            }
            GUILayout.EndHorizontal();
            GUILayout.Space(10);

			// http://answers.unity3d.com/questions/1324195/detect-if-build-target-is-installed.html
			var moduleManager = System.Type.GetType("UnityEditor.Modules.ModuleManager,UnityEditor.dll");
			var isPlatformSupportLoaded = moduleManager.GetMethod("IsPlatformSupportLoaded", System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.NonPublic);
			var getTargetStringFromBuildTarget = moduleManager.GetMethod("GetTargetStringFromBuildTarget", System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.NonPublic);
			GUIStyle platformStyle = new GUIStyle();
			GUIStyleState platformStyleState = new GUIStyleState();
			platformStyleState.textColor = Color.red;
			platformStyle.normal = platformStyleState;
			bool allPlatformInstalled = true;
			if (!(bool)isPlatformSupportLoaded.Invoke (null, new object[] { (string)getTargetStringFromBuildTarget.Invoke (null, new object[] { BuildTarget.StandaloneWindows64 }) })) {
				EditorGUILayout.LabelField ("No Windows module installed.", platformStyle);
				allPlatformInstalled = false;
			}
			if (!(bool)isPlatformSupportLoaded.Invoke (null, new object[] { (string)getTargetStringFromBuildTarget.Invoke (null, new object[] { BuildTarget.Android }) })) {
				EditorGUILayout.LabelField ("No Android module installed.", platformStyle);
				allPlatformInstalled = false;
			}
			if (!(bool)isPlatformSupportLoaded.Invoke (null, new object[] { (string)getTargetStringFromBuildTarget.Invoke (null, new object[] { BuildTarget.iOS }) })) {
				EditorGUILayout.LabelField ("No iOS module installed.", platformStyle);
				allPlatformInstalled = false;
			}
			if (!(bool)isPlatformSupportLoaded.Invoke (null, new object[] { (string)getTargetStringFromBuildTarget.Invoke (null, new object[] { BuildTarget.StandaloneOSX }) })) {
				EditorGUILayout.LabelField ("No Mac OSX module installed.", platformStyle);
				allPlatformInstalled = false;
			}
			if (!(bool)isPlatformSupportLoaded.Invoke (null, new object[] { (string)getTargetStringFromBuildTarget.Invoke (null, new object[] { BuildTarget.WebGL }) })) {
				EditorGUILayout.LabelField ("No WebGL module installed.", platformStyle);
				allPlatformInstalled = false;
			}
			if (allPlatformInstalled == false) {
				EditorGUILayout.LabelField ("STYLY Uploader requires above modules. Please install these modules.", platformStyle);
			}
            if (checkCacheServer()=="Disable")
            {
                EditorGUILayout.LabelField("Cache Server is strongly recommended.\n Change the setting at Edit-Preferences-CacheServer", platformStyle);
            }

			GUILayout.Space(20);
			EditorGUI.BeginChangeCheck ();

			email = EditorGUILayout.TextField ("Email", email);
			GUILayout.Space(5);
			api_key = EditorGUILayout.TextField ("API Key", api_key);

			if (EditorGUI.EndChangeCheck ()) {
				EditorPrefs.SetString (STYLY_EMAIL, email);
				EditorPrefs.SetString (STYLY_API_KEY, api_key);
			}

            GUILayout.Space(20);
			this.Repaint ();
		}
	}
}