Shader "CookbookShaders/Chapter10/OldFilmEffectShader" 
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SpeciaColor("_SpeciaColor", Color) = (1,1,1,1)
		_VignetteAmount("_VignetteAmount", Float) = 1.0
		_EffectAmount("_EffectAmount", Float) = 1.0
		_VignetteTex("_VignetteTex", 2D) = "white" {}
		_ScratchesTex("_ScratchesTex", 2D) = "white" {}
		_ScratchesXSpeed("_ScratchesXSpeed", Float) = 10.0
		_ScratchesYSpeed("_ScratchesYSpeed", Float) = 10.0
		_DustTex("_DustTex", 2D) = "white" {}
		_DustXSpeed("_DustXSpeed", Float) = 10.0
		_DustYSpeed("_DustYSpeed", Float) = 10.0
		_RandomValue("_RandomValue,", Float) = 1.0
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
				

			uniform sampler2D _MainTex;
			uniform sampler2D _VignetteTex;
			uniform sampler2D _ScratchesTex;
			uniform sampler2D _DustTex;

			float4 _SpeciaColor;

			fixed _VignetteAmount;
			fixed _ScratchesYSpeed;
			fixed _ScratchesXSpeed;
			fixed _DustYSpeed;
			fixed _DustXSpeed;
			fixed _EffectAmount;
			fixed _RandomValue;


			fixed4 frag (v2f i) : SV_Target
			{
				half2 renderTexUV = half2(i.uv.x, i.uv.y + (_RandomValue * _SinTime.z * 0.005));
				fixed4 renderTex = tex2D(_MainTex, renderTexUV);

				// get the pixels from the vignette Texture
				fixed4 vignetteTex = tex2D(_VignetteTex, i.uv);

				// process the scratches uv and pixels
				half2 scratchesUV = half2(i.uv.x + _RandomValue * _SinTime.z * _ScratchesXSpeed, i.uv.y + _RandomValue * _Time.x * _ScratchesYSpeed);
				fixed4 scratchesTex = tex2D(_ScratchesTex, scratchesUV);

				// process the dust uv and pixels
				half2 dustUV = half2(i.uv.x + _RandomValue * _SinTime.z * _DustXSpeed, i.uv.y + _RandomValue * _SinTime.z * _DustYSpeed);
				fixed4 dustTex = tex2D(_DustTex, dustUV);

				// get the luminosity values from the render texture using the YIQ values
				fixed lum = dot(fixed3(0.229, 0.587, 0.114), renderTex.rgb);

				// add the constant color to the lum values
				fixed4 finalColor = lum + lerp(_SpeciaColor, _SpeciaColor + fixed4(0.1f, 0.1f, 0.1f, 0.1f), _RandomValue);

				// create a constant white color we can use to adjust opacity of effect 
				fixed3 constantWhite = fixed3(1,1,1);

				// composite together the different layers to create final screen effect
				finalColor = lerp(finalColor, finalColor * vignetteTex, _VignetteAmount);
				finalColor.rgb *= lerp(scratchesTex, constantWhite, _RandomValue);
				finalColor.rgb *= lerp(dustTex.rgb, constantWhite, _RandomValue * _SinTime.z);
				finalColor.rgb *= lerp(renderTex, finalColor, _EffectAmount);

				return finalColor;

			}
			ENDCG
		}
	}
}
