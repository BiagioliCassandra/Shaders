Shader "Unlit/Diffuse"
{
    Properties
    {
        _CoeffAmbiant("Coeff ambiant", Range(0.0, 1.0)) = 0.1
        _ColorAmbiant("Color ambiant", Color) = (0.25, 0.5, 0.5, 1)
        _ColorDiffuse("Color diffuse", Color) = (0.25, 0.5, 0.5, 1)
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
            #include "UnityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            float4 _ColorAmbiant;
            float4 _ColorDiffuse;
            float _CoeffAmbiant;

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                //fixed4 col = _CoeffAmbiant * _ColorAmbiant;
                //fixed4 col = fixed4(i.normal.x, i.normal.y, i.normal.z, 1.0);
                //fixed4 col = _WorldSpaceLightPos0;
                //fixed4 col = _LightColor0;
                //Le dot c'est à quel point je suis alignée avec mes 2 vecteurs dot(direction de la light, la normale)
                fixed4 diff = dot(_WorldSpaceLightPos0, i.normal);
                diff = diff * _ColorDiffuse * _LightColor0;
                diff = diff + _CoeffAmbiant * _ColorAmbiant;
                return diff;
            }
            ENDCG
        }
    }
}
