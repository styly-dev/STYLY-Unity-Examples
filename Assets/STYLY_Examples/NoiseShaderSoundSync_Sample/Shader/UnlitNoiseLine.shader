Shader "STYLY/Examples/UnlitNoiseLine"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _Speed("Speed", Float) = 1
        _Scale("Scale", Float) = 1
        _Power("Power", Float) = 1
        _WhiteSmoothstep("WhiteSmoothstep", Vector) = (0,0.73,0,0)
        _Flash("Flash", Float) = 0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
        Cull Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
            float _Speed;
            float _Scale;
            float _Power;
            float2 _WhiteSmoothstep;
            float _Flash;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
            void Unity_OneMinus_float(float In, out float Out)
            {
                Out = 1 - In;
            }

            void Unity_Multiply_float (float A, float B, out float Out)
            {
                Out = A * B;
            }

            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }

            void Unity_Fraction_float(float In, out float Out)
            {
                Out = frac(In);
            }


			inline float unity_noise_randomValue (float2 uv)
			{
				return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453);
			}

			inline float unity_noise_interpolate (float a, float b, float t)
			{
				return (1.0-t)*a + (t*b);
			}

            inline float unity_valueNoise (float2 uv)
            {
                float2 i = floor(uv);
                float2 f = frac(uv);
                f = f * f * (3.0 - 2.0 * f);

                uv = abs(frac(uv) - 0.5);
                float2 c0 = i + float2(0.0, 0.0);
                float2 c1 = i + float2(1.0, 0.0);
                float2 c2 = i + float2(0.0, 1.0);
                float2 c3 = i + float2(1.0, 1.0);
                float r0 = unity_noise_randomValue(c0);
                float r1 = unity_noise_randomValue(c1);
                float r2 = unity_noise_randomValue(c2);
                float r3 = unity_noise_randomValue(c3);

                float bottomOfGrid = unity_noise_interpolate(r0, r1, f.x);
                float topOfGrid = unity_noise_interpolate(r2, r3, f.x);
                float t = unity_noise_interpolate(bottomOfGrid, topOfGrid, f.y);
                return t;
            }
            void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
            {
                float t = 0.0;

                float freq = pow(2.0, float(0));
                float amp = pow(0.5, float(3-0));
                t += unity_valueNoise(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

                freq = pow(2.0, float(1));
                amp = pow(0.5, float(3-1));
                t += unity_valueNoise(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

                freq = pow(2.0, float(2));
                amp = pow(0.5, float(3-2));
                t += unity_valueNoise(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

                Out = t;
            }

            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }

            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }

            // fragment shader (generated from ShaderGraph)
			fixed4 frag (v2f IN) : SV_Target
			{
                float2 _Property_41A71C93_Out = _WhiteSmoothstep;
                float _Split_473FEB97_R = _Property_41A71C93_Out[0];
                float _Split_473FEB97_G = _Property_41A71C93_Out[1];
                float _Split_473FEB97_B = 0;
                float _Split_473FEB97_A = 0;
                float2 _UV_5F77B104_Out = IN.uv;
                float _Split_98159120_R = _UV_5F77B104_Out[0];
                float _Split_98159120_G = _UV_5F77B104_Out[1];
                float _OneMinus_43F7D767_Out;
                Unity_OneMinus_float(_Split_98159120_R, _OneMinus_43F7D767_Out);
                float _Property_6FE9187A_Out = _Speed;
                float _Multiply_45C26CD1_Out;
                Unity_Multiply_float(_Time.y, _Property_6FE9187A_Out, _Multiply_45C26CD1_Out);

                float _Add_B44D19F9_Out;
                Unity_Add_float(_OneMinus_43F7D767_Out, _Multiply_45C26CD1_Out, _Add_B44D19F9_Out);
                float _Property_70D22DB_Out = _Scale;
                float _Multiply_E6CED770_Out;
                Unity_Multiply_float(_Add_B44D19F9_Out, _Property_70D22DB_Out, _Multiply_E6CED770_Out);

                float _Fraction_9BA67C4E_Out;
                Unity_Fraction_float(_Multiply_E6CED770_Out, _Fraction_9BA67C4E_Out);
                float _OneMinus_9C928D24_Out;
                Unity_OneMinus_float(_Fraction_9BA67C4E_Out, _OneMinus_9C928D24_Out);
                float _SimpleNoise_17DE7016_Out;
                Unity_SimpleNoise_float((_OneMinus_9C928D24_Out.xx), 500, _SimpleNoise_17DE7016_Out);
                float _Property_D5DE9247_Out = _Power;
                float _Power_B969E228_Out;
                Unity_Power_float(_SimpleNoise_17DE7016_Out, _Property_D5DE9247_Out, _Power_B969E228_Out);
                float _SimpleNoise_9ED932F7_Out;
                Unity_SimpleNoise_float((_Time.y.xx), 500, _SimpleNoise_9ED932F7_Out);
                float _Smoothstep_45C667DC_Out;
                Unity_Smoothstep_float(0, 0.88, _SimpleNoise_9ED932F7_Out, _Smoothstep_45C667DC_Out);
                float _Multiply_DEAC41C9_Out;
                Unity_Multiply_float(_Power_B969E228_Out, _Smoothstep_45C667DC_Out, _Multiply_DEAC41C9_Out);

                float _Property_2F975337_Out = _Flash;
                float _Add_CCF15F8B_Out;
                Unity_Add_float(_Multiply_DEAC41C9_Out, _Property_2F975337_Out, _Add_CCF15F8B_Out);
                float _Smoothstep_6984D979_Out;
                Unity_Smoothstep_float(_Split_473FEB97_R, _Split_473FEB97_G, _Add_CCF15F8B_Out, _Smoothstep_6984D979_Out);

                _Smoothstep_6984D979_Out = _Smoothstep_6984D979_Out * 0.35;

                return _Smoothstep_6984D979_Out;
			}
			ENDCG
		}
	}
}
