using UnityEngine;
using System.Collections.Generic;
#if UNITY_EDITOR
using UnityEditor;
#endif

[RequireComponent(typeof(MeshRenderer))]
[RequireComponent(typeof(MeshFilter))]
public class RandomMesh : MonoBehaviour
{
    const string k_MeshName = "[Generated]RainMesh"; // メッシュの名前
    [SerializeField, Header("雨粒の数")] int m_TriangleCount = 1500; // 三角形の個数
    [SerializeField, Header("雨粒の大きさ")] float m_TriangleScale = 0.02f; // 三角形の大きさ
    [SerializeField, Header("雨を降らせる範囲")] Vector3 m_MeshScale = new Vector3(4f, 4f, 4f); // メッシュの大きさ
    [SerializeField, HideInInspector] string m_OnCreateText = "メッシュ情報がありません\nメッシュを更新してください";

    public int TriangleCount { get { return m_TriangleCount; } }
    public float TriangleScale { get { return m_TriangleScale; } }
    public Vector3 MeshScale { get { return m_MeshScale; } }
    public string OnCreateText { get { return m_OnCreateText; } set { m_OnCreateText = value; } }

    /// <summary>
    /// メッシュの新規作成 
    /// </summary>
    public Mesh CreateNewMesh()
    {
        Vector3[] vertices = new Vector3[m_TriangleCount * 3]; // 頂点の座標
        int[] triangles = new int[m_TriangleCount * 3]; // 頂点インデックス

        int pos = 0;
        for (int i = 0; i < m_TriangleCount; i++)
        {
            var v1 = Vector3.Scale(new Vector3(Random.value, Random.value, Random.value) - Vector3.one * 0.5f, m_MeshScale);
            var v2 = v1 + new Vector3(Random.value - 0.5f, 0f, Random.value - 0.5f) * m_TriangleScale;
            var v3 = v1 + new Vector3(Random.value - 0.5f, 0f, Random.value - 0.5f) * m_TriangleScale;

            vertices[pos + 0] = v1;
            vertices[pos + 1] = v2;
            vertices[pos + 2] = v3;
            pos += 3;
        }

        for (int i = 0; i < triangles.Length; i++)
        {
            triangles[i] = i;
        }

        //メッシュ生成
        var mesh = new Mesh();
        mesh.vertices = vertices;
        mesh.triangles = triangles;

        return mesh;
    }

}
