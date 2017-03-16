Shader "CookbookShaders/Chapter02/PhotoshopLevels"
{

Properties
 {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		_inBlack("Input black", Range(0, 255)) = 0
		_inGamma("Input gamma", Range(0, 255)) = 1.61
		_inWhite("Input white", Range(0, 255)) = 255

		_outBlack("output black", Range(0, 255)) = 0
		_outWhite("output white", Range(0, 255)) = 255

	}

	SubShader
	 {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;

		float _inWhite;
		float _inGamma;
		float _inBlack;
		float _outWhite;
		float _outBlack;


		struct Input 
		{
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		float GetPixelLevel(float pixelColor)
		{
			float pixelResult;
			pixelResult = pixelColor * 255;
			pixelResult = max(0, pixelResult - _inBlack);
			pixelResult = saturate(pow(pixelResult / (_inWhite - _inBlack), _inGamma));
			pixelResult = (pixelResult * (_outWhite - _outBlack) + _outBlack) / 255;
			return pixelResult;
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			half4 c = tex2D(_MainTex, IN.uv_MainTex);

			float outRPixel = GetPixelLevel(c.r);
			float outGPixel = GetPixelLevel(c.g);
			float outBPixel = GetPixelLevel(c.b);

			o.Albedo = float3(outRPixel, outGPixel, outBPixel);
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
 