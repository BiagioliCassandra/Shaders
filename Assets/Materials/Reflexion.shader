Shader "Unlit/Reflexion"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f {
                // half 16bits, float 32bits
                half3 worldRefl : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            v2f vert(float4 vertex : POSITION, float3 normal : NORMAL)
            {
                v2f o;
                // transforme un point de l'espace objet en espace camera
                o.pos = UnityObjectToClipPos(vertex);
                // calcule la position dans l'espace monde du vertex
                float3 worldPos = mul(unity_ObjectToWorld, vertex).xyz;
                // calcule la direction de la vue dans l'espace monde
                // UnityWorldSpaceViewDir est utilis� pour obtenir la couleur r�elle des donn�es de la sonde de reflexion
                float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
                // la normal de l'espace monde
                float3 worldNormal = UnityObjectToWorldNormal(normal);
                // le vector de reflexion de l'espace monde
                // reflect est une fonction HLSL int�gr�e pour calculer la reflexion vectorielle autour d'une normal donn�e
                o.worldRefl = reflect(-worldViewDir, worldNormal);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // UNITY_SAMPLE_TEXCUBE est un macro qui �chantillonne un cubemap, permet d'�conomiser des emplacements d'�chantillonneur
                // unity_SpecCube0 contient de donn�es pour la sonde de reflexion active
                half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, i.worldRefl);
                // decode les donn�es cubemap en couleur r�elle
                half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR);
         
                //Rendu couleurs
                fixed4 c = 0;
                c.rgb = skyColor;
                return c;
            }
            ENDCG
        }
    }
}