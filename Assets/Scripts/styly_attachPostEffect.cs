using System.Collections;
using UnityEngine;
using UnityEngine.PostProcessing;

public class styly_attachPostEffect : MonoBehaviour {

    public GameObject mainCamera;
    public bool hdr;

    void OnEnable()
    {
        StartCoroutine(ApplyPostEffect());
    }

    void OnDisable()
    {
        OnDestroy();
    }

    // Use this for initialization
    IEnumerator ApplyPostEffect()
    {
        yield return null; yield return null;

        mainCamera = Camera.main.gameObject;

        // ポストエフェクトのクリア。
        clearPostEffects();

        // ポストエフェクトをアタッチする。
        PostProcessingBehaviour postProcessingBehaviour = (PostProcessingBehaviour)transform.GetComponent<PostProcessingBehaviour>();
        if (postProcessingBehaviour != null)
        {
            //Ambient occlusionをオフにする(透過防止)
            postProcessingBehaviour.profile.ambientOcclusion.enabled = false;

            CopyComponent(postProcessingBehaviour, mainCamera);
            mainCamera.GetComponent<PostProcessingBehaviour>().enabled = postProcessingBehaviour.enabled;
        }
        
        mainCamera.GetComponent<Camera>().allowHDR = hdr;
        Camera cam = GetComponent<Camera>();
        cam.enabled = false;
    }

    // コンポーネントのコピー
    void CopyComponent(Component original, GameObject destination)
    {
        System.Type type = original.GetType();
        Component copy = destination.AddComponent(type);
        CopyComponentField(original,copy);
    }

    // コンポーネントの各フィールドのコピー
    void CopyComponentField(Component original, Component destination)
    {
        System.Type type = original.GetType();
        System.Reflection.FieldInfo[] fields = type.GetFields();
        foreach (System.Reflection.FieldInfo field in fields)
        {
            field.SetValue(destination, field.GetValue(original));
        }
    }
    
    void OnDestroy()
    {
        clearPostEffects();
    }

    void clearPostEffects()
    {
        // アタッチしたすべてのポストエフェクトを削除する。
        if (mainCamera != null)
        {
            Destroy(mainCamera.GetComponent<PostProcessingBehaviour>());
            mainCamera.GetComponent<Camera>().allowHDR = false;
        }

    }
}
