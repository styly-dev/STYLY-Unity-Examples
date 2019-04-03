//////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2017
//	Side Effects Software Inc.  All rights reserved.
//
// Redistribution and use of in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//
// 2. The name of Side Effects Software may not be used to endorse or
//    promote products derived from this software without specific prior
//    written permission.
//
// THIS SOFTWARE IS PROVIDED BY SIDE EFFECTS SOFTWARE `AS IS' AND ANY EXPRESS
// OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
// NO EVENT SHALL SIDE EFFECTS SOFTWARE BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
// OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
// EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//////////////////////////////////////////////////////////////////////////////////////

// Upgrade NOTE: upgraded instancing buffer 'Props' to new syntax.

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "sidefx/vertex_fluid_shader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_boundingMax("Bounding Max", Float) = 1.0
		_boundingMin("Bounding Min", Float) = 1.0
		_numOfFrames("Number Of Frames", int) = 240
		_speed("Speed", Float) = 0.33
		[MaterialToggle] _pack_normal ("Pack Normal", Float) = 0
		_posTex ("Position Map (RGB)", 2D) = "white" {}
		_nTex ("Normal Map (RGB)", 2D) = "grey" {}
		_colorTex ("Colour Map (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard addshadow vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _posTex;
		sampler2D _nTex;
		sampler2D _colorTex;
		uniform fixed _pack_normal;
		uniform fixed _boundingMax;
		uniform fixed _boundingMin;
		uniform fixed _speed;
		uniform int _numOfFrames;

		struct Input {
			float2 uv_MainTex;
			float4 vcolor : COLOR ;
		};

		fixed _Glossiness;
		fixed _Metallic;
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		//vertex function
		void vert(inout appdata_full v){
			//calculate uv coordinates
			fixed timeInFrames = ((ceil(frac(-_Time.y * _speed) * _numOfFrames))/_numOfFrames) + (1.0/_numOfFrames);
			
			//get position, normal and colour from textures
			fixed4 texturePos = tex2Dlod(_posTex,fixed4(v.texcoord.x, (timeInFrames + v.texcoord.y), 0, 0));
			fixed3 textureN = tex2Dlod(_nTex,fixed4(v.texcoord.x, (timeInFrames + v.texcoord.y), 0, 0));
			fixed3 textureCd = tex2Dlod(_colorTex,fixed4(v.texcoord.x, (timeInFrames + v.texcoord.y), 0, 0));

			//expand normalised position texture values to world space
			fixed expand = _boundingMax - _boundingMin;
			texturePos.xyz *= expand;
			texturePos.xyz += _boundingMin;
			texturePos.x *= -1;  //flipped to account for right-handedness of unity
			v.vertex.xyz = texturePos.xzy;  //swizzle y and z because textures are exported with z-up

			//calculate normal
			if (_pack_normal){
				//decode fixed to fixed2
				fixed alpha = texturePos.w * 1023;
				fixed2 f2;
				f2.x = floor(alpha / 32.0) / 31.0;
				f2.y = (alpha - (floor(alpha / 32.0)*32.0)) / 31.0;

				//decode fixed2 to fixed3
				fixed3 f3;
				f2 *= 4;
				f2 -= 2;
				fixed f2dot = dot(f2,f2);
				f3.xy = sqrt(1 - (f2dot/4.0)) * f2;
				f3.z = 1 - (f2dot/2.0);
				f3 = clamp(f3, -1.0, 1.0);
				f3 = f3.xzy;
				f3.x *= -1;
				v.normal = f3;
			} else {
				textureN = textureN.xzy;
				textureN *= 2;
				textureN -= 1;
				textureN.x *= -1;
				v.normal = textureN;
			}

			//set vertex colour
			v.color.rgb = textureCd;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb * IN.vcolor.rgb;  //multiply existing albedo map by vertex colour
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
