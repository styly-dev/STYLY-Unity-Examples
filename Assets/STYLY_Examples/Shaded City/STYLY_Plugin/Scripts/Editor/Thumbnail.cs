using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace STYLY.Uploader
{
	public class Thumbnail : MonoBehaviour
	{

		public const string STYLY_Thumbnail_Camera_Name = "SUITE.STYLY.CC.thumbnail_camera_name";
		public const string STYLY_Thumbnail_Object_Name = "SUITE.STYLY.CC.thumbnail_object_name";

		/// <summary>
		/// Gameobjectのサムネイル画像を作成する
		/// </summary>
		/// <param name="unit">対象Gameobject</param>
		/// <param name="savePath">保存先の絶対パス</param>
		/// <param name="width">サムネイル画像の幅(px)</param>
		/// <param name="height">サムネイル画像の高さ(px)</param>
		/// <param name="successMake">成功か失敗か</param>
		/// <returns>成功か失敗か</returns>
//		bool isCreateThumbnail = true;

		public static bool MakeThumbnail (GameObject unit, string savePath, int width, int height)
		{
			bool successMake = false;
			int layerNo;

			//対象の配置 レイヤーの設定
			unit.transform.eulerAngles = new Vector3 (-10.0f, -60.0f, 15.0f);
			layerNo = UnityGameobjectThumbnailLayerClass.CreateLayer ();

			//全てのレイヤーが使われていた場合（戻り値が7の場合）、エラーを表示し、終了
			if (layerNo == 7) {
				Editor.ShowErrorDialog ("There is no space in the layer, creation of thumbnail failed.");
				return false;
			}
			unit.SetLayer (layerNo);

			//対象の大きさを測る
			//子孫オブジェクトの中でMeshFilterを持っているか判定し、
			//MeshFilterを持っている全てのオブジェクトを内包するboundsをつくる

			Bounds maxBounds = new Bounds (Vector3.zero, Vector3.zero);

			Component[] meshFilterList;
			meshFilterList = unit.gameObject.GetComponentsInChildren (typeof(MeshFilter));

			Component[] SkinnedMeshRendererList;
			SkinnedMeshRendererList = unit.gameObject.GetComponentsInChildren (typeof(SkinnedMeshRenderer));

			if (meshFilterList != null) { //メッシュフィルターがあれば実行
				foreach (MeshFilter child in meshFilterList) {
					Transform t = child.transform;
					if (child.sharedMesh != null) {
						Bounds bounds = child.sharedMesh.bounds;
						Vector3 b2Size = new Vector3 (bounds.size.x * t.lossyScale.x, bounds.size.y * t.lossyScale.y, bounds.size.z * t.lossyScale.z);
						Bounds b2 = new Bounds (t.localToWorldMatrix.MultiplyPoint (bounds.center), b2Size);//ローカル座標からグローバル座標に変換
						maxBounds.Encapsulate (b2);
					}
				}
			}

			if (maxBounds.size.x == 0f && maxBounds.size.y == 0f) { //SkinnedMeshRendererのとき実行
				foreach (SkinnedMeshRenderer child in SkinnedMeshRendererList) {
					Transform t = child.transform;
					Bounds bounds = child.localBounds;
					Vector3 b2Size = new Vector3 (bounds.size.x * t.lossyScale.x, bounds.size.y * t.lossyScale.y, bounds.size.z * t.lossyScale.z);
					Bounds b2 = new Bounds (t.localToWorldMatrix.MultiplyPoint (bounds.center), b2Size);//ローカル座標からグローバル座標に変換
					maxBounds.Encapsulate (b2);
				}
			}

			//カメラのサイズを求める
			float cameraSize;
			cameraSize = System.Math.Max (maxBounds.extents.x, maxBounds.extents.y);

			//撮影用カメラscを作成
			GameObject secondCamera;
			secondCamera = new GameObject ("SecondCamera");
			var sc = secondCamera.AddComponent<UnityEngine.Camera> ();
			//secondCamera.GetComponent<Camera>();

			//撮影するレイヤーを指定
			for (int i = 0; i <= 31; i++) {
				sc.cullingMask &= (1 << i);
			}
			sc.cullingMask |= (1 << layerNo);

			//カメラを設定
			secondCamera.transform.position = new Vector3 (0, 0, -1000);
			secondCamera.transform.LookAt (new Vector3 (maxBounds.center.x, maxBounds.center.y, maxBounds.center.z));

			sc.nearClipPlane = 0.001f;
			sc.farClipPlane = 3000f;
			sc.orthographic = true;
			sc.orthographicSize = cameraSize * 1.5f;

			//背景色をアルファ0に設定して透過するようにする
			sc.clearFlags = CameraClearFlags.SolidColor;
			sc.backgroundColor = new Color (255.0f, 255.0f, 255.0f, 0.0f);

			//キャプチャ 
			// RenderTextureを生成して、これに現在のSceneに映っているものを書き込む
			RenderTexture renderTexture = new RenderTexture (width, height, 24);
			sc.targetTexture = renderTexture;
			sc.Render ();
			RenderTexture.active = renderTexture;
			Texture2D texture2D = new Texture2D (width, height, TextureFormat.ARGB32, false);//ここでアルファチャンネルも保存(透過の設定を保存できる)
			texture2D.ReadPixels (new Rect (0, 0, width, height), 0, 0);

			// textureのbyteをファイルに出力
			byte[] bytes = texture2D.EncodeToPNG ();
			try {
				System.IO.File.WriteAllBytes (savePath, bytes);
				successMake = true;
			} catch (System.Exception ex) {
				Editor.ShowErrorDialog ("Failed to export thumbnail. " + ex.Message);
				successMake = false;
			}

			// 後処理
			sc.targetTexture = null;
			RenderTexture.active = null;
			renderTexture.Release ();
#if UNITY_EDITOR
			DestroyImmediate (unit);
			DestroyImmediate (secondCamera);
#else
        DestroyImmediate(unit);
        DestroyImmediate(secondCamera);
#endif
			return successMake;
		}

	}


	public static class UnityGameobjectThumbnailLayerClass
	{
		/// <summary>
		/// レイヤーを設定する
		/// </summary>
		/// <param name="needSetChildrens">子にもレイヤー設定を行うか</param>
		public static void SetLayer (this GameObject gameObject, int layerNo, bool needSetChildrens = true)
		{
			if (gameObject == null) {
				return;
			}
			gameObject.layer = layerNo;

			//子に設定する必要がない場合はここで終了
			if (!needSetChildrens) {
				return;
			}

			//子のレイヤーにも設定する
			foreach (Transform childTransform in gameObject.transform) {
				SetLayer (childTransform.gameObject, layerNo, needSetChildrens);
			}
		}


		/// <summary>
		/// Layerを追加するクラス　空いている最大値のレイヤーを"STYLYcaputure"として追加する
		/// </summary>
		const string useCaptureTag = "SUITE.STYLY.CC.USE_CAPTURE";

		public static int CreateLayer ()
		{
			int layerNumber = 7;
			SerializedObject tagManager = new SerializedObject (AssetDatabase.LoadAllAssetsAtPath ("ProjectSettings/TagManager.asset") [0]);
			SerializedProperty layers = tagManager.FindProperty ("layers");

			//31番から順にレイヤーをみて、空白の場合にSTYLYcaputureレイヤーを設定する。
			for (int i = 31; i > 0; i--) {
				if ((layers.GetArrayElementAtIndex (i).stringValue == "" || layers.GetArrayElementAtIndex (i).stringValue.Equals (useCaptureTag)) && i > 7) {
					layers.GetArrayElementAtIndex (i).stringValue = useCaptureTag;
					layerNumber = i;
					break;
				}

				if (i == 7) {
					layerNumber = i;
					break;
				}
			}

			tagManager.ApplyModifiedProperties ();
			return layerNumber;
		}

	}
}