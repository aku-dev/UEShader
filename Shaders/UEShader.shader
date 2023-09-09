Shader "AKStudio/UEShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MaskTex ("Mask (RGB)", 2D) = "white" {}
        _NormalTex ("Normal (RGB)", 2D) = "bump" {}
        _Metallic ("Metallic", Range(0,2)) = 1.0
        _Smoothness ("Smoothness", Range(0,2)) = 1.0
    }
   SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _MaskTex;
        sampler2D _NormalTex;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MaskTex;
            float2 uv_NormalTex;
        };
		
        UNITY_INSTANCING_BUFFER_START(Props)

        fixed4 _Color;

        half _Smoothness;
        half _Metallic;
        half _Sharpness;

        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 col = tex2D (_MainTex, IN.uv_MainTex) * _Color;

            o.Albedo = col.rgb;

            fixed4 m = tex2D (_MaskTex, IN.uv_MaskTex);

            o.Metallic   =  m.b * _Metallic;
            o.Smoothness =  1.0f - m.g * _Smoothness;

            o.Occlusion = m.r;
			
			// Invert G chanel
			fixed3 unormal = UnpackNormal (tex2D (_NormalTex, IN.uv_NormalTex));
			unormal.g = -unormal.g;
            o.Normal = unormal;

            o.Alpha = col.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}