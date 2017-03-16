Shader"CookbookShaders/Chapter10/Overlay_Effect" 
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BlendTex("Blend Texture", 2D) = "white" {}
		_Opacity("Opacity",Range(0,1)) = 1
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
			uniform sampler2D _BlendTex;
			float _Opacity;

			fixed OverlayBlendMode(fixed basePixel, fixed blendPixel)
			{
				if(basePixel < 0.5)
				{
					return (2.0 * basePixel * blendPixel);
				}
				else
				{
					return (1.0 - 2.0 * (1.0 - basePixel) * (1 - blendPixel));
				}
			}


			fixed4 frag (v2f i) : SV_Target
			{
				// get the colors from the render texture and the uv's from the v2f struct
				fixed4 renderTex = tex2D(_MainTex, i.uv);
				fixed4 blendTex = tex2D(_BlendTex, i.uv);


				fixed4 blendedImage = renderTex;
				blendedImage.r = OverlayBlendMode(renderTex.r, blendTex.r);
				blendedImage.g = OverlayBlendMode(renderTex.g, blendTex.g);
				blendedImage.b = OverlayBlendMode(renderTex.b, blendTex.b);

	
				// adjust amount of blend mode with a lerp
				renderTex = lerp(renderTex, blendedImage, _Opacity);

				return renderTex;

			}
			ENDCG
		}
	}
}
