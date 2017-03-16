Shader "CookbookShaders/Chapter10/NightVisionEffectShader" 
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_VignetteTex("Vignette Texture", 2D) = "white"{}
		_ScanLineTex("Scan Line Texture", 2D) = "white"{}
		_NoiseTex("Noise Texture", 2D) = "white"{}
		_NoiseXSpeed("Noise X Speed", Float) = 100.0
		_NoiseYSpeed("Noise Y Speed", Float) = 100.0
		_ScanLineTileAmount("Scan Line Tile Amount", Float) = 4.0
		_NightVisionColor("Night Vision Color", Color) = (1,1,1,1)
		_Contrast("Contrast", Range(0,4)) = 2
		_Brightness("Brightness", Range(0,2)) = 1
		_RandomValue("Random Value", Float) = 0
		_Distortion("Distortion", Float) = 0.2
		_Scale("Scale (Zoom)", Float) = 0.8
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
			uniform sampler2D _ScanLineTex;
			uniform sampler2D _NoiseTex;
			fixed4 _NightVisionColor;
			fixed _Contrast;
			fixed _ScanLineTileAmount;
			fixed _Brightness;
			fixed _RandomValue;
			fixed _NoiseXSpeed;
			fixed _NoiseYSpeed;
			fixed _Distortion;
			fixed _Scale;

			float2 BarrelDistortion(float2 Coord)
			{
				float2 h = Coord.xy - float2(0.5, 0.5);
				float r2 = h.x * h.x + h.y * h.y;
				float f = 1.0 + r2 * (_Distortion * sqrt(r2));

				return f * _Scale * h + 0.5;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				half2 distortionUV = BarrelDistortion(i.uv);
				fixed4 renderTex = tex2D(_MainTex, distortionUV);
				fixed4 vignetteTex = tex2D(_VignetteTex, i.uv);

				// process scan lines and noise
				half2 scanLinesUV = half2(i.uv.x * _ScanLineTileAmount, i.uv.y * _ScanLineTileAmount);
				fixed4 scanLinesTex = tex2D(_ScanLineTex, scanLinesUV);

				half2 noiseUV = half2(i.uv.x + _RandomValue * _SinTime.z * _NoiseXSpeed, i.uv.y +  _Time.x * _NoiseYSpeed);
				fixed4 noiseTex = tex2D(_NoiseTex, noiseUV);

				// get the lunminosity Values from the render texture using the YIQ Values
				fixed lum = dot(fixed3(0.299, 0.587, 0.114), renderTex.rgb);
				lum += _Brightness;

				fixed4 finalColor = (lum * 2) + _NightVisionColor;

				// final output
				finalColor = pow(finalColor, _Contrast);
				finalColor *= vignetteTex;
				finalColor *= scanLinesTex * noiseTex;

				return finalColor;
			}
			ENDCG
		}
	}
}
