Shader "STYLY/Examples/RotationMask_Scale" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_OverTex("Base Texture (RGB)", 2D) = "white" {}
		_MaskTex("Mask Texture (RGB)", 2D) = "white" {}
		_RotationSpeed("Rotation Speed", Float) = 1.0
		_ScaleSpeed("Scaling Speed", Float) = 4.0
		_ScaleMin("Min Scale", Float) = 0.1
		_ScaleMax("Max Scale", Float) = 1.0
	}
		SubShader{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM
			#pragma surface surf Standard fullforwardshadows
			#pragma target 3.0

			sampler2D _MaskTex;
			sampler2D _OverTex;

			struct Input {
				float2 uv_MaskTex;
				float2 uv_OverTex;
			};

			float _RotationSpeed;
			half _Glossiness;
			half _Metallic;
			float _ScaleMin;
			float _ScaleMax;
			float _ScaleSpeed;
			fixed4 _Color;

			#define ANGLE (_Time.z * _RotationSpeed)
			
			void surf(Input IN, inout SurfaceOutputStandard o) {
				fixed4 mask = tex2D(_MaskTex, IN.uv_MaskTex);
				clip(mask.r - 0.5); // do not draw if mask.r is less than 0.5

				fixed2 center = fixed2(0.5, 0.5);

				#define LerpT (0.5 + 0.5 * sin(_Time.y * _ScaleSpeed))
				
				float2x2 rotate = float2x2(cos(ANGLE), -sin(ANGLE), sin(ANGLE), cos(ANGLE));
				fixed2 uv_OverTex = mul(rotate, IN.uv_OverTex - center) / lerp(_ScaleMin, _ScaleMax, LerpT) + center;
				fixed4 over = tex2D(_OverTex, uv_OverTex);
				fixed4 c = mask * over * _Color;
				o.Emission = c.rgb;
			}
			ENDCG
		}
			FallBack "Diffuse"
}
