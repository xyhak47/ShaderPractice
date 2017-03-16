Shader"CookbookShaders/Chapter10/BSC_ImageEffect" 
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BrightnessAmount("Brightness Amount", Range(0, 1))  = 1
		_SaturationAmount("Saturation Amount", Range(0, 1)) = 1
		_ContrastAmount("Contrast Amount", Range(0, 1)) = 1
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
			fixed _BrightnessAmount;
			fixed _SaturationAmount;
			fixed _ContrastAmount;

			float3 ContrastSaturationBrightness(float3 color, float brt, float sat, float con)
			{
				// increase or decrease these values to adjust rgb color channels asparately
				float AvgLumR = 0.5;
				float AvgLumG = 0.5;
				float AvgLumB = 0.5;

				// Luminance coefficienets for getting Luminance from the images
				float3 LuminanceCoeff = float3(0.2125, 0.7154, 0.0721);

				// operation for Brightness
				float3 AvgLumn = float3(AvgLumR, AvgLumG, AvgLumB);
				float3 brtColor = color * brt;
				float intensityf = dot(brtColor, LuminanceCoeff);
				float3 intensity = float3(intensityf, intensityf, intensityf);

				// operation for Saturation
				float3 satColor = lerp(intensity, brtColor, sat);

				// operation for Contrast
				float3 conColor = lerp(AvgLumn, satColor, con);

				return conColor;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				// get the colors from the render texture and the uv's from the v2f struct
				fixed4 renderTex = tex2D(_MainTex, i.uv);


				// apply the Brightness, Saturation, Contrast operation
				renderTex.rgb = ContrastSaturationBrightness(renderTex.rgb, _BrightnessAmount, _SaturationAmount, _ContrastAmount);

				return renderTex;

			}
			ENDCG
		}
	}
}
