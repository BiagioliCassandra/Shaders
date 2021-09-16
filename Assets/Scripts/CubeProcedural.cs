using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CubeProcedural : MonoBehaviour
{
    public Material myMaterial;

    private MeshRenderer meshRenderer;
    private MeshFilter meshFilter;

    private Vector3[] myVertex = new Vector3[] { 
        // 1e face (gauche)
        new Vector3(0.0f, 0.0f, 0.0f), // Bas Gauche
        new Vector3(1.0f, 0.0f, 0.0f), // Bas Droit
        new Vector3(0.0f, 1.0f, 0.0f), // Haut Gauche
        new Vector3(1.0f, 1.0f, 0.0f), // Haut Droit
        // 2e face (dessus)
        new Vector3(0.0f, 1.0f, 0.0f), 
        new Vector3(1.0f, 1.0f, 0.0f), 
        new Vector3(0.0f, 1.0f, 1.0f), 
        new Vector3(1.0f, 1.0f, 1.0f), 
        // 3e face (droite)
        new Vector3(0.0f, 0.0f, 1.0f),
        new Vector3(1.0f, 0.0f, 1.0f),
        new Vector3(0.0f, 1.0f, 1.0f),
        new Vector3(1.0f, 1.0f, 1.0f),
        // 4e face (arrière)
        new Vector3(0.0f, 0.0f, 0.0f),
        new Vector3(1.0f, 0.0f, 0.0f),
        new Vector3(0.0f, 0.0f, 1.0f),
        new Vector3(1.0f, 0.0f, 1.0f),
        // 5e face (gauche)
        new Vector3(0.0f, 0.0f, 0.0f),
        new Vector3(1.0f, 0.0f, 1.0f),
        new Vector3(0.0f, 1.0f, 1.0f),
        new Vector3(0.0f, 1.0f, 1.0f),
        // 6e face (droite)
        new Vector3(1.0f, 0.0f, 0.0f),
        new Vector3(1.0f, 0.0f, 1.0f),
        new Vector3(1.0f, 1.0f, 0.0f),
        new Vector3(1.0f, 1.0f, 1.0f)
    };

    private Vector2[] myUVs = new Vector2[] {
        // 1e face (gauche)
        new Vector2(0.0f, 0.0f), // Bas Gauche
        new Vector2(1.0f, 0.0f), // Bas Droit
        new Vector2(0.0f, 1.0f), // Haut Gauche
        new Vector2(1.0f, 1.0f), // Haut Droit
        // 2e face (dessus)
        new Vector2(0.0f, 1.0f),
        new Vector2(1.0f, 1.0f),
        new Vector2(0.0f, 1.0f),
        new Vector2(1.0f, 1.0f), 
        // 3e face (droite)
        new Vector2(0.0f, 0.0f),
        new Vector2(1.0f, 0.0f),
        new Vector2(0.0f, 1.0f),
        new Vector2(1.0f, 1.0f),
        // 4e face (arrière)
        new Vector2(0.0f, 0.0f),
        new Vector2(1.0f, 0.0f),
        new Vector2(0.0f, 0.0f),
        new Vector2(1.0f, 0.0f),
        // 5e face (gauche)
        new Vector2(0.0f, 0.0f),
        new Vector2(1.0f, 0.0f),
        new Vector2(0.0f, 1.0f),
        new Vector2(0.0f, 1.0f),
        // 6e face (droite)
        new Vector2(1.0f, 0.0f),
        new Vector2(1.0f, 0.0f),
        new Vector2(1.0f, 1.0f),
        new Vector2(1.0f, 1.0f)
    };

    private int[] myTriangles = new int[] { 
        //Ma 1ere face
        0, 2, 1, // Mon 1er triangle
        2, 3, 1, // Mon 2nd triangle
        //Ma 2e face
        4, 6, 5, // 1er triangle
        6, 7, 5, // 2e triangle        
        //Ma 3e face
        8, 10, 9, // 1er triangle
        10, 11, 9, // 2e triangle
        //Ma 4e face
        12, 14, 13, // 1er triangle
        14, 15, 13, // 2e triangle
        //Ma 5e face
        16, 18, 17, // 1er triangle
        18, 19, 17, // 2e triangle
        //Ma 6e face
        20, 22, 21, // 1er triangle
        22, 23, 21, // 2e triangle
    };

    private Color[] myColors = new Color[] {
        new Color(1.0f, 0.0f, 0.0f), //Rouge
        new Color(0.0f, 1.0f, 0.0f), //Vert
        new Color(0.0f, 0.0f, 1.0f), //Bleu
        new Color(1.0f, 0.0f, 1.0f), // ???

        new Color(1.0f, 0.0f, 1.0f), // ???
        new Color(1.0f, 0.5f, 0.4f), // ???
        new Color(0.1f, 0.7f, 1.0f), // ???
        new Color(1.0f, 0.0f, 1.0f), // ???

        new Color(0.8f, 0.5f, 1.0f), // ???
        new Color(0.5f, 0.8f, 1.0f), // ???
        new Color(0.2f, 0.3f, 1.0f), // ???
        new Color(1.0f, 0.7f, 1.0f), // ???
        
        new Color(0.1f, 1.0f, 1.0f), // ???
        new Color(0.9f, 0.3f, 0.5f), // ???
        new Color(1.0f, 0.5f, 0.6f), // ???
        new Color(0.2f, 0.5f, 0.4f), // ???

        new Color(0.1f, 1.0f, 1.0f), // ???
        new Color(0.9f, 0.3f, 0.5f), // ???
        new Color(1.0f, 0.5f, 0.6f), // ???
        new Color(0.2f, 0.5f, 0.4f), // ???

        new Color(0.1f, 1.0f, 1.0f), // ???
        new Color(0.9f, 0.3f, 0.5f), // ???
        new Color(1.0f, 0.5f, 0.6f), // ???
        new Color(0.2f, 0.5f, 0.4f), // ???
    };

    // Start is called before the first frame update
    void Start()
    {
        meshRenderer = gameObject.AddComponent<MeshRenderer>();
        meshRenderer.material = myMaterial;
        meshFilter = gameObject.AddComponent<MeshFilter>();

        meshFilter.mesh = new Mesh();

        //Coordonnées de mes points
        meshFilter.mesh.vertices = myVertex; 
        //Indices de points constituants mes faces
        meshFilter.mesh.triangles = myTriangles;
        //Couleurs de mes points
        meshFilter.mesh.colors = myColors;
        //UVs de mes points
        //meshFilter.mesh.uv = myUVs;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
