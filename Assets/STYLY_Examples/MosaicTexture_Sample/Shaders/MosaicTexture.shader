Shader "STYLY/Examples/Mosaic" {
	Properties{
		_MainTex("Texture", 2D) = "white" {}
		[Space]
		_Color("Main Color", Color) = (1,1,1,1)
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,1)
		_MosaicResolution("Mosaic Resolution", Range(2, 64)) = 32
		_MosaicResolutionX("X Mosaic Resolution", Range(1, 4)) = 1
		_MosaicResolutionY("Y Mosaic Resolution", Range(1, 4)) = 1

		[Space]
		_Glossiness("Smoothness", Range(0,1)) = 0
		_Metallic("Metallic", Range(0,1)) = 0
	}
	SubShader{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half4 _Color;
		half4 _EmissionColor;

		half _Glossiness;
		half _Metallic;
		int _MosaicResolution;
		int _MosaicResolutionX;
		int _MosaicResolutionY;

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

#define MOSAIC (_MosaicResolution * float2(_MosaicResolutionX, _MosaicResolutionY))

		// Surface Shader
		void surf(Input IN, inout SurfaceOutputStandard o) {
			float2 uv = IN.uv_MainTex;
			uv = floor(uv * MOSAIC) / MOSAIC;

			fixed4 c = tex2D(_MainTex, uv);
			o.Albedo = c.rgb * _Color;
			o.Emission = c.rgb * _EmissionColor;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = 1.0;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
