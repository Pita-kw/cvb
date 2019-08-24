
COLOUR = {
	["WHITE"] = tocolor( 255, 255, 255 ),
	["BLACK"] = tocolor( 0,0,0 ),
	["RED"] = tocolor( 255, 0, 0 ),
	["GREEN"] = tocolor( 0, 255, 0 ),
	["BLUE"] = tocolor( 0, 0, 255 ),
	["YELLOW"] = tocolor( 255,255,0 ),
}
COLOUR.__index = COLOUR;

function COLOUR: new( r, g, b, a )
	local color = {
		r = r and r or 255,
		g = g and g or 255,
		b = b and b or 255,
		a = a and a or 255,
	}
	setmetatable( color, self );
	return color;
end

function COLOUR: tocolor( )
	return tocolor( self.r, self.g, self.b, self.a );
end

function COLOUR.Gradient( colorFrom, colorTo, n )
	local r = colorFrom.r - ( colorFrom.r - colorTo.r ) * n;
	local g = colorFrom.g - ( colorFrom.g - colorTo.g ) * n;
	local b = colorFrom.b - ( colorFrom.b - colorTo.b ) * n;
	local a = colorFrom.a - ( colorFrom.a - colorTo.a ) * n;
	return COLOUR: new( r, g, b, a );
end


--[[
function dxDrawGradient( x, y, width, height, colorFrom, colorTo, quality, dir )
	quality = quality and quality or 1;
	assert( not ( height == 0 or width == 0 ), "dxDrawGradient - width nor height can be 0" )
	local step = ( width / ( width * quality / 5 ) );
	if dir == "vertical" then
		step = ( height / ( height * quality / 5 ) );
	end
	for i = 0, dir == "vertical" and height or width, step do
		if dir == "vertical" then
			dxDrawRectangle( x, y+i, width, step, COLOUR.Gradient( colorFrom, colorTo, i/height): tocolor() );
		else
			dxDrawRectangle( x+i, y, step, height, COLOUR.Gradient( colorFrom, colorTo, i/width): tocolor() );
		end
	end
	dxDrawText( tostring( dir == "vertical" and height/steps or width/steps ), 0, 300 );
end
--]]

local function calculateGradient( fromR, fromG, fromB, fromA, toR, toG, toB, toA, n )
	local r = fromR - ( fromR - toR ) * n;
	local g = fromG - ( fromG - toG ) * n;
	local b = fromB - ( fromB - toB ) * n;
	local a = fromA - ( fromA - toA ) * n;
	return r, g, b, a;
end

function dxDrawGradient( x, y, width, height, fromR, fromG, fromB, fromA, toR, toG, toB, toA, quality, dir )
	quality = quality and quality or 1;
	assert( not ( height == 0 or width == 0 or quality == 0), "dxDrawGradient - width, height and quality cannot be 0" )
	local step;
	if dir == "vertical" then
		step = height / ( height * (1.01-quality) );
		step = height/step;
	else
		step = ( width / ( width * quality / 5 ) );
	end
	local lines =0;
	for i = 0, dir == "vertical" and height or width, step do
		lines = lines + 1;
		if dir == "vertical" then
			dxDrawRectangle( x, y+i, width, step, tocolor( calculateGradient( fromR, fromG, fromB, fromA, toR, toG, toB, toA, i/height) ) );
		else
			dxDrawRectangle( x+i, y, step, height, tocolor( calculateGradient( fromR, fromG, fromB, fromA, toR, toG, toB, toA, i/width) ) );
		end
	end
	--[[
	dxDrawText( tostring( dir == "vertical" and height/step or width/step ), 0, 300 );
	dxDrawText( "Step: " .. tostring( step ), 0, 320 );
	dxDrawText( "Lines: " .. tostring( lines ), 0, 340 );
	]]
end

