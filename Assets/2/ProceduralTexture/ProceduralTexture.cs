using UnityEngine;

public class ProceduralTexture : MonoBehaviour
{
    #region public variables
    public int widthHeight = 512;
    public Texture2D generatedTexture;
    #endregion

    #region private variables
    private Material currentMaterial;
    private Vector2 centerPosition;
    #endregion

    // Use this for initialization
    void Start ()
    {
        if (!currentMaterial)
        {
            currentMaterial = GetComponent<MeshRenderer>().sharedMaterial;
            if (!currentMaterial)
            {
                Debug.LogWarning("can not find a material on:" + transform.name);
            }
        }

        if (currentMaterial)
        {
            centerPosition = new Vector2(0.5f, 0.5f);
            generatedTexture = GenerateParabola();

            currentMaterial.SetTexture("_MainTex", generatedTexture);
        }

	}

    private Texture2D GenerateParabola()
    {
        Texture2D proceduralTexture = new Texture2D(widthHeight, widthHeight);

        Vector2 centerPixelPosition = centerPosition * widthHeight;

        for (int x = 0; x < widthHeight; x++)
        {
            for (int y = 0; y < widthHeight; y++)
            {
                Vector2 currentPosition = new Vector2(x, y);
                float pixelDistance = Vector2.Distance(currentPosition, centerPixelPosition) / (widthHeight * 0.5f);

                pixelDistance = Mathf.Abs(1-Mathf.Clamp(pixelDistance, 0, 1f));

                // 1
                pixelDistance = Mathf.Sin(pixelDistance * 30.0f) + pixelDistance;

                // 2
                //Vector2 pixelDirection = centerPixelPosition - currentPosition;
                //float rightDirection = Vector2.Dot(pixelDirection, Vector3.right);
                //float leftDirection = Vector2.Dot(pixelDirection, Vector3.left);
                //float upDirection = Vector2.Dot(pixelDirection, Vector3.up);

                // 3
                //Vector2 pixelDirection = centerPixelPosition - currentPosition;
                //float rightDirection = Vector2.Angle(pixelDirection, Vector3.right) / 360;
                //float leftDirection = Vector2.Angle(pixelDirection, Vector3.left) / 360;
                //float upDirection = Vector2.Angle(pixelDirection, Vector3.up) / 360;

                Color pixelColor = new Color(pixelDistance, pixelDistance, pixelDistance, 1.0f);

                proceduralTexture.SetPixel(x, y, pixelColor);
            }
        }

        proceduralTexture.Apply();

        return proceduralTexture;
    }
}
