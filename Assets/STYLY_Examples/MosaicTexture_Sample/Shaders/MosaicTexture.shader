Shader "Custom/MosaicTexture" {
	Properties{
		_MainTex("テクスチャ", 2D) = "white" {}
		[Space]
		_Color("カラー", Color) = (1,1,1,1)
		[HDR]_EmissionColor("発光カラー", Color) = (0,0,0,1)
		_MosaicResolution("モザイクの細かさ", Range(2, 512)) = 32

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

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)
			
		// 2D Random
		float random(float2 st) {
			return frac((sin(dot(st.xy, float2(12.9898, 78.233)))) * 43758.5453123);
		}

		void surf(Input IN, inout SurfaceOutputStandard o) {
			float2 uv = IN.uv_MainTex;
			uv = floor(uv * _MosaicResolution) / _MosaicResolution;

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
