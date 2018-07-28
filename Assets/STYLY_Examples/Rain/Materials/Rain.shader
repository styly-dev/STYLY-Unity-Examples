// 参考URL
Shader "Custom/Rain" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Speed ("［VS］雨が落ちる速さ", Float) = 6.0 
        _Scale ("［VS］雨の高さ", Float) = 4.0
		_Remap("［VS］Remap", Range(0.0, 1.0)) = 0.7
        [Space]
        _Albedo ("［FS］雨 色", Color) = (1.0, 1.0, 1.0, 0.5) 
        _Emission ("［FS］雨 発光色", Color) = (0.0, 0.0, 0.0, 0.0) 
        _Specular ("［FS］雨 スペキュラーパワー", Range(0.0, 1.0)) = 0.5 
        _Gloss ("［FS］雨 スペキュラー強度", Range(0.0, 1.0)) = 0.5 
	}

    SubShader {
        Tags {
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
        }
        CGPROGRAM
        #pragma surface surf Lambert alpha
        #pragma vertex vert

        sampler2D _MainTex;

        // [0;1]のランダムな値を返す関数
        float nhash11(float n){
            return frac(sin(n) * 43758.5453);
        }

        // 値域[a;b] を 値域[0;1]へ変換する関数
        float remap(float t, float a, float b){
            return clamp((t-a)/(b-a), 0, 1);
        }
        // 頂点シェーダー
        half _Speed;
		half _Scale;
		half _Range;
		fixed _Remap;

        // 色
        half4 _Albedo;
        half4 _Emission;
        fixed _Specular;
        fixed _Gloss;


        // 頂点シェーダー関数
        void vert(inout appdata_full v) {
            fixed rnd = nhash11(fmod(v.vertex.z, 512.0)); // ランダム値
			//float timer = _Time.w * _Speed * remap(0.7, 1.0, rnd);
			float timer = _Time.w * _Speed * remap(_Remap, 1.0, rnd); // 値域の変換 [_Remap, 1.0] -> [0;1]
            v.vertex.y -= fmod(-v.vertex.y + timer, _Scale) + v.vertex.y - _Scale * 0.5;
            // v.vertex.y -= fmod(-v.vertex.y + timer, 4.0 / _Range) + v.vertex.y - _Scale * 0.5;
        }

        struct Input {
            float2 uv_MainTex;
        };

        // サーフェースシェーダー関数
        void surf(Input IN, inout SurfaceOutput o) {
            half4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb * _Albedo.rgb;
            o.Emission = _Emission; 
            o.Specular = _Specular; 
            o.Gloss = _Gloss; 
            o.Alpha = _Albedo.a; 
        }
        ENDCG
    }
}