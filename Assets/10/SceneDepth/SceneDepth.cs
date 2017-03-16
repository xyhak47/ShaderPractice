using UnityEngine;

[ExecuteInEditMode]
public class SceneDepth : MonoBehaviour
{
    #region variables
    public Shader CurrentShader;
    private Material CurrentMaterial;

    public float DepthPower = 1.0f;
    #endregion

    Material SelfMaterial
    {
        get
        {
            if (CurrentMaterial == null)
            {
                CurrentMaterial = new Material(CurrentShader);
                CurrentMaterial.hideFlags = HideFlags.HideAndDontSave;
            }

            return CurrentMaterial;
        }
    }

    void Start()
    {
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }

        if (!CurrentShader && !CurrentShader.isSupported)
        {
            enabled = false;
        }
    }

    void OnRenderImage(RenderTexture SourceTexture, RenderTexture DestTexture)
    {
        if (CurrentShader != null)
        {
            SelfMaterial.SetFloat("_DepthPower", DepthPower);
            Graphics.Blit(SourceTexture, DestTexture, SelfMaterial);
        }
        else
        {
            Graphics.Blit(SourceTexture, DestTexture);
        }
    }

    void Update()
    {
        Camera.main.depthTextureMode = DepthTextureMode.Depth;
        DepthPower = Mathf.Clamp(DepthPower, 0, 5);
    }

    void OnDisable()
    {
        if (CurrentMaterial)
        {
            DestroyImmediate(CurrentMaterial);
        }
    }
}
