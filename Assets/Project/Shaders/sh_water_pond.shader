// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "NT/sh_water_pond"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Back
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
				float3 ase_normal : NORMAL;
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
				float4 ase_texcoord3 : TEXCOORD3;
			};

			uniform sampler2D _TextureSample0;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float mulTime4 = _Time.y * -2.0;
				float mulTime14 = _Time.y * -2.0;
				float temp_output_21_0 = ( sin( ( sin( ( ( v.vertex.xyz.z + ( v.vertex.xyz.x * -1.0 ) + mulTime4 ) * 1.0 ) ) + ( v.vertex.xyz.z * 4.0 ) ) ) + cos( ( sin( ( ( v.vertex.xyz.x + v.vertex.xyz.z + mulTime14 ) * 2.0 ) ) + ( v.vertex.xyz.z * 1.3 ) ) ) );
				float3 appendResult5 = (float3(0.0 , ( temp_output_21_0 * 0.01 ) , 0.0));
				
				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.ase_texcoord.xyz = ase_worldPos;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				
				o.ase_texcoord1 = v.vertex;
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = appendResult5;
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
				float3 ase_worldPos = i.ase_texcoord.xyz;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float mulTime4 = _Time.y * -2.0;
				float mulTime14 = _Time.y * -2.0;
				float temp_output_21_0 = ( sin( ( sin( ( ( i.ase_texcoord1.xyz.z + ( i.ase_texcoord1.xyz.x * -1.0 ) + mulTime4 ) * 1.0 ) ) + ( i.ase_texcoord1.xyz.z * 4.0 ) ) ) + cos( ( sin( ( ( i.ase_texcoord1.xyz.x + i.ase_texcoord1.xyz.z + mulTime14 ) * 2.0 ) ) + ( i.ase_texcoord1.xyz.z * 1.3 ) ) ) );
				float3 appendResult5 = (float3(0.0 , ( temp_output_21_0 * 0.01 ) , 0.0));
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float fresnelNdotV81 = dot( ase_worldNormal, ( ase_worldViewDir + ( appendResult5 * -3.0 ) ) );
				float fresnelNode81 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV81, 3.0 ) );
				float2 uv039 = i.ase_texcoord3.xy * float2( 1.1,1.1 ) + float2( -0.05,-0.05 );
				float4 color25 = IsGammaSpace() ? float4(0.1113385,0.1698113,0.1474541,0.6509804) : float4(0.01187344,0.0244657,0.01902733,0.6509804);
				float temp_output_32_0 = (0.4 + (temp_output_21_0 - -1.0) * (0.6 - 0.4) / (1.0 - -1.0));
				float4 color26 = IsGammaSpace() ? float4(0.0745372,0.2202383,0.2358491,0.6509804) : float4(0.006515396,0.03976449,0.04539381,0.6509804);
				float4 appendResult56 = (float4(( ( fresnelNode81 * (tex2D( _TextureSample0, ( ase_worldViewDir + ( appendResult5 * float3( 11,1,1 ) ) ).xy )).rgb ) + ( pow( saturate( ( ( 1.0 - ( abs( ( uv039.x - 0.5 ) ) * 2.0 ) ) * ( 1.0 - ( abs( ( uv039.y - 0.5 ) ) * 2.0 ) ) ) ) , 0.8 ) * (( ( color25 * temp_output_32_0 ) + ( color26 * ( 1.0 - temp_output_32_0 ) ) )).rgb ) ) , pow( fresnelNode81 , 0.03 )));
				
				
				finalColor = appendResult56;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=17700
-1053;158;942;788;822.5328;395.2105;1;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;2;-1817,-4;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-1580.048,7.514114;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;14;-1611.376,604.409;Inherit;False;1;0;FLOAT;-2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;4;-1526.3,260.8294;Inherit;False;1;0;FLOAT;-2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;13;-1664,384;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-1386,16.9;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-1365.545,392.474;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1222.208,2.303467;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-1206.224,388.1534;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1056,512;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;16;-1024,384;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;1;-1024,0;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1051.993,128.0004;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-896,384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-896,0;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-907.5359,-1029.682;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1.1,1.1;False;1;FLOAT2;-0.05,-0.05;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CosOpNode;20;-729.5613,383.6072;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;8;-736,0;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;43;-605.7427,-961.3782;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;40;-606.9977,-1057.003;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-589.2285,-3.979053;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;41;-448,-1056;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;44;-446.7449,-960.3752;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-448,0;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;5;-256,0;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;32;-459.2108,-336.0736;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.4;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-282.516,-1058.014;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-282.5609,-963.6891;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;50;-123.9163,-1054.115;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;67;393.4537,-841.2045;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;412.5397,-651.9296;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;11,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;51;-117.4163,-948.8147;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;220.941,-1284.368;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;-3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;26;-772,-414.6;Inherit;False;Constant;_Color1;Color 1;0;0;Create;True;0;0;False;0;0.0745372,0.2202383,0.2358491,0.6509804;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;25;-772,-670.6;Inherit;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;False;0;0.1113385,0.1698113,0.1474541,0.6509804;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;30;-236.8623,-349.2232;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;623.0104,-826.2876;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;84;400.6758,-1449.089;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;419.7617,-1259.814;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;11;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-53.39673,-432.9639;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;61.9837,-1061.915;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-63.42059,-698.5941;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;630.2324,-1434.172;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;60;272.3945,-1059.185;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;173.6379,-575.9231;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;64;754.9388,-773.033;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;59;438.0267,-1055.188;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;66;1094.286,-774.4594;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FresnelNode;81;1026.154,-1103.084;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;57;319.4226,-416.6596;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;834.2841,-456.8477;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;1306.719,-849.3757;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;1640.601,-479.5313;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;87;1530.413,-267.6817;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0.03;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;56;1793.758,-366.6044;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0.6;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2039.493,-333.7121;Float;False;True;-1;2;ASEMaterialInspector;100;1;NT/sh_water_pond;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;0
WireConnection;63;0;2;1
WireConnection;3;0;2;3
WireConnection;3;1;63;0
WireConnection;3;2;4;0
WireConnection;15;0;13;1
WireConnection;15;1;13;3
WireConnection;15;2;14;0
WireConnection;22;0;3;0
WireConnection;62;0;15;0
WireConnection;17;0;13;3
WireConnection;16;0;62;0
WireConnection;1;0;22;0
WireConnection;12;0;2;3
WireConnection;18;0;16;0
WireConnection;18;1;17;0
WireConnection;7;0;1;0
WireConnection;7;1;12;0
WireConnection;20;0;18;0
WireConnection;8;0;7;0
WireConnection;43;0;39;2
WireConnection;40;0;39;1
WireConnection;21;0;8;0
WireConnection;21;1;20;0
WireConnection;41;0;40;0
WireConnection;44;0;43;0
WireConnection;6;0;21;0
WireConnection;5;1;6;0
WireConnection;32;0;21;0
WireConnection;42;0;41;0
WireConnection;45;0;44;0
WireConnection;50;0;42;0
WireConnection;73;0;5;0
WireConnection;51;0;45;0
WireConnection;30;0;32;0
WireConnection;69;0;67;0
WireConnection;69;1;73;0
WireConnection;83;0;5;0
WireConnection;83;1;86;0
WireConnection;28;0;26;0
WireConnection;28;1;30;0
WireConnection;52;0;50;0
WireConnection;52;1;51;0
WireConnection;27;0;25;0
WireConnection;27;1;32;0
WireConnection;85;0;84;0
WireConnection;85;1;83;0
WireConnection;60;0;52;0
WireConnection;29;0;27;0
WireConnection;29;1;28;0
WireConnection;64;1;69;0
WireConnection;59;0;60;0
WireConnection;66;0;64;0
WireConnection;81;4;85;0
WireConnection;57;0;29;0
WireConnection;61;0;59;0
WireConnection;61;1;57;0
WireConnection;71;0;81;0
WireConnection;71;1;66;0
WireConnection;70;0;71;0
WireConnection;70;1;61;0
WireConnection;87;0;81;0
WireConnection;56;0;70;0
WireConnection;56;3;87;0
WireConnection;0;0;56;0
WireConnection;0;1;5;0
ASEEND*/
//CHKSM=4A5E8E1B9935E2185E9DFAD4EEB3547D822F408A