using UnityEngine;

[ExecuteInEditMode]
public class BSC_ImageEffect : MonoBehaviour
{
    #region variables
    public Shader CurrentShader;
    private Material CurrentMaterial;

    public float BrightnessAmount;
    public float SaturationAmount;
    public float ContrastAmount;
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
            SelfMaterial.SetFloat("_BrightnessAmount", BrightnessAmount);
            SelfMaterial.SetFloat("_SaturationAmount", SaturationAmount);
            SelfMaterial.SetFloat("_ContrastAmount", ContrastAmount);

            Graphics.Blit(SourceTexture, DestTexture, SelfMaterial);
        }
        else
        {
            Graphics.Blit(SourceTexture, DestTexture);
        }
    }

    void Update()
    {
        BrightnessAmount = Mathf.Clamp(BrightnessAmount, 0, 2);
        SaturationAmount = Mathf.Clamp(SaturationAmount, 0, 2);
        ContrastAmount = Mathf.Clamp(ContrastAmount, 0, 3);
    }

    void OnDisable()
    {
        if (CurrentMaterial)
        {
            DestroyImmediate(CurrentMaterial);
        }
    }
}
