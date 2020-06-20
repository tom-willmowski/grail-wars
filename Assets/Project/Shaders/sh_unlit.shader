// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "NT/sh_unlit"
{
	Properties
	{
		_MainTex("_MainTex", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float4 _FogColorFar;
		uniform float _FogDistance;
		uniform float4 _FogColorNear;
		uniform float4 _Tint;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 objToWorld25_g10 = mul( unity_ObjectToWorld, float4( ase_vertex3Pos, 1 ) ).xyz;
			float temp_output_17_0_g10 = saturate( ( distance( _WorldSpaceCameraPos , objToWorld25_g10 ) / _FogDistance ) );
			float temp_output_20_0_g10 = ( 1.0 - temp_output_17_0_g10 );
			float3 appendResult18_g10 = (float3(( ( _FogColorFar * temp_output_17_0_g10 ) + ( _FogColorNear * temp_output_20_0_g10 ) ).rgb));
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 temp_output_1_0_g10 = float4( (( _Tint * tex2D( _MainTex, uv_MainTex ) )).rgb , 0.0 );
			float3 appendResult8_g10 = (float3(temp_output_1_0_g10.rgb));
			float4 appendResult4_g10 = (float4(( ( appendResult18_g10 * temp_output_17_0_g10 ) + ( appendResult8_g10 * temp_output_20_0_g10 ) ) , (temp_output_1_0_g10).a));
			o.Emission = appendResult4_g10.xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
546;533;1231;788;1063.813;126.9786;1.193516;True;False
Node;AmplifyShaderEditor.SamplerNode;1;-896,0;Inherit;True;Property;_MainTex;_MainTex;0;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;5;-832.6413,-300.2435;Inherit;False;Property;_Tint;Tint;1;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-560,-128;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;3;-384,0;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;28;-512,-384;Inherit;False;Global;_FogColorNear;_FogColorNear;2;0;Create;True;0;0;False;0;0,0,0,0;0.7456216,0.9622642,0.2224101,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;29;-512,-640;Inherit;False;Global;_FogColorFar;_FogColorFar;2;0;Create;True;0;0;False;0;0,0,0,0;0.7939687,0.07058823,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;-510.0212,490.0692;Inherit;False;Global;_FogDistance;_FogDistance;3;0;Create;True;0;0;False;0;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;27;-128,0;Inherit;False;sf_fog;-1;;10;e7f16fc615c0e054eabfa36071b82153;0;4;31;COLOR;0.03921569,0.2745098,0.2078431,0;False;32;COLOR;0.4156863,0.2078431,0.09411765,0;False;1;COLOR;0,0,0,0;False;16;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;4;256,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;NT/sh_unlit;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;5;0
WireConnection;6;1;1;0
WireConnection;3;0;6;0
WireConnection;27;31;29;0
WireConnection;27;32;28;0
WireConnection;27;1;3;0
WireConnection;27;16;30;0
WireConnection;4;2;27;0
ASEEND*/
//CHKSM=F45C992EB00E9109A70E0B43C7E64D57C3E28178