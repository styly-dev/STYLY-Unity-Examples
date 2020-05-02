// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TextureExample/NormalMix"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[Normal]_NormalMap1("NormalMap1", 2D) = "bump" {}
		_Normal1Scale("Normal1Scale", Range( -2 , 2)) = 1
		[Normal]_NormalMap2("NormalMap2", 2D) = "bump" {}
		_Normal2Scale("Normal2Scale", Range( -2 , 2)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Normal1Scale;
		uniform sampler2D _NormalMap1;
		uniform float4 _NormalMap1_ST;
		uniform float _Normal2Scale;
		uniform sampler2D _NormalMap2;
		uniform float4 _NormalMap2_ST;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalMap1 = i.uv_texcoord * _NormalMap1_ST.xy + _NormalMap1_ST.zw;
			float2 uv_NormalMap2 = i.uv_texcoord * _NormalMap2_ST.xy + _NormalMap2_ST.zw;
			o.Normal = BlendNormals( UnpackScaleNormal( tex2D( _NormalMap1, uv_NormalMap1 ), _Normal1Scale ) , UnpackScaleNormal( tex2D( _NormalMap2, uv_NormalMap2 ), _Normal2Scale ) );
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			o.Albedo = tex2D( _TextureSample0, uv_TextureSample0 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
7;29;1906;1004;2182.771;1269.534;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;4;-1792.101,-617.0839;Inherit;False;Property;_Normal2Scale;Normal2Scale;4;0;Create;True;0;0;False;0;1;1;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-1792,-876.442;Inherit;False;Property;_Normal1Scale;Normal1Scale;2;0;Create;True;0;0;False;0;1;1;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1445,-918;Inherit;True;Property;_NormalMap1;NormalMap1;1;1;[Normal];Create;True;0;0;False;0;-1;f2f0a92b40d6bac4cb641cb1529921bd;f2f0a92b40d6bac4cb641cb1529921bd;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-1450.101,-663.0839;Inherit;True;Property;_NormalMap2;NormalMap2;3;1;[Normal];Create;True;0;0;False;0;-1;bcf28f6c1c3759d4aa9c2772d042eb62;f2f0a92b40d6bac4cb641cb1529921bd;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-1444.497,-1137.028;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;5;-1078.461,-819.0142;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-636.4001,-954;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;TextureExample/NormalMix;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;1;5;2;0
WireConnection;3;5;4;0
WireConnection;5;0;1;0
WireConnection;5;1;3;0
WireConnection;0;0;6;0
WireConnection;0;1;5;0
ASEEND*/
//CHKSM=26B57F2BF21D1A854BB3AC04008AF58FBF068C9A