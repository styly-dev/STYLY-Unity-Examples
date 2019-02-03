Shader "Unlit/UnlitSpreadLine"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        Vector1_A4D87F7C("Resolution", Float) = 4
        _BarOffset("BarOffset", Float) = 0
        Vector2_2258C59F("BarRange", Vector) = (0,1,0,0)
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
            float Vector1_A4D87F7C;
            float _BarOffset;
            float2 Vector2_2258C59F;
            
            ///
            
            void Unity_Preview_float(float In, out float Out)
            {
                Out = In;
            }

            void Unity_Multiply_float (float A, float B, out float Out)
            {
                Out = A * B;
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

            void Unity_Sine_float(float In, out float Out)
            {
                Out = sin(In);
            }

            void Unity_Add_float2(float2 A, float2 B, out float2 Out)
            {
                Out = A + B;
            }

            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }

            void Unity_Step_float(float Edge, float In, out float Out)
            {
                Out = step(Edge, In);
            }


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f IN) : SV_Target
            {
                float2 _UV_5E4EE28E_Out = IN.uv;
                float _Split_F99731F8_R = _UV_5E4EE28E_Out[0];
                float _Split_F99731F8_G = _UV_5E4EE28E_Out[1];
                float _Preview_DE9A8F54_Out;
                Unity_Preview_float(_Split_F99731F8_G, _Preview_DE9A8F54_Out);
                float _Multiply_4D53033F_Out;
                Unity_Multiply_float(_Time.y, 16, _Multiply_4D53033F_Out);

                float _Property_4B6D1AB2_Out = Vector1_A4D87F7C;
                float _Posterize_176B8DB9_Out;
                Unity_Posterize_float(_Split_F99731F8_R, _Property_4B6D1AB2_Out, _Posterize_176B8DB9_Out);
                float _SimpleNoise_6A7A318A_Out;
                Unity_SimpleNoise_float((_Posterize_176B8DB9_Out.xx), 500, _SimpleNoise_6A7A318A_Out);
                float _Multiply_1DAE818_Out;
                Unity_Multiply_float(_SimpleNoise_6A7A318A_Out, 17, _Multiply_1DAE818_Out);

                float _Add_761EC09C_Out;
                Unity_Add_float(_Multiply_4D53033F_Out, _Multiply_1DAE818_Out, _Add_761EC09C_Out);
                float _Sine_2A1E91E1_Out;
                Unity_Sine_float(_Add_761EC09C_Out, _Sine_2A1E91E1_Out);
                float2 _Property_3152B9B7_Out = Vector2_2258C59F;
                float _Property_2C5EC1E8_Out = _BarOffset;
                float2 _Add_7E50B841_Out;
                Unity_Add_float2(_Property_3152B9B7_Out, (_Property_2C5EC1E8_Out.xx), _Add_7E50B841_Out);
                float _Remap_C4E4076A_Out;
                Unity_Remap_float(_Sine_2A1E91E1_Out, float2 (-1,1), _Add_7E50B841_Out, _Remap_C4E4076A_Out);
                float _Step_EAEF37DE_Out;
                Unity_Step_float(_Preview_DE9A8F54_Out, _Remap_C4E4076A_Out, _Step_EAEF37DE_Out);

                return _Step_EAEF37DE_Out * 0.5;
            }
            ENDCG
        }
    }
}
