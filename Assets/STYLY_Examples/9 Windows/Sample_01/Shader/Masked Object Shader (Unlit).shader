Shader "MaskedObject" 
{

Properties 
{
    _Mask("Mask", Int) = 1
    _MainTex ("Base (RGB)", 2D) = "white" {}

}

SubShader 
{

Tags 
{ 
    "RenderType" = "Opaque" 
}

LOD 100

Stencil 
{
    Ref [_Mask]
    Comp Equal
}

Pass{
	Lighting Off
	SetTexture[_MainTex]{ combine texture }
}
}
}