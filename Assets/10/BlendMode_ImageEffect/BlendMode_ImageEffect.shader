Shader"CookbookShaders/Chapter10/BlendMode_Effect" 
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

	

			fixed4 frag (v2f i) : SV_Target
			{
				// get the colors from the render texture and the uv's from the v2f struct
				fixed4 renderTex = tex2D(_MainTex, i.uv);
				fixed4 blendTex = tex2D(_BlendTex, i.uv);

				// perform a multiply blend mode
				//fixed4 blendedMultiply = renderTex * blendTex;
				//fixed4 blendedAdd = renderTex + blendTex;
				fixed4 blendedScreen = (1 - (1 - renderTex) * (1 - blendTex));


				// adjust amount of blend mode with a lerp
				renderTex = lerp(renderTex, blendedScreen, _Opacity);

				return renderTex;

			}
			ENDCG
		}
	}
}
