using UnityEngine;

[ExecuteInEditMode]
public class BlendMode_ImageEffect : MonoBehaviour
{
    #region variables
    public Shader CurrentShader;
    private Material CurrentMaterial;

    public Texture2D BlendTexture;
    public float BlendOpacity;
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
            SelfMaterial.SetTexture("_BlendTex", BlendTexture);
            SelfMaterial.SetFloat("_Opacity", BlendOpacity);
            Graphics.Blit(SourceTexture, DestTexture, SelfMaterial);
        }
        else
        {
            Graphics.Blit(SourceTexture, DestTexture);
        }
    }

    void Update()
    {
        BlendOpacity = Mathf.Clamp(BlendOpacity, 0, 1);
    }

    void OnDisable()
    {
        if (CurrentMaterial)
        {
            DestroyImmediate(CurrentMaterial);
        }
    }
}
