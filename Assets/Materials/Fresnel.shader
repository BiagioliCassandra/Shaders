Shader "Unlit/Fresnel"
{
    Properties
    {

        _MainTex("Ma super texture", 2D) = "white" {}
        _ColDiffuse("Couleur Diffuse", Color) = (.25, .5, .5, 1)

        _ColAmbiante("Couleur Ambiante", Color) = (.25, .5, .5, 1)
        _CoefAmbiante("Coef Ambiante", Range(0.0, 1.0)) = 0.1

        _CoefBrillance("Coef Brillance", Range(0.0, 1.0)) = 0.1
        _ColSpeculaire("Couleur Speculaire", Color) = (.25, .5, .5, 1)
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
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
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
                float4 posWorldSpace : TEXCOORD3;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.posWorldSpace = mul(unity_ObjectToWorld, v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float4 _ColDiffuse;

            float4 _ColAmbiante;
            float _CoefAmbiante;

            float4 _ColSpeculaire;
            float _CoefBrillance;

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 d = dot(_WorldSpaceLightPos0, i.normal);
                d = d * _ColDiffuse * _LightColor0;     // Composante diffuse
                d = d + _CoefAmbiante * _ColAmbiante;   // Composante ambiante

                fixed4 directionVue = fixed4(_WorldSpaceCameraPos, 1.0) - i.posWorldSpace;

                fixed4 directionVueNormalisee = normalize(directionVue);

                fixed4 reflexionLight = reflect(-_WorldSpaceLightPos0, fixed4(i.normal, 1.0));

                fixed alignementVueReflexion = clamp(dot(directionVueNormalisee, reflexionLight), 0, 1);

                fixed4 speculaire = pow(alignementVueReflexion, _CoefBrillance * 1000) * _ColSpeculaire;

                fixed4 couleurTexture = tex2D(_MainTex, i.uv);

                return step(_CoefBrillance, 1 - dot(directionVueNormalisee, fixed4(i.normal, 1.0))) * _ColDiffuse + couleurTexture;
            }
            ENDCG
        }
    }
}
