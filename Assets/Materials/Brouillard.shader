Shader "Unlit/Brouillard"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
        SubShader{
            Pass {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                //Needed for fog variation to be compiled.
                #pragma multi_compile_fog

                #include "UnityCG.cginc"

                struct vertexInput {
                    float4 vertex : POSITION;
                    // La première coordonnée UV
                    float4 texcoord0 : TEXCOORD0;
                };

                struct fragmentInput {
                    float4 position : SV_POSITION;
                    float4 texcoord0 : TEXCOORD0;

                    // Utilisé pour transmettre la quantité de brouillard autour du nombre qui devra être un texcoord libre
                    // UNITY_FOG_COORDS(texcoordindex) déclare l'interpolateur de données de brouillard.
                    UNITY_FOG_COORDS(1)
                };

                fragmentInput vert(vertexInput i) {
                    fragmentInput o;
                    o.position = UnityObjectToClipPos(i.vertex);
                    o.texcoord0 = i.texcoord0;

                    // Calcule la quantité de brouillard à partir de la position de l'espace de découpage.
                    UNITY_TRANSFER_FOG(o,o.position);
                    return o;
                }

                fixed4 frag(fragmentInput i) : SV_Target {
                    fixed4 color = fixed4(i.texcoord0.xy,0,0);

                // Applique le brouillard à la couleur
                UNITY_APPLY_FOG(i.fogCoord, color);

                return color;
            }
            ENDCG
        }
    }
}
