// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:3,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:True,hqlp:False,rprd:True,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:2865,x:32774,y:33104,varname:node_2865,prsc:2|diff-7631-OUT,spec-358-OUT,gloss-1813-OUT,normal-8894-RGB,alpha-5636-OUT,voffset-9670-OUT;n:type:ShaderForge.SFN_Slider,id:358,x:32669,y:32599,ptovrint:False,ptlb:Metallic,ptin:_Metallic,varname:node_358,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:1;n:type:ShaderForge.SFN_Slider,id:1813,x:32669,y:32511,ptovrint:False,ptlb:Gloss,ptin:_Gloss,varname:_Metallic_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.8,max:1;n:type:ShaderForge.SFN_Tex2d,id:4863,x:31173,y:33544,ptovrint:False,ptlb:WaveHeighmapt,ptin:_WaveHeighmapt,varname:node_4863,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:dae2e2f60f56f414b90e5a98d3f1528b,ntxv:0,isnm:False|UVIN-71-UVOUT;n:type:ShaderForge.SFN_Panner,id:71,x:30893,y:33544,varname:node_71,prsc:2,spu:0,spv:0.05|UVIN-4003-UVOUT,DIST-280-OUT;n:type:ShaderForge.SFN_TexCoord,id:4003,x:30618,y:33544,varname:node_4003,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_RemapRange,id:280,x:30618,y:33356,varname:node_280,prsc:2,frmn:-1,frmx:1,tomn:0,tomx:1|IN-420-OUT;n:type:ShaderForge.SFN_Sin,id:420,x:30618,y:33212,varname:node_420,prsc:2|IN-3189-T;n:type:ShaderForge.SFN_Time,id:3189,x:30618,y:33062,varname:node_3189,prsc:2;n:type:ShaderForge.SFN_Multiply,id:3971,x:31414,y:33408,varname:node_3971,prsc:2|A-6076-OUT,B-1635-OUT;n:type:ShaderForge.SFN_NormalVector,id:1635,x:31173,y:33370,prsc:2,pt:False;n:type:ShaderForge.SFN_Color,id:9217,x:31977,y:32449,ptovrint:False,ptlb:Color1,ptin:_Color1,varname:node_9217,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.06314879,c2:0.30159,c3:0.5367647,c4:1;n:type:ShaderForge.SFN_Multiply,id:1094,x:31684,y:33398,varname:node_1094,prsc:2|A-3569-OUT,B-3971-OUT;n:type:ShaderForge.SFN_Slider,id:3569,x:31463,y:33284,ptovrint:False,ptlb:WaveHeight,ptin:_WaveHeight,varname:node_3569,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:1;n:type:ShaderForge.SFN_Multiply,id:5210,x:31463,y:33131,varname:node_5210,prsc:2|A-8690-OUT,B-280-OUT;n:type:ShaderForge.SFN_ValueProperty,id:8690,x:31440,y:33051,ptovrint:False,ptlb:Wavewidth,ptin:_Wavewidth,varname:node_8690,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:2;n:type:ShaderForge.SFN_ValueProperty,id:4529,x:31709,y:33038,ptovrint:False,ptlb:Wavedirection,ptin:_Wavedirection,varname:node_4529,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Append,id:5008,x:31709,y:33131,varname:node_5008,prsc:2|A-4529-OUT,B-4529-OUT,C-5210-OUT;n:type:ShaderForge.SFN_Add,id:9670,x:31924,y:33264,varname:node_9670,prsc:2|A-5008-OUT,B-1094-OUT;n:type:ShaderForge.SFN_Tex2d,id:4477,x:31364,y:33918,ptovrint:False,ptlb:Waveheightmap2,ptin:_Waveheightmap2,varname:node_4477,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:ce46ac9d8d1db7343bb873a7b4dc9427,ntxv:0,isnm:False|UVIN-4734-UVOUT;n:type:ShaderForge.SFN_Panner,id:4734,x:31167,y:33918,varname:node_4734,prsc:2,spu:0,spv:0.15|UVIN-8616-OUT;n:type:ShaderForge.SFN_Add,id:8616,x:30959,y:33928,varname:node_8616,prsc:2|A-5033-UVOUT,B-1491-OUT;n:type:ShaderForge.SFN_TexCoord,id:5033,x:30739,y:33928,varname:node_5033,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Vector2,id:1491,x:30959,y:34095,varname:node_1491,prsc:2,v1:0,v2:0.2;n:type:ShaderForge.SFN_Add,id:6076,x:31457,y:33681,varname:node_6076,prsc:2|A-4863-G,B-4477-G;n:type:ShaderForge.SFN_Tex2d,id:8894,x:32508,y:33883,ptovrint:False,ptlb:Wavenormal,ptin:_Wavenormal,varname:node_8894,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:d4d83900694d9b94ba199333b9644122,ntxv:3,isnm:True|UVIN-8017-UVOUT;n:type:ShaderForge.SFN_Panner,id:8017,x:32294,y:33883,varname:node_8017,prsc:2,spu:0,spv:0.1|UVIN-4431-UVOUT,DIST-3761-T;n:type:ShaderForge.SFN_TexCoord,id:4431,x:32027,y:33875,varname:node_4431,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Time,id:3761,x:32013,y:34054,varname:node_3761,prsc:2;n:type:ShaderForge.SFN_Color,id:9064,x:31977,y:32621,ptovrint:False,ptlb:Colo2,ptin:_Colo2,varname:_node_9217_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.6176471,c2:0.7626775,c3:1,c4:1;n:type:ShaderForge.SFN_Fresnel,id:491,x:32009,y:32828,varname:node_491,prsc:2|NRM-2470-OUT,EXP-4099-OUT;n:type:ShaderForge.SFN_NormalVector,id:2470,x:31760,y:32706,prsc:2,pt:False;n:type:ShaderForge.SFN_ValueProperty,id:4099,x:31754,y:32906,ptovrint:False,ptlb:node_4099,ptin:_node_4099,varname:node_4099,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1.5;n:type:ShaderForge.SFN_Lerp,id:9609,x:32324,y:32766,varname:node_9609,prsc:2|A-9217-RGB,B-9064-RGB,T-491-OUT;n:type:ShaderForge.SFN_Blend,id:7631,x:32380,y:33053,varname:node_7631,prsc:2,blmd:6,clmp:True|SRC-4477-RGB,DST-9609-OUT;n:type:ShaderForge.SFN_Tex2d,id:6589,x:32391,y:33437,ptovrint:False,ptlb:AlphaTexture,ptin:_AlphaTexture,varname:node_6589,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:bb42c969527a4b54a927bc96cf1d1b61,ntxv:0,isnm:False;n:type:ShaderForge.SFN_ValueProperty,id:1943,x:32391,y:33332,ptovrint:False,ptlb:Opacity,ptin:_Opacity,varname:node_1943,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.5;n:type:ShaderForge.SFN_Multiply,id:5636,x:32575,y:33364,varname:node_5636,prsc:2|A-1943-OUT,B-6589-A;proporder:358-1813-4863-9217-3569-8690-4529-4477-8894-9064-4099-6589-1943;pass:END;sub:END;*/

Shader "Shader Forge/wave" {
    Properties {
        _Metallic ("Metallic", Range(0, 1)) = 1
        _Gloss ("Gloss", Range(0, 1)) = 0.8
        _WaveHeighmapt ("WaveHeighmapt", 2D) = "white" {}
        _Color1 ("Color1", Color) = (0.06314879,0.30159,0.5367647,1)
        _WaveHeight ("WaveHeight", Range(0, 1)) = 0.5
        _Wavewidth ("Wavewidth", Float ) = 2
        _Wavedirection ("Wavedirection", Float ) = 0
        _Waveheightmap2 ("Waveheightmap2", 2D) = "white" {}
        _Wavenormal ("Wavenormal", 2D) = "bump" {}
        _Colo2 ("Colo2", Color) = (0.6176471,0.7626775,1,1)
        _node_4099 ("node_4099", Float ) = 1.5
        _AlphaTexture ("AlphaTexture", 2D) = "white" {}
        _Opacity ("Opacity", Float ) = 0.5
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 
            #pragma target 3.0
            uniform float _Metallic;
            uniform float _Gloss;
            uniform sampler2D _WaveHeighmapt; uniform float4 _WaveHeighmapt_ST;
            uniform float4 _Color1;
            uniform float _WaveHeight;
            uniform float _Wavewidth;
            uniform float _Wavedirection;
            uniform sampler2D _Waveheightmap2; uniform float4 _Waveheightmap2_ST;
            uniform sampler2D _Wavenormal; uniform float4 _Wavenormal_ST;
            uniform float4 _Colo2;
            uniform float _node_4099;
            uniform sampler2D _AlphaTexture; uniform float4 _AlphaTexture_ST;
            uniform float _Opacity;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 posWorld : TEXCOORD3;
                float3 normalDir : TEXCOORD4;
                float3 tangentDir : TEXCOORD5;
                float3 bitangentDir : TEXCOORD6;
                UNITY_FOG_COORDS(7)
                #if defined(LIGHTMAP_ON) || defined(UNITY_SHOULD_SAMPLE_SH)
                    float4 ambientOrLightmapUV : TEXCOORD8;
                #endif
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                #ifdef LIGHTMAP_ON
                    o.ambientOrLightmapUV.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                    o.ambientOrLightmapUV.zw = 0;
                #elif UNITY_SHOULD_SAMPLE_SH
                #endif
                #ifdef DYNAMICLIGHTMAP_ON
                    o.ambientOrLightmapUV.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
                #endif
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                float4 node_3189 = _Time;
                float node_280 = (sin(node_3189.g)*0.5+0.5);
                float2 node_71 = (o.uv0+node_280*float2(0,0.05));
                float4 _WaveHeighmapt_var = tex2Dlod(_WaveHeighmapt,float4(TRANSFORM_TEX(node_71, _WaveHeighmapt),0.0,0));
                float4 node_6709 = _Time;
                float2 node_4734 = ((o.uv0+float2(0,0.2))+node_6709.g*float2(0,0.15));
                float4 _Waveheightmap2_var = tex2Dlod(_Waveheightmap2,float4(TRANSFORM_TEX(node_4734, _Waveheightmap2),0.0,0));
                v.vertex.xyz += (float3(_Wavedirection,_Wavedirection,(_Wavewidth*node_280))+(_WaveHeight*((_WaveHeighmapt_var.g+_Waveheightmap2_var.g)*v.normal)));
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float4 node_3761 = _Time;
                float2 node_8017 = (i.uv0+node_3761.g*float2(0,0.1));
                float3 _Wavenormal_var = UnpackNormal(tex2D(_Wavenormal,TRANSFORM_TEX(node_8017, _Wavenormal)));
                float3 normalLocal = _Wavenormal_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = 1;
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float gloss = _Gloss;
                float perceptualRoughness = 1.0 - _Gloss;
                float roughness = perceptualRoughness * perceptualRoughness;
                float specPow = exp2( gloss * 10.0 + 1.0 );
/////// GI Data:
                UnityLight light;
                #ifdef LIGHTMAP_OFF
                    light.color = lightColor;
                    light.dir = lightDirection;
                    light.ndotl = LambertTerm (normalDirection, light.dir);
                #else
                    light.color = half3(0.f, 0.f, 0.f);
                    light.ndotl = 0.0f;
                    light.dir = half3(0.f, 0.f, 0.f);
                #endif
                UnityGIInput d;
                d.light = light;
                d.worldPos = i.posWorld.xyz;
                d.worldViewDir = viewDirection;
                d.atten = attenuation;
                #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
                    d.ambient = 0;
                    d.lightmapUV = i.ambientOrLightmapUV;
                #else
                    d.ambient = i.ambientOrLightmapUV;
                #endif
                #if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION
                    d.boxMin[0] = unity_SpecCube0_BoxMin;
                    d.boxMin[1] = unity_SpecCube1_BoxMin;
                #endif
                #if UNITY_SPECCUBE_BOX_PROJECTION
                    d.boxMax[0] = unity_SpecCube0_BoxMax;
                    d.boxMax[1] = unity_SpecCube1_BoxMax;
                    d.probePosition[0] = unity_SpecCube0_ProbePosition;
                    d.probePosition[1] = unity_SpecCube1_ProbePosition;
                #endif
                d.probeHDR[0] = unity_SpecCube0_HDR;
                d.probeHDR[1] = unity_SpecCube1_HDR;
                Unity_GlossyEnvironmentData ugls_en_data;
                ugls_en_data.roughness = 1.0 - gloss;
                ugls_en_data.reflUVW = viewReflectDirection;
                UnityGI gi = UnityGlobalIllumination(d, 1, normalDirection, ugls_en_data );
                lightDirection = gi.light.dir;
                lightColor = gi.light.color;
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float LdotH = saturate(dot(lightDirection, halfDirection));
                float3 specularColor = _Metallic;
                float specularMonochrome;
                float4 node_6709 = _Time;
                float2 node_4734 = ((i.uv0+float2(0,0.2))+node_6709.g*float2(0,0.15));
                float4 _Waveheightmap2_var = tex2D(_Waveheightmap2,TRANSFORM_TEX(node_4734, _Waveheightmap2));
                float3 diffuseColor = saturate((1.0-(1.0-_Waveheightmap2_var.rgb)*(1.0-lerp(_Color1.rgb,_Colo2.rgb,pow(1.0-max(0,dot(i.normalDir, viewDirection)),_node_4099))))); // Need this for specular when using metallic
                diffuseColor = DiffuseAndSpecularFromMetallic( diffuseColor, specularColor, specularColor, specularMonochrome );
                specularMonochrome = 1.0-specularMonochrome;
                float NdotV = abs(dot( normalDirection, viewDirection ));
                float NdotH = saturate(dot( normalDirection, halfDirection ));
                float VdotH = saturate(dot( viewDirection, halfDirection ));
                float visTerm = SmithJointGGXVisibilityTerm( NdotL, NdotV, roughness );
                float normTerm = GGXTerm(NdotH, roughness);
                float specularPBL = (visTerm*normTerm) * UNITY_PI;
                #ifdef UNITY_COLORSPACE_GAMMA
                    specularPBL = sqrt(max(1e-4h, specularPBL));
                #endif
                specularPBL = max(0, specularPBL * NdotL);
                #if defined(_SPECULARHIGHLIGHTS_OFF)
                    specularPBL = 0.0;
                #endif
                half surfaceReduction;
                #ifdef UNITY_COLORSPACE_GAMMA
                    surfaceReduction = 1.0-0.28*roughness*perceptualRoughness;
                #else
                    surfaceReduction = 1.0/(roughness*roughness + 1.0);
                #endif
                specularPBL *= any(specularColor) ? 1.0 : 0.0;
                float3 directSpecular = attenColor*specularPBL*FresnelTerm(specularColor, LdotH);
                half grazingTerm = saturate( gloss + specularMonochrome );
                float3 indirectSpecular = (gi.indirect.specular);
                indirectSpecular *= FresnelLerp (specularColor, grazingTerm, NdotV);
                indirectSpecular *= surfaceReduction;
                float3 specular = (directSpecular + indirectSpecular);
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                half fd90 = 0.5 + 2 * LdotH * LdotH * (1-gloss);
                float nlPow5 = Pow5(1-NdotL);
                float nvPow5 = Pow5(1-NdotV);
                float3 directDiffuse = ((1 +(fd90 - 1)*nlPow5) * (1 + (fd90 - 1)*nvPow5) * NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += gi.indirect.diffuse;
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse + specular;
                float4 _AlphaTexture_var = tex2D(_AlphaTexture,TRANSFORM_TEX(i.uv0, _AlphaTexture));
                fixed4 finalRGBA = fixed4(finalColor,(_Opacity*_AlphaTexture_var.a));
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdadd
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 
            #pragma target 3.0
            uniform float _Metallic;
            uniform float _Gloss;
            uniform sampler2D _WaveHeighmapt; uniform float4 _WaveHeighmapt_ST;
            uniform float4 _Color1;
            uniform float _WaveHeight;
            uniform float _Wavewidth;
            uniform float _Wavedirection;
            uniform sampler2D _Waveheightmap2; uniform float4 _Waveheightmap2_ST;
            uniform sampler2D _Wavenormal; uniform float4 _Wavenormal_ST;
            uniform float4 _Colo2;
            uniform float _node_4099;
            uniform sampler2D _AlphaTexture; uniform float4 _AlphaTexture_ST;
            uniform float _Opacity;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 posWorld : TEXCOORD3;
                float3 normalDir : TEXCOORD4;
                float3 tangentDir : TEXCOORD5;
                float3 bitangentDir : TEXCOORD6;
                LIGHTING_COORDS(7,8)
                UNITY_FOG_COORDS(9)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                float4 node_3189 = _Time;
                float node_280 = (sin(node_3189.g)*0.5+0.5);
                float2 node_71 = (o.uv0+node_280*float2(0,0.05));
                float4 _WaveHeighmapt_var = tex2Dlod(_WaveHeighmapt,float4(TRANSFORM_TEX(node_71, _WaveHeighmapt),0.0,0));
                float4 node_4780 = _Time;
                float2 node_4734 = ((o.uv0+float2(0,0.2))+node_4780.g*float2(0,0.15));
                float4 _Waveheightmap2_var = tex2Dlod(_Waveheightmap2,float4(TRANSFORM_TEX(node_4734, _Waveheightmap2),0.0,0));
                v.vertex.xyz += (float3(_Wavedirection,_Wavedirection,(_Wavewidth*node_280))+(_WaveHeight*((_WaveHeighmapt_var.g+_Waveheightmap2_var.g)*v.normal)));
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float4 node_3761 = _Time;
                float2 node_8017 = (i.uv0+node_3761.g*float2(0,0.1));
                float3 _Wavenormal_var = UnpackNormal(tex2D(_Wavenormal,TRANSFORM_TEX(node_8017, _Wavenormal)));
                float3 normalLocal = _Wavenormal_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float gloss = _Gloss;
                float perceptualRoughness = 1.0 - _Gloss;
                float roughness = perceptualRoughness * perceptualRoughness;
                float specPow = exp2( gloss * 10.0 + 1.0 );
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float LdotH = saturate(dot(lightDirection, halfDirection));
                float3 specularColor = _Metallic;
                float specularMonochrome;
                float4 node_4780 = _Time;
                float2 node_4734 = ((i.uv0+float2(0,0.2))+node_4780.g*float2(0,0.15));
                float4 _Waveheightmap2_var = tex2D(_Waveheightmap2,TRANSFORM_TEX(node_4734, _Waveheightmap2));
                float3 diffuseColor = saturate((1.0-(1.0-_Waveheightmap2_var.rgb)*(1.0-lerp(_Color1.rgb,_Colo2.rgb,pow(1.0-max(0,dot(i.normalDir, viewDirection)),_node_4099))))); // Need this for specular when using metallic
                diffuseColor = DiffuseAndSpecularFromMetallic( diffuseColor, specularColor, specularColor, specularMonochrome );
                specularMonochrome = 1.0-specularMonochrome;
                float NdotV = abs(dot( normalDirection, viewDirection ));
                float NdotH = saturate(dot( normalDirection, halfDirection ));
                float VdotH = saturate(dot( viewDirection, halfDirection ));
                float visTerm = SmithJointGGXVisibilityTerm( NdotL, NdotV, roughness );
                float normTerm = GGXTerm(NdotH, roughness);
                float specularPBL = (visTerm*normTerm) * UNITY_PI;
                #ifdef UNITY_COLORSPACE_GAMMA
                    specularPBL = sqrt(max(1e-4h, specularPBL));
                #endif
                specularPBL = max(0, specularPBL * NdotL);
                #if defined(_SPECULARHIGHLIGHTS_OFF)
                    specularPBL = 0.0;
                #endif
                specularPBL *= any(specularColor) ? 1.0 : 0.0;
                float3 directSpecular = attenColor*specularPBL*FresnelTerm(specularColor, LdotH);
                float3 specular = directSpecular;
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                half fd90 = 0.5 + 2 * LdotH * LdotH * (1-gloss);
                float nlPow5 = Pow5(1-NdotL);
                float nvPow5 = Pow5(1-NdotV);
                float3 directDiffuse = ((1 +(fd90 - 1)*nlPow5) * (1 + (fd90 - 1)*nvPow5) * NdotL) * attenColor;
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse + specular;
                float4 _AlphaTexture_var = tex2D(_AlphaTexture,TRANSFORM_TEX(i.uv0, _AlphaTexture));
                fixed4 finalRGBA = fixed4(finalColor * (_Opacity*_AlphaTexture_var.a),0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Back
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 
            #pragma target 3.0
            uniform sampler2D _WaveHeighmapt; uniform float4 _WaveHeighmapt_ST;
            uniform float _WaveHeight;
            uniform float _Wavewidth;
            uniform float _Wavedirection;
            uniform sampler2D _Waveheightmap2; uniform float4 _Waveheightmap2_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float2 uv1 : TEXCOORD2;
                float2 uv2 : TEXCOORD3;
                float4 posWorld : TEXCOORD4;
                float3 normalDir : TEXCOORD5;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_3189 = _Time;
                float node_280 = (sin(node_3189.g)*0.5+0.5);
                float2 node_71 = (o.uv0+node_280*float2(0,0.05));
                float4 _WaveHeighmapt_var = tex2Dlod(_WaveHeighmapt,float4(TRANSFORM_TEX(node_71, _WaveHeighmapt),0.0,0));
                float4 node_6110 = _Time;
                float2 node_4734 = ((o.uv0+float2(0,0.2))+node_6110.g*float2(0,0.15));
                float4 _Waveheightmap2_var = tex2Dlod(_Waveheightmap2,float4(TRANSFORM_TEX(node_4734, _Waveheightmap2),0.0,0));
                v.vertex.xyz += (float3(_Wavedirection,_Wavedirection,(_Wavewidth*node_280))+(_WaveHeight*((_WaveHeighmapt_var.g+_Waveheightmap2_var.g)*v.normal)));
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
        Pass {
            Name "Meta"
            Tags {
                "LightMode"="Meta"
            }
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_META 1
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #include "UnityMetaPass.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 
            #pragma target 3.0
            uniform float _Metallic;
            uniform float _Gloss;
            uniform sampler2D _WaveHeighmapt; uniform float4 _WaveHeighmapt_ST;
            uniform float4 _Color1;
            uniform float _WaveHeight;
            uniform float _Wavewidth;
            uniform float _Wavedirection;
            uniform sampler2D _Waveheightmap2; uniform float4 _Waveheightmap2_ST;
            uniform float4 _Colo2;
            uniform float _node_4099;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 posWorld : TEXCOORD3;
                float3 normalDir : TEXCOORD4;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_3189 = _Time;
                float node_280 = (sin(node_3189.g)*0.5+0.5);
                float2 node_71 = (o.uv0+node_280*float2(0,0.05));
                float4 _WaveHeighmapt_var = tex2Dlod(_WaveHeighmapt,float4(TRANSFORM_TEX(node_71, _WaveHeighmapt),0.0,0));
                float4 node_4277 = _Time;
                float2 node_4734 = ((o.uv0+float2(0,0.2))+node_4277.g*float2(0,0.15));
                float4 _Waveheightmap2_var = tex2Dlod(_Waveheightmap2,float4(TRANSFORM_TEX(node_4734, _Waveheightmap2),0.0,0));
                v.vertex.xyz += (float3(_Wavedirection,_Wavedirection,(_Wavewidth*node_280))+(_WaveHeight*((_WaveHeighmapt_var.g+_Waveheightmap2_var.g)*v.normal)));
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST );
                return o;
            }
            float4 frag(VertexOutput i) : SV_Target {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                UnityMetaInput o;
                UNITY_INITIALIZE_OUTPUT( UnityMetaInput, o );
                
                o.Emission = 0;
                
                float4 node_4277 = _Time;
                float2 node_4734 = ((i.uv0+float2(0,0.2))+node_4277.g*float2(0,0.15));
                float4 _Waveheightmap2_var = tex2D(_Waveheightmap2,TRANSFORM_TEX(node_4734, _Waveheightmap2));
                float3 diffColor = saturate((1.0-(1.0-_Waveheightmap2_var.rgb)*(1.0-lerp(_Color1.rgb,_Colo2.rgb,pow(1.0-max(0,dot(i.normalDir, viewDirection)),_node_4099)))));
                float specularMonochrome;
                float3 specColor;
                diffColor = DiffuseAndSpecularFromMetallic( diffColor, _Metallic, specColor, specularMonochrome );
                float roughness = 1.0 - _Gloss;
                o.Albedo = diffColor + specColor * roughness * roughness * 0.5;
                
                return UnityMetaFragment( o );
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
