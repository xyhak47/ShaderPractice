Shader "Shaders/Scroll" {
	Properties 
	{
		_MainTint("Diffuse Tint", Color) = (1,1,1,1)
		_MainTex("Base (RGB)", 2D) = "White" {}
		_ScrollXSpeed("X Scroll Speed", Range(0,10)) = 2
		_ScrollYSpeed("Y Scroll Speed", Range(0,10)) = 2

	}
		SubShader{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf Standard fullforwardshadows


		float4 _MainTint;
		fixed _ScrollXSpeed;
		fixed _ScrollYSpeed;
		sampler2D _MainTex;

		struct Input 
		{
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			// create a separate variable to store out uvs
			// before we pass them to the tex2D() function
			fixed2 scrolledUV = IN.uv_MainTex;

			// create varibale that store the individual x and y
			fixed xScrollValue = _ScrollXSpeed * _Time;
			fixed yScrollValue = _ScrollYSpeed * _Time;

			// apply the final uv offset
			scrolledUV += fixed2(xScrollValue, yScrollValue);

			// apply textures and tint
			half4 c = tex2D(_MainTex, scrolledUV);
			o.Albedo = c.rgb * _MainTint;
			o.Alpha = c.a;


		}
		ENDCG
	}
	FallBack "Diffuse"
}
