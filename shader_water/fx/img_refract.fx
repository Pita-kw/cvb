//
// file: img_refract.fx
// author: Ren712
//

//--------------------------------------------------------------------------------------
// Variables
//--------------------------------------------------------------------------------------
float gAlpha = 1;
float2 fUVMove = float2(0, 0);
float2 fUVResize = float2(1, 1);
float gNormalStrength = 0.05;
float sSkyBrightness = 0.3;
float4 sWaterColor = float4(90 / 255.0, 170 / 255.0, 170 / 255.0, 240 / 255.0 );

//--------------------------------------------------------------------------------------
// Include some common stuff
//--------------------------------------------------------------------------------------
float4x4 gWorld : WORLD;
float4x4 gView : VIEW;
float4x4 gProjection : PROJECTION;
matrix gProjectionMainScene : PROJECTION_MAIN_SCENE;
float4x4 gViewProjection : VIEWPROJECTION;
float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float4x4 gViewInverse : VIEWINVERSE;
float3 gCameraDirection : CAMERADIRECTION;
texture gDepthBuffer : DEPTHBUFFER;
float4 gFogColor < string renderState="FOGCOLOR"; >;
texture gTexture0 < string textureState="0,Texture"; >;
int CUSTOMFLAGS <string skipUnusedParameters = "yes"; >;
float gTime : TIME;

//--------------------------------------------------------------------------------------
// Textures
//--------------------------------------------------------------------------------------
texture sNormalTexture;
texture sDepthTexture;
texture sColorTexture;

//--------------------------------------------------------------------------------------
// Sampler Inputs
//--------------------------------------------------------------------------------------
sampler2D ColorSampler = sampler_state
{
    Texture = (sColorTexture);
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Mirror;
    AddressV = Mirror;
};

sampler2D NormalSampler = sampler_state
{
    Texture = (sNormalTexture);
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Point;
    AddressU = Mirror;
    AddressV = Mirror;
};

sampler2D SamplerDepthTex = sampler_state
{
    Texture = (sDepthTexture);
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
    MaxMipLevel = 0;
    MipMapLodBias = 0;
};

sampler2D SamplerDepth = sampler_state
{
    Texture = (gDepthBuffer);
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
    MaxMipLevel = 0;
    MipMapLodBias = 0;
};

//--------------------------------------------------------------------------------------
// Structures
//--------------------------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;	
};

//------------------------------------------------------------------------------------------
//-- Get value from the depth buffer
//-- Uses define set at compile time to handle RAWZ special case (which will use up a few more slots)
//------------------------------------------------------------------------------------------
float FetchDepthBufferValue( float2 uv )
{
    float4 texel = tex2D(SamplerDepth, uv);
#if IS_DEPTHBUFFER_RAWZ
    float3 rawval = floor(255.0 * texel.arg + 0.5);
    float3 valueScaler = float3(0.996093809371817670572857294849, 0.0038909914428586627756752238080039, 1.5199185323666651467481343000015e-5);
    return dot(rawval, valueScaler / 255.0);
#else
    return texel.r;
#endif
}
 
//------------------------------------------------------------------------------------------
//-- Use the last scene projecion matrix to linearize the depth value a bit more [world units]
//------------------------------------------------------------------------------------------
float Linearize(float posZ)
{
    return gProjectionMainScene[3][2] / (posZ - gProjectionMainScene[2][2]);
}

//------------------------------------------------------------------------------------------
//-- Use the last scene projecion matrix to linearize the depth value [0 - 1]
//------------------------------------------------------------------------------------------
float DepthToUnit(float posZ)
{			
	return ((gProjectionMainScene[2][2] - 1) * posZ ) / (gProjectionMainScene[2][2] - posZ);
}

//------------------------------------------------------------------------------------------
// Pack Unit Float [0,1] into RGB24
//------------------------------------------------------------------------------------------
float3 UnitToColor24New(in float depth) 
{
    // Constants
    const float3 scale	= float3(1.0, 256.0, 65536.0);
    const float2 ogb	= float2(65536.0, 256.0) / 16777215.0;
    const float normal	= 256.0 / 255.0;
	
    // Avoid Precision Errors
    float3 unit	= (float3)depth;
    unit.gb	-= floor(unit.gb / ogb) * ogb;
	
    // Scale Up
    float3 color = unit * scale;
	
    // Use Fraction to emulate Modulo
    color = frac(color);
	
    // Normalize Range
    color *= normal;
	
    // Mask Noise
    color.rg -= color.gb / 256.0;

    return color;
}

//------------------------------------------------------------------------------------------
// Unpack RGB24 into Unit Float [0,1]
//------------------------------------------------------------------------------------------
float ColorToUnit24New(in float3 color) {
    const float3 scale = float3(65536.0, 256.0, 1.0) / 65793.0;
    return dot(color, scale);
}

//------------------------------------------------------------------------------------------
// Pack Unil float [nearClip,farClip] Unit Float [0,1]
//------------------------------------------------------------------------------------------
float DistToUnit(in float dist, in float nearClip, in float farClip) 
{
    float unit = (dist - nearClip) / (farClip - nearClip);
    return unit;
}

//------------------------------------------------------------------------------------------
// Pack Unit Float [0,1] to Unil float [nearClip,farClip]
//------------------------------------------------------------------------------------------
float UnitToDist(in float unit, in float nearClip, in float farClip) 
{
    float dist = (dist * (farClip - nearClip)) + nearClip;
    return dist;
}

//-----------------------------------------------------------------------------
// Pixel shaders 
//-----------------------------------------------------------------------------
float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    // Get depth buffer value (rest of the world)
    float bufferValue = FetchDepthBufferValue(PS.TexCoord.xy);
    float depth1 = DepthToUnit(bufferValue);

    // Get packed depth texture
    float3 packedDepth = tex2D(SamplerDepthTex, PS.TexCoord.xy).rgb;
	
    // Unpack depth texture (the chosen faces)
    float depth2 = ColorToUnit24New(packedDepth);
	
    // Get Screen space normals
    float4 normalInput = tex2D(NormalSampler,PS.TexCoord.xy);
	float blurFactor = (((normalInput.x + normalInput.y)/2) - 0.5);
    float2 vFlakesNormal = 2 * normalInput.rg - 1.0;	

    // Convert regular water color to what we want
    float4 waterColorBase = float4(90 / 255.0, 170 / 255.0, 170 / 255.0, 240 / 255.0 );
    float4 conv           = float4(30 / 255.0,  58 / 255.0,  58 / 255.0, 200 / 255.0 );
    float4 Diffuse = saturate( sWaterColor * conv / waterColorBase );

    // UV scale and resize
    PS.TexCoord.xy += fUVMove;
    PS.TexCoord.xy *= fUVResize;
	
    // Get screen for refraction effect
    float4 refraction = tex2D(ColorSampler, PS.TexCoord.xy + vFlakesNormal * gNormalStrength);
	
    // Combine
    float4 finalColor = 1;
    finalColor.rgb = saturate(Diffuse.rgb);
    finalColor.rgb += refraction.rgb * Diffuse.rgb * 0.25;
    finalColor.rgb += blurFactor * gFogColor * saturate(0.25 + Diffuse.a) * sSkyBrightness;
    finalColor.rgb = lerp(refraction.rgb, finalColor.rgb, normalInput.b );
    finalColor.rgb = lerp(finalColor.rgb, refraction.rgb, 1 - Diffuse.a);
	
	if ((depth2 > depth1) || (normalInput.a == 0)) finalColor.a = 0;

    return saturate(finalColor);
}

//-----------------------------------------------------------------------------
// Techniques
//-----------------------------------------------------------------------------
technique dxDrawImage
{
  pass P0
  {
    AlphaRef = 1;
    AlphaBlendEnable = true;
    FogEnable = false;
    PixelShader  = compile ps_2_0 PixelShaderFunction();
  }
} 
	