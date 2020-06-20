// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "NT/sh_FX_night_fog"
{
	Properties
	{
		
	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
			};

			
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 appendResult77 = (float3(0.0 , 0.0 , 0.0));
				float3 objToWorld75 = mul( unity_ObjectToWorld, float4( v.vertex.xyz, 1 ) ).xyz;
				float3 appendResult72 = (float3(0.0 , ( objToWorld75.y * -1.0 ) , ( objToWorld75.z * -1.0 )));
				float3 objToWorld81 = mul( unity_ObjectToWorld, float4( v.vertex.xyz, 1 ) ).xyz;
				float3 lerpResult78 = lerp( appendResult77 , appendResult72 , pow( saturate( ( abs( ( objToWorld81.x - _WorldSpaceCameraPos.x ) ) * 0.008 ) ) , 2.0 ));
				float3 worldToObjDir73 = mul( unity_WorldToObject, float4( lerpResult78, 0 ) ).xyz;
				
				o.ase_texcoord = v.vertex;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = worldToObjDir73;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				float4 color15 = IsGammaSpace() ? float4(0.09411766,0.1254902,0.1607843,1) : float4(0.009134057,0.01444384,0.02217388,1);
				float3 objToWorld6 = mul( unity_ObjectToWorld, float4( i.ase_texcoord.xyz, 1 ) ).xyz;
				float temp_output_12_0 = saturate( ( distance( objToWorld6 , _WorldSpaceCameraPos ) * 0.015 ) );
				float4 color16 = IsGammaSpace() ? float4(0.1081451,0.1019608,0.1137255,1) : float4(0.0113337,0.01032983,0.01228649,1);
				float3 objToWorld18 = mul( unity_ObjectToWorld, float4( i.ase_texcoord.xyz, 1 ) ).xyz;
				float3 appendResult77 = (float3(0.0 , 0.0 , 0.0));
				float3 objToWorld75 = mul( unity_ObjectToWorld, float4( i.ase_texcoord.xyz, 1 ) ).xyz;
				float3 appendResult72 = (float3(0.0 , ( objToWorld75.y * -1.0 ) , ( objToWorld75.z * -1.0 )));
				float3 objToWorld81 = mul( unity_ObjectToWorld, float4( i.ase_texcoord.xyz, 1 ) ).xyz;
				float3 lerpResult78 = lerp( appendResult77 , appendResult72 , pow( saturate( ( abs( ( objToWorld81.x - _WorldSpaceCameraPos.x ) ) * 0.008 ) ) , 2.0 ));
				float temp_output_20_0 = saturate( ( ( objToWorld18.y + ( lerpResult78.y * 0.5 ) ) * 0.1 ) );
				float4 color21 = IsGammaSpace() ? float4(0.01568628,0.03137255,0.03137255,1) : float4(0.001214108,0.002428216,0.002428216,1);
				
				
				finalColor = ( ( ( ( color15 * temp_output_12_0 ) + ( color16 * ( 1.0 - temp_output_12_0 ) ) ) * temp_output_20_0 ) + ( color21 * ( 1.0 - temp_output_20_0 ) ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=17700
0;808;1273;551;626.5547;-301.631;1;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;80;1024,384;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldSpaceCameraPos;79;1024,576;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;81;1216,384;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;82;1424,384;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;74;1200,176;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;83;1568,384;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;1696,384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.008;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;75;1472,176;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;1752.501,148.942;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;1756.047,253.2051;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;85;1881.2,402.442;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;72;1903.613,180.2737;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;4;-1152,-128;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;77;1917.727,5.989428;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;86;2030.7,406.3421;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;78;2184.067,14.7132;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;5;-832,64;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;6;-832,-128;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;88;-224.2003,530.5884;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DistanceOpNode;8;-512,-128;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-512,64;Inherit;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;False;0;0.015;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;17;-605.4893,263.8769;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-320,-128;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;3.901611,429.3235;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;18;-381.4895,263.8769;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;51;95.29256,297.9766;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;12;-128,-128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;15;-115.4032,-523.0965;Inherit;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;False;0;0.09411766,0.1254902,0.1607843,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;16;-115.3584,-310.7668;Inherit;False;Constant;_Color1;Color 1;0;0;Create;True;0;0;False;0;0.1081451,0.1019608,0.1137255,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;13;64,-128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;259.2979,294.2504;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;288,-512;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;20;422.9163,273.3851;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;288,-384;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;21;91.20177,26.90164;Inherit;False;Constant;_Color2;Color 2;0;0;Create;True;0;0;False;0;0.01568628,0.03137255,0.03137255,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;26;668.7659,256.6477;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;512,-512;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;771.0558,-465.021;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;765.2907,-17.2616;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;1024,-256;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TransformDirectionNode;73;2430.191,0.3308365;Inherit;False;World;Object;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;54;940.1899,61.71404;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;2685.319,-104.207;Float;False;True;-1;2;ASEMaterialInspector;100;1;NT/sh_FX_night_fog;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;0
WireConnection;81;0;80;0
WireConnection;82;0;81;1
WireConnection;82;1;79;1
WireConnection;83;0;82;0
WireConnection;84;0;83;0
WireConnection;75;0;74;0
WireConnection;87;0;75;2
WireConnection;76;0;75;3
WireConnection;85;0;84;0
WireConnection;72;1;87;0
WireConnection;72;2;76;0
WireConnection;86;0;85;0
WireConnection;78;0;77;0
WireConnection;78;1;72;0
WireConnection;78;2;86;0
WireConnection;6;0;4;0
WireConnection;88;0;78;0
WireConnection;8;0;6;0
WireConnection;8;1;5;0
WireConnection;9;0;8;0
WireConnection;9;1;10;0
WireConnection;89;0;88;1
WireConnection;18;0;17;0
WireConnection;51;0;18;2
WireConnection;51;1;89;0
WireConnection;12;0;9;0
WireConnection;13;0;12;0
WireConnection;22;0;51;0
WireConnection;23;0;15;0
WireConnection;23;1;12;0
WireConnection;20;0;22;0
WireConnection;24;0;16;0
WireConnection;24;1;13;0
WireConnection;26;0;20;0
WireConnection;25;0;23;0
WireConnection;25;1;24;0
WireConnection;28;0;25;0
WireConnection;28;1;20;0
WireConnection;29;0;21;0
WireConnection;29;1;26;0
WireConnection;27;0;28;0
WireConnection;27;1;29;0
WireConnection;73;0;78;0
WireConnection;2;0;27;0
WireConnection;2;1;73;0
ASEEND*/
//CHKSM=78DD388700ACBD051F6E99DBFB018CDCECD6F5CB