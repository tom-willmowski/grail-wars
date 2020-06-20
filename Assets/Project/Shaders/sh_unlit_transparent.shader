// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "NT/sh_unlit_transparent"
{
	Properties
	{
		_MainTex("_MainTex", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" "Queue"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off
		ColorMask RGBA
		ZWrite Off
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
				float4 ase_texcoord1 : TEXCOORD1;
			};

			uniform float4 _FogColorFar;
			uniform float _FogDistance;
			uniform float4 _FogColorNear;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord = v.vertex;
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
				float2 uv_MainTex = i.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
				float4 appendResult72 = (float4(( (tex2DNode1).rgb * 0.4 ) , tex2DNode1.r));
				float4 temp_output_1_0_g10 = appendResult72;
				float3 appendResult8_g10 = (float3(temp_output_1_0_g10.rgb));
				float4 appendResult4_g10 = (float4(( ( appendResult18_g10 * temp_output_17_0_g10 ) + ( appendResult8_g10 * temp_output_20_0_g10 ) ) , max( temp_output_17_0_g10 , (temp_output_1_0_g10).a )));
				
				
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
784;364;911;788;312.631;57.65103;1;True;False
Node;AmplifyShaderEditor.SamplerNode;1;-1168,0;Inherit;True;Property;_MainTex;_MainTex;0;0;Create;True;0;0;False;0;-1;None;ad2ef1e28a1b8a24aa29973392567b84;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;5;-832,-64;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-768,-256;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-558.386,-80;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;72;-296.9775,-71.97905;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;76;8.713351,-739.8134;Inherit;False;Global;_FogColorFar;_FogColorFar;2;0;Create;True;0;0;False;0;0,0,0,0;0.2909472,0.3294118,0.1647059,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;75;8.713351,-483.8133;Inherit;False;Global;_FogColorNear;_FogColorNear;2;0;Create;True;0;0;False;0;0,0,0,0;0.2830189,0.1387837,0.06274475,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;77;42.36902,418.349;Inherit;False;Global;_FogDistance;_FogDistance;3;0;Create;True;0;0;False;0;20;25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;74;392.7133,-99.81333;Inherit;False;sf_fog;-1;;10;e7f16fc615c0e054eabfa36071b82153;0;4;31;COLOR;0.03921569,0.2745098,0.2078431,0;False;32;COLOR;0.4156863,0.2078431,0.09411765,0;False;1;COLOR;0,0,0,0;False;16;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;793.9311,-75.84376;Float;False;True;-1;2;ASEMaterialInspector;100;1;NT/sh_unlit_transparent;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;2;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Opaque=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;0
WireConnection;5;0;1;0
WireConnection;6;0;5;0
WireConnection;6;1;7;0
WireConnection;72;0;6;0
WireConnection;72;3;1;1
WireConnection;74;31;76;0
WireConnection;74;32;75;0
WireConnection;74;1;72;0
WireConnection;74;16;77;0
WireConnection;2;0;74;0
ASEEND*/
//CHKSM=62B140DF40EB8CBBC6F74E1A604A9E4EBE9870EB