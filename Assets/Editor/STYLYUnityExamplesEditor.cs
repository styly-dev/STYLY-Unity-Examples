using UnityEngine;
using UnityEditor;
using System;
using System.Reflection;
using UnityEditor.Callbacks;

[InitializeOnLoad]
public class STYLYUnityExamplesEditor : MonoBehaviour
{
    const string POST_PROCESSING_DEFINE = "POSTPROCESSINGSTACK";

    static STYLYUnityExamplesEditor()
    {
        if (EditorApplication.isPlayingOrWillChangePlaymode)
        {
            return;
        }

        UpdateScriptingDefineSymbols();
    }

    public void OnActiveBuildTargetChanged(BuildTarget previousTarget, BuildTarget newTarget)
    {
        UpdateScriptingDefineSymbols();
    }


    [DidReloadScripts]
    public static void UpdateScriptingDefineSymbols()
    {
        if (EditorApplication.isPlayingOrWillChangePlaymode)
        {
            return;
        }

        bool isPostProcessingStackImported = false;

        foreach (var assembly in AppDomain.CurrentDomain.GetAssemblies())
        {
            try
            {
                var type = assembly.GetType("UnityEngine.PostProcessing.PostProcessingBehaviour");
                if( type != null )
                {
                    isPostProcessingStackImported = true;
                    break;
                }
            }
            catch (Exception e)
            {
                Debug.LogError(e);
            }
        }

        if (isPostProcessingStackImported)
        {
            PlayerSettings.SetScriptingDefineSymbolsForGroup(BuildPipeline.GetBuildTargetGroup(EditorUserBuildSettings.activeBuildTarget), POST_PROCESSING_DEFINE);
        }
        else
        {
            PlayerSettings.SetScriptingDefineSymbolsForGroup(BuildPipeline.GetBuildTargetGroup(EditorUserBuildSettings.activeBuildTarget), "");
        }
    }
}
