// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "NT/sh_vertex_color"
{
	Properties
	{
		_MainTex1("MainTex", 2D) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		Cull Off
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
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				float4 ase_texcoord1 : TEXCOORD1;
			};

			uniform float4 _FogColorFar;
			uniform float _FogDistance;
			uniform float4 _FogColorNear;
			uniform sampler2D _MainTex1;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord = v.vertex;
				o.ase_color = v.color;
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
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
				float3 objToWorld25_g10 = mul( unity_ObjectToWorld, float4( i.ase_texcoord.xyz, 1 ) ).xyz;
				float temp_output_17_0_g10 = saturate( ( distance( _WorldSpaceCameraPos , objToWorld25_g10 ) / _FogDistance ) );
				float temp_output_20_0_g10 = ( 1.0 - temp_output_17_0_g10 );
				float3 appendResult18_g10 = (float3(( ( _FogColorFar * temp_output_17_0_g10 ) + ( _FogColorNear * temp_output_20_0_g10 ) ).rgb));
				float3 gammaToLinear77 = GammaToLinearSpace( i.ase_color.rgb );
				float2 uv076 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float4 temp_output_1_0_g10 = float4( ( ( gammaToLinear77 * ( ( i.ase_color.r + i.ase_color.g + i.ase_color.b ) * 0.3 ) ) * tex2D( _MainTex1, uv076 ).r ) , 0.0 );
				float3 appendResult8_g10 = (float3(temp_output_1_0_g10.rgb));
				float4 appendResult4_g10 = (float4(( ( appendResult18_g10 * temp_output_17_0_g10 ) + ( appendResult8_g10 * temp_output_20_0_g10 ) ) , (temp_output_1_0_g10).a));
				
				
				finalColor = appendResult4_g10;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=17700
546;533;1231;788;-376.7395;155.4341;1;True;False
Node;AmplifyShaderEditor.VertexColorNode;72;186.9761,-140.4563;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;79;445.3646,-114.1819;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;75;-299.5525,198.635;Inherit;True;Property;_MainTex1;MainTex;0;0;Create;False;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;76;-459.2134,-467.4596;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GammaToLinearNode;77;417.2432,-262.0979;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;597.3646,-109.1819;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;74;164.4476,38.63499;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;764.3646,-199.1819;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;896,-128;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;84;896,-512;Inherit;False;Global;_FogColorNear;_FogColorNear;2;0;Create;True;0;0;False;0;0,0,0,0;0.7456216,0.9622642,0.2224101,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;85;896,-768;Inherit;False;Global;_FogColorFar;_FogColorFar;2;0;Create;True;0;0;False;0;0,0,0,0;0.7939687,0.07058823,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;86;917.7395,135.5659;Inherit;False;Global;_FogDistance;_FogDistance;3;0;Create;True;0;0;False;0;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;83;1280,-128;Inherit;False;sf_fog;-1;;10;e7f16fc615c0e054eabfa36071b82153;0;4;31;COLOR;0.03921569,0.2745098,0.2078431,0;False;32;COLOR;0.4156863,0.2078431,0.09411765,0;False;1;COLOR;0,0,0,0;False;16;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;22;1664,-128;Float;False;True;-1;2;ASEMaterialInspector;100;1;NT/sh_vertex_color;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;2;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;0
WireConnection;79;0;72;1
WireConnection;79;1;72;2
WireConnection;79;2;72;3
WireConnection;77;0;72;0
WireConnection;80;0;79;0
WireConnection;74;0;75;0
WireConnection;74;1;76;0
WireConnection;81;0;77;0
WireConnection;81;1;80;0
WireConnection;73;0;81;0
WireConnection;73;1;74;1
WireConnection;83;31;85;0
WireConnection;83;32;84;0
WireConnection;83;1;73;0
WireConnection;83;16;86;0
WireConnection;22;0;83;0
ASEEND*/
//CHKSM=B450249FADFCB0C7313FCBB3728FAC2E9FA176CC