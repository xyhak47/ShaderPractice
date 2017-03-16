Shader "CookbookShaders/Chapter03/SpecularMask" 
{
	Properties 
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		_MainTint("main tint", Color) = (1,1,1,1)
		_SpecularColor("specular color", Color) = (1,1,1,1)
		_SpecPower("specular power", Range(0.1, 60)) = 3

	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM

		#pragma surface surf CustomBlinnPhong

		sampler2D _MainTex;
		float4 _MainTint;
		float4 _SpecularColor;
		float _SpecPower;

		struct Input
		 {
			float2 uv_MainTex;
		};

		inline fixed4 LightingCustomBlinnPhong(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float3 halfVector = normalize(lightDir + viewDir);

			// calculate diffuse and the reflection vector
			float diff = dot(s.Normal, lightDir);

			float nh = max(0, dot(s.Normal, lightDir));
			float spec = pow(nh, _SpecPower) * _SpecularColor;

			float4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb  * spec) * (atten * 2);
			c.a = 1.0;
			return c;
		}


		void surf (Input IN, inout SurfaceOutput o) 
		{
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
