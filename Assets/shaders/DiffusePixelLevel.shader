// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Custom/Diffuse Pixel-Level"{
	Properties{
		_Diffuse("Diffuse",Color) = (1,1,1,1)
	}
	SubShader{
		Pass{
			Tags{"LightMode"="ForwardBase"}//指明该Pass的光照模式
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Diffuse;

			struct a2v{
				float4 vertex:POSITION;
				float3 normal:NORMAL;
			};

			struct v2f{
				float4 pos:SV_POSITION;
				fixed3 worldNormal:TEXCOORD0;
			};

			v2f vert(a2v v){
				v2f o;
				//把顶点从模型空间转换到裁剪空间
				o.pos = UnityObjectToClipPos(v.vertex);
				
				//将法线从模型空间转换到世界空间
				o.worldNormal = mul(v.normal,(float3x3)unity_WorldToObject);

				return o;
			}

			fixed4 frag(v2f i):SV_Target{
				//得到环境光信息
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				//得到世界空间的法线
				fixed3 worldNormal = normalize(i.worldNormal);
				//得到世界空间的光的方向
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

				//计算漫反射信息
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal,worldLightDir));

				fixed3 color = ambient + diffuse;

				return fixed4(color,1.0);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
