float3 colorMultiplier = float3(0.55, 0.55, 0.55);

//------------------------------------------------------------------------------------------
// Include some common stuff
//------------------------------------------------------------------------------------------
int gCapsMaxAnisotropy < string deviceCaps="MaxAnisotropy"; >;
texture gTexture0 < string textureState="0,Texture"; >;


//------------------------------------------------------------------------------------------
// Sampler for the main texture
//------------------------------------------------------------------------------------------
sampler Sampler0 = sampler_state
{
    Texture = (gTexture0);
};

//------------------------------------------------------------------------------------------
// Structure of data sent to the pixel shader ( from the vertex shader )
//------------------------------------------------------------------------------------------
struct PSInput
{
  float4 Position : POSITION0;
  float4 Diffuse : COLOR0;
  float2 TexCoord0 : TEXCOORD0;
  float2 TexCoord1 : TEXCOORD1;
};

//------------------------------------------------------------------------------------------
// PixelShaderFunction
//------------------------------------------------------------------------------------------
float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    // Get texture pixel
    float4 texel = tex2D(Sampler0, PS.TexCoord0);
	float4 finalColor = texel;
  
	finalColor.rgb *= colorMultiplier;
	
	// Apply vertex
	finalColor.rgb *= PS.Diffuse.rgb;
	
    return finalColor;
}


//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique lightmap
{
    pass P0
    {
        PixelShader = compile ps_2_0 PixelShaderFunction();
		AlphaBlendEnable = TRUE;
    }
}

// Fallback
technique fallback
{
    pass P0
    {
        // Just draw normally
    }
}
