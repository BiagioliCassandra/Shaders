Shader "Unlit/Ambiante"
{
    Properties
    {
        _CoeffAmbiant("Coeff ambiant", Range(0.0, 1.0)) = 0.1
        _ColorAmbiant("Color ambiant", Color) = (0.25, 0.5, 0.5, 1)
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
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            float4 _ColorAmbiant;
            float _CoeffAmbiant;

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = _CoeffAmbiant * _ColorAmbiant;
                return col;
            }
            ENDCG
        }
    }
}
