Shader "Unlit/ToonWater"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [Toggle] _ScrollBool ("Enable Scrolling", Float) = 0
        _TexScrollSpeed("Scroll Speed", Vector) = (.5, 1, 0, 0)

        [Space(25)] 
        _DistortTex ("Distortion Map", 2D) = "white" {}
        [Toggle] _DistortBool ("Enable Distortion", Float) = 0
        _DistortScrollSpeed("Scroll Speed", Vector) = (1, -1.5, 0, 0)
        _DistortMagnitude("Distortion Magnitude", Range(0, 1)) = 0.035

        [Space(25)] 
        _NoiseTex("Noise Map", 2D) = "white" {}
        [Toggle] _NoiseBool ("Enable Distortion", Float) = 0
        _NoiseScrollSpeed("Scroll Speed", Vector) = (1, 1.5, 0, 0)
        _NoiseCutoffStart("Noise Cutoff Start", Range(0, 1)) = 0.2
		_NoiseCutoffStop("Noise Cutoff Stop", Range(0, 1)) = 0.975
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
                float2 distortUV : TEXCOORD1;
                float2 noiseUV : TEXCOORD2;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            bool _ScrollBool;
            float2 _TexScrollSpeed;

            sampler2D _DistortTex;
            float4 _DistortTex_ST;
            bool _DistortBool;
            float2 _DistortScrollSpeed;
            float _DistortMagnitude;

            sampler2D _NoiseTex;
            float4 _NoiseTex_ST;
            bool _NoiseBool;
            float2 _NoiseScrollSpeed;
            float _NoiseCutoffStart;
			float _NoiseCutoffStop;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.distortUV = TRANSFORM_TEX(v.uv, _DistortTex);
                o.noiseUV = TRANSFORM_TEX(v.uv, _NoiseTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                // sample distortion value (modified from https://roystan.net/articles/toon-water.html)
                float2 distortSample = 0;
                if (_DistortBool) {
                    float2 distortScroll = float2( frac(_Time.x * _DistortScrollSpeed.x), frac(_Time.x * _DistortScrollSpeed.y));
                    distortSample = (tex2D(_DistortTex, i.distortUV + distortScroll).xy * 2 - 1) * _DistortMagnitude;
                }

                // calculate scroll value
                float2 texScroll = 0;
                if (_ScrollBool)
                    texScroll = float2( frac(_Time.x * _TexScrollSpeed.x), frac(_Time.x * _TexScrollSpeed.y));

                float4 mainTex = tex2D(_MainTex, (i.uv - texScroll) + distortSample);

                // apply noise as combination of two scrolling noise textures
                float combinedSurfaceNoise = 0;
                if (_NoiseBool) {
                    float2 noiseScroll1  = float2( frac(_Time.x * _NoiseScrollSpeed.x), frac(_Time.x * _NoiseScrollSpeed.y));
                    float4 surfaceNoise1 = tex2D(_NoiseTex, i.noiseUV + noiseScroll1);

                    float2 noiseScroll2  = float2( frac(_Time.x * _NoiseScrollSpeed.x), frac(_Time.x * -_NoiseScrollSpeed.y));
                    float4 surfaceNoise2 = tex2D(_NoiseTex, i.noiseUV + noiseScroll2);

                    combinedSurfaceNoise = surfaceNoise1 + surfaceNoise2; 
                    if (combinedSurfaceNoise > _NoiseCutoffStart && combinedSurfaceNoise < _NoiseCutoffStop) 
                        combinedSurfaceNoise = 0;
                }


                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return mainTex + (combinedSurfaceNoise);
            }
            ENDCG
        }
    }
}
