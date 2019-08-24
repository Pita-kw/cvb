//
// image4D.fx
//

//--------------------------------------------------------------------------------------
// Settings
//--------------------------------------------------------------------------------------
float3 sElementPosition = float3(0,0,0);
float3 sElementRotation = float3(0,0,0);
float2 sScrRes = float2(800,600);
float2 sElementSize = float2(1,1);
float sDistanceBias = 0;
float sDepthMul = 1;
float sImageRoll = 0;
bool sFlipTexture = false;

float3 sCameraPosition = float3(0,0,0);
float3 sPoint1Position = float3(0,0,0);
float3 sPoint2Position = float3(0,0,0);
float4 sColor = float4(1,1,1,1);

bool sZEnable = true;
bool sFogEnable = true;

//--------------------------------------------------------------------------------------
// Textures
//--------------------------------------------------------------------------------------
texture sTexture;

//--------------------------------------------------------------------------------------
// Variables set by MTA
//--------------------------------------------------------------------------------------
float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float4x4 gProjectionMainScene : PROJECTION_MAIN_SCENE;
float4x4 gViewMainScene : VIEW_MAIN_SCENE;
float4 gFogColor < string renderState="FOGCOLOR"; >;
int gCapsMaxAnisotropy < string deviceCaps="MaxAnisotropy"; >;

//--------------------------------------------------------------------------------------
// Sampler 
//--------------------------------------------------------------------------------------
sampler2D Sampler0 = sampler_state
{
    Texture = (sTexture);
    AddressU = Mirror;
    AddressV = Mirror;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
};

//--------------------------------------------------------------------------------------
// Structures
//--------------------------------------------------------------------------------------
struct VSInput
{
    float3 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
    float4 Diffuse : COLOR0;
};

struct PSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
    float4 Diffuse : COLOR0;
};

//-----------------------------------------------------------------------------
// Create world matrix with world position and euler rotation
//-----------------------------------------------------------------------------
float4x4 createWorldMatrix(float3 pos, float3 rot)
{
    float4x4 eleMatrix = {
        float4(cos(rot.z) * cos(rot.y) - sin(rot.z) * sin(rot.x) * sin(rot.y), 
                cos(rot.y) * sin(rot.z) + cos(rot.z) * sin(rot.x) * sin(rot.y), -cos(rot.x) * sin(rot.y), 0),
        float4(-cos(rot.x) * sin(rot.z), cos(rot.z) * cos(rot.x), sin(rot.x), 0),
        float4(cos(rot.z) * sin(rot.y) + cos(rot.y) * sin(rot.z) * sin(rot.x), sin(rot.z) * sin(rot.y) - 
                cos(rot.z) * cos(rot.y) * sin(rot.x), cos(rot.x) * cos(rot.y), 0),
        float4(pos.x,pos.y,pos.z, 1),
    };
	return eleMatrix;
}

//-----------------------------------------------------------------------------
// Returns a rotation matrix
//-----------------------------------------------------------------------------
float3x3 makeRotationMatrix ( float angle )
{
    float s = sin(angle);
    float c = cos(angle);
    return float3x3(
                    c, s, 0,
                    -s, c, 0,
                    0, 0, 1
                    );
}

//-----------------------------------------------------------------------------
// Vertex Shader 
//-----------------------------------------------------------------------------
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
    float3 PositionVS = VS.Position;
	
    VS.Position.xy /= float2(sScrRes.x, sScrRes.y);
    VS.Position.xy = - 0.5 + VS.Position.xy;
    VS.Position.xy = float2(VS.Position.x,-VS.Position.y);
    if ( sFlipTexture ) VS.Position.xy = VS.Position.yx;
    VS.Position.xy *= sElementSize.xy;
	
    float3 point1 = mul(sPoint1Position, (float3x3)gViewMainScene);
    float3 point2 = mul(sPoint2Position, (float3x3)gViewMainScene);
    float rotAngle = atan2(point2.x - point1.x, point2.y - point1.y);
    VS.Position.xyz = mul(VS.Position.xyz, makeRotationMatrix(-rotAngle));
	
    float4x4 sWorld = createWorldMatrix(sElementPosition, sElementRotation);
    float4x4 sWorldView = mul(sWorld, gViewMainScene);
    float3 sBillView = VS.Position.xyz + sWorldView[3].xyz;
    sBillView.z += sDistanceBias;
    float camDist = distance(sCameraPosition, VS.Position.xyz + sWorld[3].xyz);
    PS.Position = mul(float4(sBillView, 1), gProjectionMainScene);
    PS.Position.z *= sDepthMul;
	
    PS.TexCoord = VS.TexCoord.xy;
    PS.Diffuse = VS.Diffuse * sColor;
    PS.Diffuse.a *= saturate(pow(camDist,3));
	
    return PS;
}

//-----------------------------------------------------------------------------
// Pixel shaders 
//-----------------------------------------------------------------------------
float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float4 finalColor = tex2D(Sampler0, PS.TexCoord.xy);
    finalColor *= PS.Diffuse;
    return saturate(finalColor);
}

//-----------------------------------------------------------------------------
// Techniques
//-----------------------------------------------------------------------------
technique dxDrawImage4D
{
  pass P0
  {
    AlphaRef = 1;
    AlphaBlendEnable = true;
    ZEnable = sZEnable;
    ZWriteEnable = true;
    ZFunc = LessEqual;	
    FogEnable = sFogEnable;
    FogColor = float4(saturate(gFogColor.rgb * 1.6), gFogColor.a);
    VertexShader = compile vs_2_0 VertexShaderFunction();
    PixelShader  = compile ps_2_0 PixelShaderFunction();
  }
}
