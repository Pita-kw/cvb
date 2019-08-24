//------------------------------------------------------------------------------------------
// Include some common stuff
//------------------------------------------------------------------------------------------
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
    return float4(PS.Diffuse.rgb, 0);
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
		SrcBlend = SRCALPHA;
		DestBlend = INVSRCALPHA;
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
