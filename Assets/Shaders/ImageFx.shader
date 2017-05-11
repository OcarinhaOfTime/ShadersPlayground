Shader "Unlit/ImageFx"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color("Tint", Color) = (1,1,1,1)
		_DistortionMap("DistortionMap", 2D) = "white" {}
		_DistortionMag("Distortion Magnitude", Range(0, .1)) = .01
		_Speed("Speed", Float) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
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
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _DistortionMap;
			float4 _Color;
			float _DistortionMag;
			float _Speed;

			float4 frag (v2f i) : SV_Target
			{
				float2 offset = tex2D(_DistortionMap, i.uv + _Time.x * _Speed);
				float2 distortedUV = (offset * 2 - 1) * _DistortionMag;

				float4 col = tex2D(_MainTex, i.uv + distortedUV);
				return col;
			}
			ENDCG
		}
	}
}
