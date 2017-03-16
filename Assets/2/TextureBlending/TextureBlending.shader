Shader "Shaders/ScaleBlendable" 
{
	Properties 
	{
		_MainTint("Diffuse Tint", Color) = (1,1,1,1)

		// add the properties below so we can input all of our textures
		_ColorA("terrain color a", Color) = (1,1,1,1)
		_ColorB("terrain color b", Color) = (1,1,1,1)
		_RTexture("r channel texture", 2D) = "White"{}
		_GTexture("g channel texture", 2D) = "White"{}
		_BTexture("b channel texture", 2D) = "White"{}
		_ATexture("a channel texture", 2D) = "White"{}
		_BlendTex("blend texture", 2D) = "White"{}
	}

	SubShader
	{	Tags  { "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM
			#pragma surface surf Lambert
			#pragma target 4.0

			float4 _MainTint;
			float4 _ColorA;
			float4 _ColorB;
			sampler2D _RTexture;
			sampler2D _GTexture;
			sampler2D _BTexture;
			sampler2D _ATexture;
			sampler2D _BlendTex;


		struct Input 
		{
			float2 uv_RTexture;
			float2 uv_GTexture;
			float2 uv_BTexture;
			float2 uv_ATexture;
			float2 uv_BlendTex;
		};


		void surf (Input IN, inout SurfaceOutput o)
		{
			// get the pixel data from the blend texture
			// we need a float4 here because the texture will return rgba or xyzw
			float4 blendData = tex2D(_BlendTex, IN.uv_BlendTex);

			// get the data from the textures we want to blend
			float4 rTexData = tex2D(_RTexture, IN.uv_RTexture);
			float4 gTexData = tex2D(_GTexture, IN.uv_GTexture);
			float4 bTexData = tex2D(_BTexture, IN.uv_BTexture);
			float4 aTexData = tex2D(_ATexture, IN.uv_ATexture);

			// now we need to contruct a new rgba value and add all  the different blended texture back together
			float4 finalColor;
			finalColor = lerp(rTexData, gTexData, blendData.g);
			finalColor = lerp(finalColor, bTexData, blendData.b);
			finalColor = lerp(finalColor, aTexData, blendData.a);
			finalColor.a = 1.0;

			// add on our terrian tinting colors
			float4 terrainLayers = lerp(_ColorA, _ColorB, blendData.r);
			finalColor *= terrainLayers;
			finalColor = saturate(finalColor);

			o.Albedo = finalColor.rgb * _MainTint.rgb;
			o.Alpha = finalColor.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
