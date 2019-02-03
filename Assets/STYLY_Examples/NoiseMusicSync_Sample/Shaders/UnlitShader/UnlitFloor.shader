Shader "Unlit/UnlitFloor"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LineNum("Number of lines", Float) = 4
        _Speed("Speed", Float) = 32
        _LineSize("LineSize", Range(0, 1)) = 0.15

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            /////
            void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
            {
                Out = A - B;
            }

            void Unity_Absolute_float2(float2 In, out float2 Out)
            {
                Out = abs(In);
            }

            void Unity_Maximum_float(float A, float B, out float Out)
            {
                Out = max(A, B);
            }

            void Unity_Multiply_float (float A, float B, out float Out)
            {
                Out = A * B;
            }

            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }

            void Unity_Fraction_float(float In, out float Out)
            {
                Out = frac(In);
            }

            void Unity_Step_float(float Edge, float In, out float Out)
            {
                Out = step(Edge, In);
            }

            fixed4 frag (v2f IN) : SV_Target
            {
                float2 _UV_112F68A5_Out = IN.uv;
                float2 _Vector2_11FDACA3_Out = float2(0.5,0.5);
                float2 _Subtract_EDFDE4F2_Out;
                Unity_Subtract_float2((_UV_112F68A5_Out.xy), _Vector2_11FDACA3_Out, _Subtract_EDFDE4F2_Out);
                float2 _Absolute_90361E51_Out;
                Unity_Absolute_float2(_Subtract_EDFDE4F2_Out, _Absolute_90361E51_Out);
                float _Split_F68C970F_R = _Absolute_90361E51_Out[0];
                float _Split_F68C970F_G = _Absolute_90361E51_Out[1];
                float _Maximum_BEC23721_Out;
                Unity_Maximum_float(_Split_F68C970F_R, _Split_F68C970F_G, _Maximum_BEC23721_Out);
                float _Multiply_9CDB8D83_Out;
                Unity_Multiply_float(_Maximum_BEC23721_Out, 2, _Multiply_9CDB8D83_Out);

                float _Property_8FE489E0_Out = _LineNum;
                float _Multiply_18F99657_Out;
                Unity_Multiply_float(_Multiply_9CDB8D83_Out, _Property_8FE489E0_Out, _Multiply_18F99657_Out);

                float _Property_CC85460B_Out = _Speed;
                float _Multiply_A1BAC744_Out;
                Unity_Multiply_float(_Time.y, _Property_CC85460B_Out, _Multiply_A1BAC744_Out);

                float _Subtract_ECB0F605_Out;
                Unity_Subtract_float(_Multiply_18F99657_Out, _Multiply_A1BAC744_Out, _Subtract_ECB0F605_Out);
                float _Fraction_C69C32D_Out;
                Unity_Fraction_float(_Subtract_ECB0F605_Out, _Fraction_C69C32D_Out);
                float _Property_785E906_Out = _LineSize;
                float _Step_D581C05D_Out;
                Unity_Step_float(_Fraction_C69C32D_Out, _Property_785E906_Out, _Step_D581C05D_Out);

                return _Step_D581C05D_Out * 0.5;
            }
            ENDCG
        }
    }
}
