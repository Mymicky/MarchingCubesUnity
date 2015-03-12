﻿Shader "Custom/ChunkShader" 
{
	SubShader 
	{
		Pass 
		{
			Cull back

			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma target 5.0
			#pragma vertex vert
			#pragma geometry geo
			#pragma fragment frag
			

			struct Tri
			{
				float3 wsPos1 : POS1;  
				float3 wsNormal1 : NORM1;  
				float3 wsPos2 : POS2;  
				float3 wsNormal2 : NORM2;  
				float3 wsPos3: POS3;  
				float3 wsNormal3 : NORM3; 
			};
			uniform StructuredBuffer<Tri> triangleBuffer;

			struct g2f 
			{
				float4  pos : SV_POSITION;
				float3	normal: NORMAL;
			};

			Tri vert(uint id : SV_VertexID)
			{
				Tri triang = triangleBuffer[id];
				return triang;
			}

			[maxvertexcount (3)]
			void geo(inout TriangleStream<g2f> Stream, point Tri input[1])
			{
				g2f OUT;
				Tri inputTri = input[0];

				OUT.pos = mul(UNITY_MATRIX_VP, float4(inputTri.wsPos1.xyz, 1));
				OUT.normal = inputTri.wsNormal1;
				Stream.Append(OUT);

				OUT.pos = mul(UNITY_MATRIX_VP, float4(inputTri.wsPos2.xyz, 1));
				OUT.normal = inputTri.wsNormal2;
				Stream.Append(OUT);

				OUT.pos = mul(UNITY_MATRIX_VP, float4(inputTri.wsPos3.xyz, 1));
				OUT.normal = inputTri.wsNormal3;
				Stream.Append(OUT);

				Stream.RestartStrip();


			}

			float4 frag(g2f IN) : COLOR
			{
				
				return float4(IN.normal, 1.0f);
			}

			ENDCG

		}
	}
}