Shader "CookbookShaders/Chapter02/NormalMapping" 
{
	Properties 
	{
		_MainTint("Diffuse tint", Color) = (1,1,1,1)
		_NormalTex("normal tex", 2D) = "white" {}
		_NormalMapIntensity(" nomal map intensity", Range(0,2)) = 1

	}
	
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		//Link the property to the CG program
		sampler2D _NormalTex;
		float4 _MainTint;
		float _NormalMapIntensity;

		// make sure you get the uvs for the texture in the struct
		struct Input
		{
			float2 uv_NormalTex;
		};


		void surf (Input IN, inout SurfaceOutput o) 
	 	{
	 		// get the normal data out of the normal map textrues
	 		// using the UnpackNormal() function
	 		float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
	 		normalMap = float3(normalMap.x * _NormalMapIntensity, normalMap.y* _NormalMapIntensity, normalMap.z );

	 		// apply the new normals to the lighting model
	 		o.Normal = normalMap.rgb ;
			o.Albedo = _MainTint.rgb;
	 		o.Alpha =  _MainTint.a;

		}
		ENDCG
	}
	FallBack "Diffuse"
}
