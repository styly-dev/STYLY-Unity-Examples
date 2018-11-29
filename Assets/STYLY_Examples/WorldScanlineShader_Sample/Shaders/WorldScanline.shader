Shader "STYLY/Examples/WorldScanline" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "black" {}
		_LineColor ("Scan Line Color", Color) = (1,1,1,1)
		_TrajectoryColor ("Scan Trajectory Color", Color) = (1,1,1,1)
		_LineSpeed ("Scan Line Speed", Float) = 1.0
		_LineSize ("Scan Line Size", Float) = 0.5
		_TrajectorySize ("Scan Trajectory Size", Float) = 0.5
		_IntervalSec ("Scan Interval", Float) = 2.0
		
		[Space]
		[Space]
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
   			float3 worldPos;
		};

		// line parameters
		fixed4 _LineColor; // color of line
		half _LineSpeed; // speed of line movement
		half _LineSize; // thickness of line
		
		fixed4 _TrajectoryColor; // color of trajectory
		half _TrajectorySize; // size of trajectory

		half _IntervalSec; // interval(sec)

		// other
		half _Glossiness;
		half _Metallic;

		void surf (Input IN, inout SurfaceOutputStandard o) {

			#define LINE_POS (_Time.w * _LineSpeed)
			#define INTERVAL (_IntervalSec * _LineSpeed)
			#define STEP_EDGE (_LineSize)
			#define STEP_EDGE_1 (STEP_EDGE + _TrajectorySize)
			#define STEP_EDGE_2 (STEP_EDGE)

			float scanline = step(
					fmod(abs(IN.worldPos.x - LINE_POS), INTERVAL),
					STEP_EDGE
				);
			float trajectory = smoothstep(
					STEP_EDGE_1, STEP_EDGE_2,
					fmod(abs(IN.worldPos.x - LINE_POS), INTERVAL)
				);

			fixed4 baseColor = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = baseColor.rgb;
			o.Emission = _LineColor * scanline + _TrajectoryColor * trajectory;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
