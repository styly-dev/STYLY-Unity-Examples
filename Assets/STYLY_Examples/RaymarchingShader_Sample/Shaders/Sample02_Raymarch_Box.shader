Shader "STYLY/Examples/Raymarching/02_Box"
{
	Properties
	{
		_MainTex ("Color Texture", 2D) = "white" {}
		_DistancePower("[Color] Distance Power", Float) = 2.0
		_DistanceScale("[Color] Distance Scale", Float) = 2.0

		[Space]
		_DistanceSmoothstep("[Color] Distance Smoothstep", Vector) = (0, 1, 0, 0)
		_CameraMoveVelocity("[Camera] Velocity(Move)", Vector) = (0.0, 0.0, 1.0)

		_CameraDegree_Up("[Camera] Rotation Up", Float) = 0.0
		_CameraDegree_Side("[Camera] Rotation Side", Float) = 0.0
		_CameraRotationVelocity_Up("[Camera] Velocity(Rotation Up)", Float) = 0.0
		_CameraRotationVelocity_Side("[Camera] Velocity(Rotation Side)", Float) = 0.0

		[Space]
		[Space]
		_ObjectInterval ("[Raymarching] Object Interval", Float) = 2.0
		_BoxScale ("[Raymarching] Box Scale", Float) = 1.0
		_BoxSize ("[Raymarching] Box Size", Vector) = (1, 1, 1, 0)
		_RaymarchStartDistance("[Raymarching] Raymarch Start Distance", Float) = 4.0
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

			// distance function (Box)
			// original: https://iquilezles.org/www/articles/distfunctions/distfunctions.htm
			float sdBox(float3 p, float3 b)
			{
				float3 d = abs(p) - b;
				return length(max(d,0.0))
						+ min(max(d.x,max(d.y,d.z)),0.0); // remove this line for an only partially signed sdf 
			}
			
            float distance_func(float3 p, float3 b, float interval) {
                p = frac(p / interval) * interval - interval / 2.0; // make repeat : -interval/2 ~ +interval/2
				return sdBox(p, b);
            }

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
			
			// camera parameter
			float _CameraDegree_Side;
			float _CameraDegree_Up;
			float3 _CameraMoveVelocity;
			float _CameraRotationVelocity_Up;
			float _CameraRotationVelocity_Side;

			// raymarching parameter
			float _ObjectInterval;
			float _BoxScale;
			float3 _BoxSize;
			float _RaymarchStartDistance;

			// color parameter
			fixed4 _DistanceSmoothstep;
			fixed _DistancePower;
			fixed _DistanceScale;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}


			// calculate normal vector
            float3 getNormal(float3 p, float size, float interval) {
                float2 e = float2(0.0001, 0.0);
                return normalize(float3(
                    distance_func(p + e.xyy, size, interval) - distance_func(p - e.xyy, size, interval),
                    distance_func(p + e.yxy, size, interval) - distance_func(p - e.yxy, size, interval),
                    distance_func(p + e.yyx, size, interval) - distance_func(p - e.yyx, size, interval)
                ));
            }

			// raymarch loop
			void raymarching(
				float2 uv,
				float3 cPos, float3 cDir, float3 cUp, float3 cSide,
				out float Hit, out float Distance, out float3 Normal)
			{
                #define RaymarchLoop 60
				#define ObjectSize (_BoxScale * _BoxSize)
				#define ObjectInterval (_ObjectInterval)
                float2 p = uv - 0.5;

                // raymarching
                float3 ray = normalize(p.x * cSide + p.y * cUp + 1.0 * cDir); // ray
                float3 rPos = cPos; // ray position
                float rLength = _RaymarchStartDistance; 
                float dist = 0.0; 
                for (int i = 0; i < RaymarchLoop; i++)
                {
                    dist = distance_func(rPos, ObjectSize, ObjectInterval);
                    rLength += dist; 
                    rPos = cPos + ray * rLength; 
                }

				// output
                Hit = step(dist, 0.01); // if ray hit object, output 1.0 
                Distance = rLength; // ray length
                Normal = saturate(getNormal(rPos, ObjectSize, ObjectInterval)); // normal
			}
			
			// fragment shader function
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				
				#define PI 3.1415926535

				// camera
				float3 cPos = _Time.z * _CameraMoveVelocity;
				float radian1 = -_CameraDegree_Up / 180.0 * PI + _CameraRotationVelocity_Up * _Time.z;
				float radian2 = _CameraDegree_Side / 180.0 * PI + _CameraRotationVelocity_Side * _Time.z;

				// rotation matrix
				float3x3 rot_xy = float3x3(
					float3(cos(radian2), -sin(radian2), 0.0),
					float3(sin(radian2), cos(radian2), 0.0),
					float3(0.0, 0.0, 1.0)
				);
				
				float3x3 rot = rot_xy;

				float3 cDir = float3(0.0, cos(radian1), sin(radian1));
				float3 cUp = float3(0.0, cos(radian1 + PI / 2.0), sin(radian1 + PI / 2.0));
				float3 cSide = cross(cDir, cUp);

				cDir = mul(rot, cDir);
				cUp = mul(rot, cUp);
				cSide = mul(rot, cSide);

				float Hit;
				float Distance;
				float3 Normal;

				raymarching(
					i.uv,
					cPos, cDir, cUp, cSide,
					Hit, Distance, Normal
				);

				Distance = 1.0 / (1.0 + Distance);
				Distance = pow(Distance, _DistancePower);
				Distance = Distance * _DistanceScale;
				Distance = smoothstep(_DistanceSmoothstep.x, _DistanceSmoothstep.y, Distance);
				Distance = 1.0 - Distance;
				Distance = clamp(Distance, 0.1, 1.0);

				return tex2D(_MainTex, Distance);
			}
			ENDCG
		}
	}
}
