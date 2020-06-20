// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "NT/sh_window_rain"
{
	Properties
	{
		_MainTex("_MainTex", 2D) = "white" {}
		_Texture0("Texture 0", 2D) = "white" {}
		_Intensity("Intensity", Range( 0 , 1)) = 0
		_Speed("Speed", Range( -1 , 1)) = 0
		_FakeExtrior("FakeExtrior", 2D) = "white" {}
		_RainColor("RainColor", Color) = (1,1,1,1)
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
				float4 ase_texcoord2 : TEXCOORD2;
			};

			uniform float4 _FogColorFar;
			uniform float _FogDistance;
			uniform float4 _FogColorNear;
			uniform float4 _RainColor;
			uniform sampler2D _FakeExtrior;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _Texture0;
			uniform float _Speed;
			uniform float _Intensity;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.ase_texcoord1.xyz = ase_worldPos;
				
				o.ase_texcoord = v.vertex;
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
				o.ase_texcoord2.zw = 0;
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
				float3 ase_worldPos = i.ase_texcoord1.xyz;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float2 uv_MainTex = i.ase_texcoord2.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
				float2 appendResult85 = (float2(( ( ( ( ase_worldPos.y + -1.45 ) * _Speed ) + ase_worldPos.x ) * 3.0 ) , ( ase_worldPos.y * 3.0 )));
				float2 panner76 = ( 1.0 * _Time.y * float2( 0,0.4 ) + appendResult85);
				float2 panner100 = ( 1.0 * _Time.y * float2( 0,0.03 ) + appendResult85);
				float temp_output_99_0 = ( tex2D( _Texture0, ( panner100 * 0.3 ) ).a * 0.3 * ( ( abs( _Speed ) + 0.4 ) * 0.8 ) );
				float2 panner80 = ( 1.0 * _Time.y * float2( 0,0.6 ) + ( appendResult85 * 1.13 ));
				float4 tex2DNode86 = tex2D( _Texture0, appendResult85 );
				float temp_output_81_0 = ( tex2DNode1.r + ( tex2D( _Texture0, ( panner76 + temp_output_99_0 ) ).b + ( tex2D( _Texture0, ( panner80 + temp_output_99_0 ) ).b * _Intensity ) ) + ( tex2DNode86.r * frac( ( _Time.y + tex2DNode86.g ) ) ) );
				float temp_output_122_0 = ( temp_output_81_0 * 0.1 );
				float4 appendResult72 = (float4(( (tex2DNode1).rgb * 0.2 ) , ( tex2DNode1.r + temp_output_81_0 )));
				float4 temp_output_1_0_g10 = ( _RainColor * ( float4( ( (tex2D( _FakeExtrior, ( ase_worldViewDir + temp_output_122_0 ).xy )).rgb * temp_output_81_0 ) , 0.0 ) + appendResult72 + temp_output_122_0 ) );
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
784;364;911;788;-1133.685;654.7299;1.644042;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;84;-3248,304;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;110;-3249.431,534.7386;Inherit;False;Constant;_Float5;Float 5;4;0;Create;True;0;0;False;0;-1.45;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;109;-3023.231,476.2386;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-3188.331,771.3385;Inherit;False;Property;_Speed;Speed;3;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-2902.331,629.6384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;-2903.629,295.5384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-3076.587,132.2054;Inherit;False;Constant;_Float2;Float 2;2;0;Create;True;0;0;False;0;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-2688,384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-2688,256;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;85;-2496,256;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;111;-1969.37,187.2055;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;100;-2304,240;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.03;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-2252.382,39.94775;Inherit;False;Constant;_Float3;Float 3;2;0;Create;True;0;0;False;0;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-2485.934,774.4302;Inherit;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;False;0;1.13;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-2087.141,5.522522;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;75;-2304,-256;Inherit;True;Property;_Texture0;Texture 0;1;0;Create;True;0;0;False;0;d3b03afcb40a09d43b8b00af8659f752;d3b03afcb40a09d43b8b00af8659f752;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;112;-1814.08,173.751;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-1669.555,154.5666;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;97;-1984,-240;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;-1;d3b03afcb40a09d43b8b00af8659f752;d3b03afcb40a09d43b8b00af8659f752;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-2277.341,670.1334;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;80;-2000,784;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.6;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-1627.876,-28.74197;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0.3;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;87;-1536,1280;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;101;-1616,800;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;76;-2000.99,526.5631;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.4;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;86;-1536,1024;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;-1;d3b03afcb40a09d43b8b00af8659f752;d3b03afcb40a09d43b8b00af8659f752;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;105;-1199.886,981.9858;Inherit;False;Property;_Intensity;Intensity;2;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;-1152,1280;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;78;-1360,768;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;False;0;-1;d3b03afcb40a09d43b8b00af8659f752;d3b03afcb40a09d43b8b00af8659f752;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;98;-1616,528;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FractNode;89;-888.006,1285.002;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;73;-1360,528;Inherit;True;Property;_t_fx_raindrops_2;t_fx_raindrops_2;1;0;Create;True;0;0;False;0;-1;d3b03afcb40a09d43b8b00af8659f752;d3b03afcb40a09d43b8b00af8659f752;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-863,784;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;-736,624;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-402.934,998.5168;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1168,0;Inherit;True;Property;_MainTex;_MainTex;0;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;81;-136.8226,704.6163;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;130;-788.2139,-655.6729;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;27.47955,689.4651;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;129;-508.295,-922.496;Inherit;True;Property;_FakeExtrior;FakeExtrior;4;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;120;-167.6688,-428.3796;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-768,-256;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;5;-832,-64;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;128;-35.21546,-658.9459;Inherit;True;Property;_TextureSample3;Texture Sample 3;4;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-558.386,-80;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;126;-560.7487,56.87866;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;125;454.568,-448.3209;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;864.3658,-428.3234;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;72;-296.9775,-71.97905;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;131;17.87366,-919.676;Inherit;False;Property;_RainColor;RainColor;5;0;Create;True;0;0;False;0;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;123;1212.924,-72.92635;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;136;1536,-896;Inherit;False;Global;_FogColorFar;_FogColorFar;2;0;Create;True;0;0;False;0;0,0,0,0;0.2909472,0.3294118,0.1647059,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;133;1552,144;Inherit;False;Global;_FogDistance;_FogDistance;3;0;Create;True;0;0;False;0;20;25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;135;1536,-640;Inherit;False;Global;_FogColorNear;_FogColorNear;2;0;Create;True;0;0;False;0;0,0,0,0;0.2830189,0.1387837,0.06274475,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;1536,-256;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;119;-471.9624,-506.9015;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;134;1920,-256;Inherit;False;sf_fog;-1;;10;e7f16fc615c0e054eabfa36071b82153;0;4;31;COLOR;0.03921569,0.2745098,0.2078431,0;False;32;COLOR;0.4156863,0.2078431,0.09411765,0;False;1;COLOR;0,0,0,0;False;16;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;2320,-256;Float;False;True;-1;2;ASEMaterialInspector;100;1;NT/sh_window_rain;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;2;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Opaque=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;0
WireConnection;109;0;84;2
WireConnection;109;1;110;0
WireConnection;107;0;109;0
WireConnection;107;1;108;0
WireConnection;106;0;107;0
WireConnection;106;1;84;1
WireConnection;93;0;84;2
WireConnection;93;1;95;0
WireConnection;92;0;106;0
WireConnection;92;1;95;0
WireConnection;85;0;92;0
WireConnection;85;1;93;0
WireConnection;111;0;108;0
WireConnection;100;0;85;0
WireConnection;103;0;100;0
WireConnection;103;1;104;0
WireConnection;112;0;111;0
WireConnection;127;0;112;0
WireConnection;97;0;75;0
WireConnection;97;1;103;0
WireConnection;82;0;85;0
WireConnection;82;1;83;0
WireConnection;80;0;82;0
WireConnection;99;0;97;4
WireConnection;99;2;127;0
WireConnection;101;0;80;0
WireConnection;101;1;99;0
WireConnection;76;0;85;0
WireConnection;86;0;75;0
WireConnection;86;1;85;0
WireConnection;88;0;87;0
WireConnection;88;1;86;2
WireConnection;78;0;75;0
WireConnection;78;1;101;0
WireConnection;98;0;76;0
WireConnection;98;1;99;0
WireConnection;89;0;88;0
WireConnection;73;0;75;0
WireConnection;73;1;98;0
WireConnection;102;0;78;3
WireConnection;102;1;105;0
WireConnection;96;0;73;3
WireConnection;96;1;102;0
WireConnection;90;0;86;1
WireConnection;90;1;89;0
WireConnection;81;0;1;1
WireConnection;81;1;96;0
WireConnection;81;2;90;0
WireConnection;122;0;81;0
WireConnection;120;0;130;0
WireConnection;120;1;122;0
WireConnection;5;0;1;0
WireConnection;128;0;129;0
WireConnection;128;1;120;0
WireConnection;6;0;5;0
WireConnection;6;1;7;0
WireConnection;126;0;1;1
WireConnection;126;1;81;0
WireConnection;125;0;128;0
WireConnection;124;0;125;0
WireConnection;124;1;81;0
WireConnection;72;0;6;0
WireConnection;72;3;126;0
WireConnection;123;0;124;0
WireConnection;123;1;72;0
WireConnection;123;2;122;0
WireConnection;132;0;131;0
WireConnection;132;1;123;0
WireConnection;134;31;136;0
WireConnection;134;32;135;0
WireConnection;134;1;132;0
WireConnection;134;16;133;0
WireConnection;2;0;134;0
ASEEND*/
//CHKSM=87C16A046BFADC0CFC44353DAC574E1DDC79E61A