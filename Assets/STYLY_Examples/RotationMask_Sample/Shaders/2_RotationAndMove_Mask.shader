Shader "STYLY/Examples/RotationMask_Move" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_OverTex("Base Texture (RGB)", 2D) = "white" {}
		_MaskTex("Mask Texture (RGB)", 2D) = "white" {}
		_RotationSpeed("Rotation Speed", Float) = 1.0
		_MoveScale("Moving Scale", Float) = 0.5
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
			half _MoveScale;
			fixed4 _Color;

			#define ANGLE (_Time.z * _RotationSpeed)

			void surf(Input IN, inout SurfaceOutputStandard o) {
				fixed4 mask = tex2D(_MaskTex, IN.uv_MaskTex);
				clip(mask.r - 0.5); // do not draw if mask.r is less than 0.5

				fixed2 center = fixed2(
					0.5 + 0.5 * cos(_Time.y) * _MoveScale, 
					0.5 + 0.5 * sin(_Time.y) * _MoveScale
				);
				
				float2x2 rotate = float2x2(cos(ANGLE), -sin(ANGLE), sin(ANGLE), cos(ANGLE));
				fixed2 uv_OverTex = mul(rotate, IN.uv_OverTex - center) + center;
				fixed4 over = tex2D(_OverTex, uv_OverTex);
				fixed4 c = mask * over * _Color;
				o.Emission = c.rgb;
			}
			ENDCG
		}
			FallBack "Diffuse"
}
