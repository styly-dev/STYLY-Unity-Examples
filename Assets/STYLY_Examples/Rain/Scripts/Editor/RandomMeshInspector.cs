using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;
using System.IO;

// エディター拡張
[CustomEditor(typeof(RandomMesh))]
public class RandomMeshInspector : Editor
{
    const string k_ExportMeshName = "[Generated]RainMesh.asset"; // 保存するメッシュの名前
    static readonly Color k_ButtonColor = Color.yellow;
    static readonly Color k_ButtonTextColor = Color.white;

    /// <summary>
    /// インスペクタの描画
    /// </summary>
    public override void OnInspectorGUI()
    {
        if (PrefabUtility.GetPrefabType(target) != PrefabType.Prefab)
        {
            EditorGUILayout.HelpBox("雨の設定はPrefab上でのみ可能です。 \nYou must edit settings via Prefab.", MessageType.Info);
            return;
        }

        var defaultColor = GUI.color;
        var defaultContentColor = GUI.contentColor;

        var randomMesh = target as RandomMesh;

        // メッシュ情報 表示
        EditorGUILayout.BeginVertical("Box");
        EditorGUILayout.LabelField(randomMesh.OnCreateText, GUILayout.Height(54f));
        EditorGUILayout.EndVertical();

        // 色を変更
        GUI.color = k_ButtonColor;
        GUI.contentColor = k_ButtonTextColor;

        if (PrefabUtility.GetPrefabType(target) == PrefabType.Prefab)
        {
            if (GUILayout.Button("メッシュの更新"))
            {
                EditorCreateMesh();
            }
        }

        // 元に戻す
        GUI.color = defaultColor;
        GUI.contentColor = defaultContentColor;

        base.DrawDefaultInspector();
    }

    /// <summary>
    /// メッシュを作成し、保存する
    /// </summary>
    [ContextMenu("Create Mesh")]
    void EditorCreateMesh()
    {
        var randomMesh = target as RandomMesh;
        var meshFilter = randomMesh.GetComponent<MeshFilter>();

        // メッシュ作成
        var newMesh = randomMesh.CreateNewMesh();
        var assetPath = GenerateMeshPath();
        AssetDatabase.CreateAsset(newMesh, assetPath);
        randomMesh.GetComponent<MeshFilter>().sharedMesh = newMesh;

        randomMesh.OnCreateText = string.Format(
            "【現在のメッシュ情報】\n・雨の粒の数:{0}\n・雨の粒の大きさ:{1}\n・雨を降らせる範囲: {2}",
            randomMesh.TriangleCount,
            randomMesh.TriangleScale,
            randomMesh.MeshScale
        );

        // メッシュ保存
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
    }

    /// <summary>
    /// メッシュの保存パスを生成(Prefabと同階層)
    /// </summary>
    string GenerateMeshPath()
    {
        var path = AssetDatabase.GetAssetPath(target);
        var parentFullPath = Directory.GetParent(path).FullName;
        var parentPath = "Assets" + parentFullPath.Substring(Application.dataPath.Length);
        var assetPath = parentPath + Path.DirectorySeparatorChar + k_ExportMeshName; // アセットの保存先パス
        return assetPath;
    }
}