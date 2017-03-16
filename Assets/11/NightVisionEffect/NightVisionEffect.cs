using UnityEngine;

[ExecuteInEditMode]
public class NightVisionEffect : MonoBehaviour
{
    #region variables
    public Shader NightVisionShader;
    private Material CurrentMaterial;

    public float Contrast = 2.0f;
    public float Brightness = 1.0f;
    public Color NightVisionColor = Color.white;

    public Texture2D VignetteTexture;

    public Texture2D ScanLineTexture;
    public float ScanLineTileAmount = 4.0f;

    public Texture2D NightVisionNoise;
    public float NoiseXSpeed = 100.0f;
    public float NoiseYSpeed = 100.0f;

    public float Distortion = 0.2f;
    public float Scale = 0.8f;

    private float RandomValue = 0.0f;
    #endregion

    Material SelfMaterial
    {
        get
        {
            if (CurrentMaterial == null)
            {
                CurrentMaterial = new Material(NightVisionShader);
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

        if (!NightVisionShader && !NightVisionShader.isSupported)
        {
            enabled = false;
        }
    }

    void OnRenderImage(RenderTexture SourceTexture, RenderTexture DestTexture)
    {
        if (NightVisionShader != null)
        {
            SelfMaterial.SetFloat("_Contrast", Contrast);
            SelfMaterial.SetFloat("_Brightness", Brightness);
            SelfMaterial.SetColor("_NightVisionColor", NightVisionColor);
            SelfMaterial.SetFloat("_RandomValue", RandomValue);
            SelfMaterial.SetFloat("_Distortion", Distortion);
            SelfMaterial.SetFloat("_Scale", Scale);

            if (VignetteTexture)
            {
                SelfMaterial.SetTexture("_VignetteTex", VignetteTexture);
            }

            if (ScanLineTexture)
            {
                SelfMaterial.SetTexture("_ScanLineTex", ScanLineTexture);
                SelfMaterial.SetFloat("_ScanLineTileAmount", ScanLineTileAmount);
            }

            if (NightVisionNoise)
            {
                SelfMaterial.SetTexture("_NoiseTex", NightVisionNoise);
                SelfMaterial.SetFloat("_NoiseXSpeed", NoiseXSpeed);
                SelfMaterial.SetFloat("_NoiseYSpeed", NoiseYSpeed);
            }

            Graphics.Blit(SourceTexture, DestTexture, SelfMaterial);
        }
        else
        {
            Graphics.Blit(SourceTexture, DestTexture);
        }
    }

    void Update()
    {
        Contrast = Mathf.Clamp(Contrast, 0, 4f);
        Brightness = Mathf.Clamp(Brightness, 0, 2f);
        Distortion = Mathf.Clamp(Distortion, -1, 1f);
        Scale = Mathf.Clamp(Scale, 0, 3f);
        RandomValue = Random.Range(-1f, 1f);
    }

    void OnDisable()
    {
        if (CurrentMaterial)
        {
            DestroyImmediate(CurrentMaterial);
        }
    }
}
