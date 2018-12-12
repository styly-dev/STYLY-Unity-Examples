using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace STYLY.Uploader
{
	public class Config
	{
		public static string[] UNITY_VERSIONS = {"2017.4" };

		/// <summary>
		/// STYLYアセット対象プラットフォームリスト
		/// アセットバンドルのビルド対象として利用
		/// </summary>
		public static RuntimePlatform[] PlatformList = new RuntimePlatform[] {
			RuntimePlatform.Android,
			RuntimePlatform.IPhonePlayer,
			RuntimePlatform.OSXPlayer,
			RuntimePlatform.WebGLPlayer,
			RuntimePlatform.WindowsPlayer
		};

		/// <summary>
		/// STYLYアセットに変換可能な拡張子一覧
		/// </summary>
		public static string[] AcceptableExtentions = new string[] {
			".prefab",
			".obj",
			".fbx",
			".skp",
            ".unity"
		};

		//禁止タグ
		public static string[] ProhibitedTags = new string[] {
			"MainCamera",
			"sphere",
			"FxTemporaire",
			"TeleportIgnore",
			"Fire",
			"projectile",
			"GameController",
			"EditorOnly",
			"Finish",
			"Respawn"
		};




        /// <summary>upload prefab</summary>
        public static string STYLY_TEMP_DIR = "styly_temp";
        public static string UploadPrefabName = "Assets/" + STYLY_TEMP_DIR + "/{0}.prefab";

        /// <summary>一時出力フォルダ</summary>
        public static string OutputPath = "_Output/";
//		public static string AzureSignedUrls = "http://localhost:8999/api/v1/azure/unity_plugin/signed-url";
//		public static string StylyAssetUploadCompleteUrl = "http://localhost:8999/api/v1/scene/unity_plugin/complete";
		public static string AzureSignedUrls = "https://webeditor.styly.cc/api/v1/azure/unity_plugin/signed-url";
		public static string StylyAssetUploadCompleteUrl = "https://webeditor.styly.cc/api/v1/scene/unity_plugin/complete";
		public static int ThumbnailWidth = 640;
		public static int ThumbnailHeight = 480;
	}
}