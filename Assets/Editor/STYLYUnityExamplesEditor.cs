using UnityEngine;
using UnityEditor;
using System;
using System.Reflection;
using UnityEditor.Callbacks;
using System.Collections.Generic;

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
            AddSymbol(POST_PROCESSING_DEFINE);
        }
        else
        {
            RemoveSymbol(POST_PROCESSING_DEFINE);
        }
    }

    private static List<string> GetDefineSymbols()
    {
        return new List<string>(PlayerSettings.GetScriptingDefineSymbolsForGroup(BuildPipeline.GetBuildTargetGroup(EditorUserBuildSettings.activeBuildTarget)).Split(';'));
    }

    private static void AddSymbol(string symbol)
    {
        var symbolList = GetDefineSymbols();

        if( symbolList.IndexOf(symbol) < 0 )
        {
            Debug.Log("add symbol");
            symbolList.Add(symbol);
            SetDefineSymbols(symbolList);
        }
        
    }

    private static void RemoveSymbol(string symbol)
    {
        var symbolList = GetDefineSymbols();
        
        symbolList.Remove(symbol);

        SetDefineSymbols(symbolList);
    }

    private static void SetDefineSymbols(List<string> symbols)
    {
        PlayerSettings.SetScriptingDefineSymbolsForGroup(BuildPipeline.GetBuildTargetGroup(EditorUserBuildSettings.activeBuildTarget), string.Join(";", symbols.ToArray()));
    }
}
