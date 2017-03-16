Shader "Shaders/SpriteAtlas" 
{
	Properties
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		// create the properties below
		_TexWidth("Sheet Width", float) = 0.0
		_CellAmount("Cell Amount", float) = 0.0
		_Speed("Speed", Range(0.01, 32)) = 12

	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input 
		{
			float2 uv_MainTex;
		};

		float _TexWidth;
		float _CellAmount;
		float _Speed;

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			// let's store our uvs in a separate variable
			float2 spriteUV = IN.uv_MainTex;

			// let's calculate the width of a single cell in our
			// sprite sheet and get a uv percentage that each cell takes up
			float cellPixelWidth = _TexWidth / _CellAmount;
			float cellUVPercentage = cellPixelWidth / _TexWidth;

			// let's get a stair setp value out of time so we can increment the uv offset
			float timeVal = fmod(_Time.y * _Speed, _CellAmount);
			timeVal = ceil(timeVal);

			// animate the uvs forward by the width percentage of each cell
			float xValue = spriteUV.x;

			xValue += cellUVPercentage * timeVal * _CellAmount;
			xValue *= cellUVPercentage;

			spriteUV = float2(xValue, spriteUV.y);

			half4 c = tex2D(_MainTex, spriteUV);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		
		}
		ENDCG
	}
	FallBack "Diffuse"
}
