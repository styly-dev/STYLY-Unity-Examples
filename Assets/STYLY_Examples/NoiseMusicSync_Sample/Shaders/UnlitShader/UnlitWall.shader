Shader "Unlit/UnlitWall"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LineNum("Number of lines", Float) = 4
        _Speed("Speed", Float) = 32
        _LineSize("LineSize", Range(0, 1)) = 0.15
        _GlitchScale("GlitchScale", Float) = 1
        _GlitchNum("GlitchNum", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
            float _LineNum;
            float _Speed;
            float _LineSize;
            float _GlitchScale;
            float _GlitchNum;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            /// ported from ShaderGraph ////////////////////////////////
            void Unity_Multiply_float (float A, float B, out float Out)
            {
                Out = A * B;
            }

            void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
            {
                Out = A - B;
            }

            void Unity_Posterize_float(float In, float Steps, out float Out)
            {
                Out = floor(In / (1 / Steps)) * (1 / Steps);
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

            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }

            void Unity_Fraction_float(float In, out float Out)
            {
                Out = frac(In);
            }

            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }

            void Unity_Step_float(float Edge, float In, out float Out)
            {
                Out = step(Edge, In);
            }
            ///

            fixed4 frag (v2f IN) : SV_Target
            {
                float _Property_CC85460B_Out = _Speed;
                float _Multiply_A1BAC744_Out;
                Unity_Multiply_float(_Time.y, _Property_CC85460B_Out, _Multiply_A1BAC744_Out);

                float2 _UV_112F68A5_Out = IN.uv;
                float2 _Vector2_11FDACA3_Out = float2(0.5,0.5);
                float2 _Subtract_EDFDE4F2_Out;
                Unity_Subtract_float2((_UV_112F68A5_Out.xy), _Vector2_11FDACA3_Out, _Subtract_EDFDE4F2_Out);
                float _Split_F68C970F_R = _Subtract_EDFDE4F2_Out[0];
                float _Split_F68C970F_G = _Subtract_EDFDE4F2_Out[1];
                float _Property_84E2BE16_Out = _GlitchNum;
                float _Posterize_33780A5D_Out;
                Unity_Posterize_float(_Split_F68C970F_R, _Property_84E2BE16_Out, _Posterize_33780A5D_Out);
                float _SimpleNoise_73DD96B3_Out;
                Unity_SimpleNoise_float((_Posterize_33780A5D_Out.xx), 500, _SimpleNoise_73DD96B3_Out);
                float _Property_6CACAFBB_Out = _GlitchScale;
                float _Multiply_310D6BD0_Out;
                Unity_Multiply_float(_SimpleNoise_73DD96B3_Out, _Property_6CACAFBB_Out, _Multiply_310D6BD0_Out);

                float _Property_8FE489E0_Out = _LineNum;
                float _Multiply_18F99657_Out;
                Unity_Multiply_float(_Split_F68C970F_G, _Property_8FE489E0_Out, _Multiply_18F99657_Out);

                float _Add_5A53C7D6_Out;
                Unity_Add_float(_Multiply_310D6BD0_Out, _Multiply_18F99657_Out, _Add_5A53C7D6_Out);
                float _Add_9D8494F8_Out;
                Unity_Add_float(_Multiply_A1BAC744_Out, _Add_5A53C7D6_Out, _Add_9D8494F8_Out);
                float _Fraction_C69C32D_Out;
                Unity_Fraction_float(_Add_9D8494F8_Out, _Fraction_C69C32D_Out);
                float _Property_785E906_Out = _LineSize;
                float _Subtract_84B30387_Out;
                Unity_Subtract_float(_Property_785E906_Out, 0.001, _Subtract_84B30387_Out);
                float _Step_D581C05D_Out;
                Unity_Step_float(_Fraction_C69C32D_Out, _Subtract_84B30387_Out, _Step_D581C05D_Out);

                return _Step_D581C05D_Out * 0.5;
            }
            ENDCG
        }
    }
}
