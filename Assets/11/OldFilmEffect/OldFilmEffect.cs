using UnityEngine;
using System.Collections;

public class OldFilmEffect : MonoBehaviour
{
    #region variables
    public Shader OldFilmShader;

    public float OldFilmEffectAmount = 1.0f;

    public Color SpeciaColor = Color.white;
    public Texture2D VignetteTexture;
    public float VignetteAmount = 1.0f;

    public Texture2D ScratchesTexture;
    public float ScratchesYSpeed = 10.0f;
    public float ScratchesXSpeed = 10.0f;

    public Texture2D DustTexture;
    public float DustYSpeed = 10.0f;
    public float DustXSpeed = 10.0f;

    private Material CurrentMaterial;
    private float RandomValue;
    #endregion

    Material SelfMaterial
    {
        get
        {
            if(!CurrentMaterial)
            {
                CurrentMaterial = new Material(OldFilmShader);
                CurrentMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            return CurrentMaterial;
        }
    }

    // Use this for initialization
    void Start ()
    {

    }
	
	// Update is called once per frame
	void Update ()
    {
        VignetteAmount = Mathf.Clamp01(VignetteAmount);
        OldFilmEffectAmount = Mathf.Clamp(OldFilmEffectAmount, 0, 1.5f);
        RandomValue = Random.Range(-1f, 1f);
	}

    void OnRenderImage(RenderTexture SourceTexture, RenderTexture DestTexture)
    {
        if(OldFilmShader != null)
        {
            SelfMaterial.SetColor("_SpeciaColor", SpeciaColor);
            SelfMaterial.SetFloat("_VignetteAmount", VignetteAmount);
            SelfMaterial.SetFloat("_EffectAmount", OldFilmEffectAmount);

            if(VignetteTexture)
            {
                SelfMaterial.SetTexture("_VignetteTex", VignetteTexture);
            }

            if (ScratchesTexture)
            {
                SelfMaterial.SetTexture("_ScratchesTex", ScratchesTexture);
                SelfMaterial.SetFloat("_ScratchesXSpeed", ScratchesXSpeed);
                SelfMaterial.SetFloat("_ScratchesYSpeed", ScratchesYSpeed);

            }

            if (DustTexture)
            {
                SelfMaterial.SetTexture("_DustTex", DustTexture);
                SelfMaterial.SetFloat("_DustXSpeed", DustXSpeed);
                SelfMaterial.SetFloat("_DustYSpeed", DustYSpeed);
                SelfMaterial.SetFloat("_RandomValue", RandomValue);
            }

            Graphics.Blit(SourceTexture, DestTexture, SelfMaterial);
        }
        else
        {
            Graphics.Blit(SourceTexture, DestTexture);
        }
    }
}
