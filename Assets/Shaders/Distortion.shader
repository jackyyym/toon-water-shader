Shader "Unlit/Distortion"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TexScrollSpeed("Scroll Speed", Vector) = (0, 0, 0, 0)

        _DistortTex ("Distortion Map", 2D) = "white" {}
        _DistortScrollSpeed("Scroll Speed", Vector) = (1, -1.5, 0, 0)
        _DistortMagnitude("Distortion Magnitude", Range(0, 1)) = 0.035
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
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float2 _TexScrollSpeed;

            sampler2D _DistortTex;
            float4 _DistortTex_ST;
            float2 _DistortScrollSpeed;
            float _DistortMagnitude;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.distortUV = TRANSFORM_TEX(v.uv, _DistortTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample distortion value (modified from https://roystan.net/articles/toon-water.html)
                float2 distortScroll = float2( frac(_Time.x * _DistortScrollSpeed.x), frac(_Time.x * _DistortScrollSpeed.y));
                float2 distortSample = (tex2D(_DistortTex, i.distortUV + distortScroll).xy * 2 - 1) * _DistortMagnitude;

                // calculate scroll value and apply to texture
                float2 texScroll = float2( frac(_Time.x * _TexScrollSpeed.x), frac(_Time.x * _TexScrollSpeed.y));
                float4 mainTex = tex2D(_MainTex, (i.uv - texScroll) + distortSample);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return mainTex;
            }
            ENDCG
        }
    }
}
