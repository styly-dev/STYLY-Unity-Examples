Shader "STYLY/Examples/TwistEffectShader"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {} // main color texture
		_MaskTex ("Mask Texture", 2D) = "white" {} // mask texture
		_Color ("Color", Color) = (1, 1, 1, 1)
		_Twist ("UV Twist", Float) = 0.0 // uv twist 
		_ScrollSpeedX ("Scroll Speed X", Float) = 0.0 // uv scroll speed x 
		_ScrollSpeedY ("Scroll Speed Y", Float) = 0.0 // uv scroll speed y 
		_Power("Power", float) = 1.0   
		_SmoothstepEdge1("Smoothstep Edge 1", float) = 0.0
		_SmoothstepEdge2("Smoothstep Edge 2", float) = 1.0
	}
	SubShader
	{
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" } 
        LOD 100 //

        ZWrite Off 
        Blend SrcAlpha One
		
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv_main : TEXCOORD0;
				float2 uv_mask : TEXCOORD1;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			sampler2D _MaskTex;
			float4 _MainTex_ST;
			float4 _MaskTex_ST;
			fixed4 _Color;
			half _ScrollSpeedX;
			half _ScrollSpeedY;
			half _Twist;
			half _Power;
			fixed _SmoothstepEdge1;
			fixed _SmoothstepEdge2;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv_main = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv_mask = TRANSFORM_TEX(v.uv, _MaskTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 mask = tex2D(_MaskTex, i.uv_mask);
				fixed4 col = tex2D(_MainTex, i.uv_main + float2(_Twist * i.uv_main.y, 0.0) + float2(_Time.y * _ScrollSpeedX, _Time.y * _ScrollSpeedY));
				col = pow(col, _Power) * mask;
				
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				
				col.a = smoothstep(_SmoothstepEdge1, _SmoothstepEdge2, col.a);
				return col * _Color;
			}
			ENDCG
		}
	}
}
