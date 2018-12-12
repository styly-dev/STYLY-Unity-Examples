// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/Colour By Height"
{
	//Created By Jason Beetham
    Properties
	{
        _First("Highest Point",float) = 1
		_Second("Second Heighest",float) = 1
		_Third("Third Heighest",float) = 1
		_Fourth("Fourth Heighest",float) = 1
		_FirstC("Highest Point Colour", Color) = (0,0,0,1)
		_SecondC("Second Heighest Colour",Color) = (0,0,0,1)
		_ThirdC("Third Colour",Color) = (0,0,0,1)
		_FourthC("Fourth Colour",Color) = (0,0,0,1)
		_FifthC("Fifth Colour",Color) = (0,0,0,1)
	}
		SubShader
		{
        Lighting on
        Pass
			{
            Cull Back
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "AutoLight.cginc"
				#pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
			   struct appdata
			{
                float2 uv : TEXCOORD0;
                fixed4 diff : COLOR;
                float3 normal : NORMAL;
                float4 vertex : POSITION;
            }




;
            struct v2f
			{
                float2 uv : TEXCOORD0;
				fixed4 diff : COLOR;
				nointerpolation float3 normal : NORMAL;
                float4 vertex : POSITION;
            }




;
            float4 _FirstC;
            float4 _SecondC;
            float4 _ThirdC;
            float4 _FourthC;
            float4 _FifthC;
            float _Scale;
            float _First;
            float _Second;
            float _Third;
            float _Fourth;
            float _Fifth;
			float4 _Position;
            v2f vert(appdata v)
			{
				float4 tempPos = mul(unity_ObjectToWorld, float4(0,0,0,1));
				_Position = mul( unity_WorldToObject,tempPos);
                v2f OUT;
				OUT.normal = v.normal;
                OUT.vertex = UnityObjectToClipPos(v.vertex);
                if (v.vertex.y >= _First) {
					OUT.diff = lerp(_FirstC,_SecondC,(_First /v.vertex.y) +.1f);
                }


				else if (v.vertex.y >= _Second && v.vertex.y < _First) {
					OUT.diff = lerp(_ThirdC,_SecondC, (v.vertex.y / _First));

                }


				else if (v.vertex.y >= _Third && v.vertex.y < _Second) {
                   OUT.diff = lerp(_FourthC,_ThirdC, (v.vertex.y / _Second));
                }


				else if (v.vertex.y <= _Third && v.vertex.y > _Fourth){
                     OUT.diff = lerp(_ThirdC,_FourthC, (v.vertex.y / _Third));
                }

				else {
                    OUT.diff = _FifthC;
                }

                return OUT;
            }





				fixed4 frag(v2f i) : SV_Target
				{
                float4 col = i.diff;
                return col;
            }

ENDCG
}
}
}