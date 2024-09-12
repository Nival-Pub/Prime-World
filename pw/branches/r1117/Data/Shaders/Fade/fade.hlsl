uniform float			alphaMul				: register(c0);

struct VS_INPUT
{
		float2 Position				 : POSITION;
		float2 Texcoord				 : TEXCOORD0;
};			

struct VS_OUTPUT
{
		float4 Position				 : POSITION;	 // vertex position
		float2 Texcoord				 : TEXCOORD0;	// vertex diffuse texcoords
};


VS_OUTPUT VS_main(VS_INPUT Input)
{
		VS_OUTPUT Output;
		Output.Position = float4(Input.Position.x,Input.Position.y, 0.f, 1.f); 
		Output.Position -= float4( 1.f/1024.f, 1.f/768.f, 0, 0);
		Output.Texcoord = Input.Texcoord;
		//Output.Vertexcolor = Input.Vertexcolor;
		return Output;
}

sampler DiffuseMap : register(s0);


float4 PS_main(VS_OUTPUT Input) : COLOR
{
	float4 diffuse = tex2D(DiffuseMap, Input.Texcoord);
	diffuse.a = alphaMul; 
//	diffuse = max(0, diffuse);
//	diffuse.rgb /= (diffuse + 8.f);

	return diffuse; 
}
