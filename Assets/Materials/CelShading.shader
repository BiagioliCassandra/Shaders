Shader "Unlit/CelShading"
{
    Properties
    {
        _MainTex("Ma super texture", 2D) = "white" {}
        _CoeffAmbiant("Coeff ambiant", Range(0.0, 1.0)) = 0.1
        _CoeffBrillance("Coeff brillance", Range(0.0, 1.0)) = 0.1
        _ColorAmbiant("Color ambiant", Color) = (0.25, 0.5, 0.5, 1)
        _ColorDiffuse("Color diffuse", Color) = (0.25, 0.5, 0.5, 1)
        _ColorSpeculaire("Color speculaire", Color) = (0.25, 0.5, 0.5, 1)
        [IntRange]
        _NbStrates("Number of Strates", Range(1.0, 10.0)) = 4
        [Toggle] 
        _IsCellShading("CelShading ?", Float) = 0
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

            float4 _ColorAmbiant;
            float4 _ColorDiffuse;
            float4 _ColorSpeculaire;
            float _CoeffAmbiant;
            float _CoeffBrillance;
            int _NbStrates;
            int _IsCelShading;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float4 posWorldSpace : TEXTCOORD3;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.posWorldSpace = mul(unity_ObjectToWorld, v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                //Diffuse et ambiante
                fixed4 diff = dot(_WorldSpaceLightPos0, i.normal);

                if (_IsCelShading)
                {
                    diff = round(diff * _NbStrates) / _NbStrates;
                }

                diff = diff * _ColorDiffuse * _LightColor0;
                diff = diff + _CoeffAmbiant * _ColorAmbiant;

                //Speculaire
                fixed4 directionView = fixed4(_WorldSpaceCameraPos, 1.0) - i.posWorldSpace;
                fixed4 directionViewNormalize = normalize(directionView);

                fixed4 reflexionLight = reflect(-_WorldSpaceLightPos0, fixed4(i.normal, 1.0));
                fixed alignementViewReflexion = clamp(dot(directionViewNormalize, reflexionLight), 0, 1);

                //La fonction pow fait une puissance (chiffre à mettre à la puissance, coeff de brillance)
                fixed4 speculaire = pow(alignementViewReflexion, _CoeffBrillance * 1000) * _ColorSpeculaire;

                //Textures
                fixed4 colorTexture = tex2D(_MainTex, i.uv);

                return (speculaire + diff) * colorTexture;
            }
            ENDCG
        }
    }
}
