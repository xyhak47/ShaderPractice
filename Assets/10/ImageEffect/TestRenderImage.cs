using UnityEngine;

[ExecuteInEditMode]
public class TestRenderImage : MonoBehaviour
{
    #region variables
    public Shader CurrentShader;
    public float GrayScaleAmount = 1.0f;
    private Material CurrentMaterial;
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
            SelfMaterial.SetFloat("_LuminosityAmount", GrayScaleAmount);
            Graphics.Blit(SourceTexture, DestTexture, SelfMaterial);
        }
        else
        {
            Graphics.Blit(SourceTexture, DestTexture);
        }
    }

    void Update()
    {
        GrayScaleAmount = Mathf.Clamp(GrayScaleAmount, 0, 1);
    }

    void OnDisable()
    {
        if(CurrentMaterial)
        {
            DestroyImmediate(CurrentMaterial);
        }
    }
}
