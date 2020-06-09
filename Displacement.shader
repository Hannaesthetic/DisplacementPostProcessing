Shader "Postprocessing/Displacement"
{
	Properties
	{
		_MainTex("Camera Texture", 2D) = "white" {}
		_DisplacementTex("Displacement Texture", 2D) = "gray" {}
		_MaxXDisplacement("Max X Displacement", Range(0,1)) = 0.1
		_MaxYDisplacement("Max Y Displacement", Range(0,1)) = 0.1
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
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

				sampler2D _MainTex;
				float4 _MainTex_ST;
				sampler2D _DisplacementTex;
				float _MaxXDisplacement;
				float _MaxYDisplacement;

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					fixed2 displacement = tex2D(_DisplacementTex, i.uv).rg;
					displacement = (displacement - 0.5) * 2 * float2(_MaxXDisplacement, _MaxYDisplacement);
					fixed4 col = tex2D(_MainTex, i.uv + displacement);
					return col;
				}
				ENDCG
			}
		}
}
