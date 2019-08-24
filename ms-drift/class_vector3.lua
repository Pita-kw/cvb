

Vector3 = { };
Vector3.__index = Vector3;


function Vector3:new( x, y, z )
	if type( x ) == "string" then
		local temp = string.sub( x, 2, -2 ); -- remove [ and ] from START and END of the string
		temp = split( temp, "," ); -- split by comma
		x = tonumber( temp[ 1 ] );
		y = tonumber( temp[ 2 ] );
		z = tonumber( temp[ 3 ] );
	end
	if ( type( x ) == "number" ) and ( not y ) and ( not z ) then
		x, y, z = x, x, x;
	end
	local vec3 = {
		x = x and x or 0,
		y = y and y or 0,
		z = z and z or 0,
	}
	self.__index = self;
	setmetatable( vec3, self );
	return vec3;
end

function Vector3: up( )
	return Vector3: new( 0, 0, 1 );
end

function Vector3: down( )
	return Vector3: new( 0, 0, -1 );
end

function Vector3: right( )
	return Vector3: new( 1, 0, 0 );
end

function Vector3: left( )
	return Vector3: new( -1, 0, 0 );
end

function Vector3: forward( )
	return Vector3: new( 0, 1, 0 );
end

function Vector3: backward( )
	return Vector3: new( 0, -1, 0 );
end

function Vector3: elementOffsetPosition( eElem, vOffset )
	if eElem then
		vOffset = vOffset and vOffset or Vector3: zero( );
		local m = getElementMatrix ( eElem )
		local x = vOffset.x * m[1][1] + vOffset.y * m[2][1] + vOffset.z * m[3][1] + m[4][1];
		local y = vOffset.x * m[1][2] + vOffset.y * m[2][2] + vOffset.z * m[3][2] + m[4][2];
		local z = vOffset.x * m[1][3] + vOffset.y * m[2][3] + vOffset.z * m[3][3] + m[4][3];
		return Vector3: new( x, y, z );
	end
end


-- returns x, y and z respectively
function Vector3: explode( )
	return self.x, self.y, self.z;
end


function Vector3: zero( )
	return Vector3:new( 0 );
end


function Vector3: one( )
	return Vector3:new( 1 );
end


function Vector3: add( vec3 )
	if type( vec3 ) == "table" then
		return Vector3: new( self.x + vec3.x, self.y + vec3.y, self.z + vec3.z );
	elseif type( vec3 ) == "number" then
		return Vector3: new( self.x + vec3, self.y + vec3, self.z + vec3 );
	end
end


function Vector3: sub( vec3 )
	if type( vec3 ) == "table" then
		return Vector3: new( self.x - vec3.x, self.y - vec3.y, self.z - vec3.z );
	elseif type( vec3 ) == "number" then
		return Vector3: new( self.x - vec3, self.y - vec3, self.z - vec3 );
	end
end


function Vector3: mul( vec3 )
	if type( vec3 ) == "table" then
		return Vector3: new(  self.x * vec3.x, self.y * vec3.y, self.z * vec3.z );
	elseif type( vec3 ) == "number" then
		return Vector3: new(  self.x * vec3, self.y * vec3, self.z * vec3 );
	end
end


function Vector3: div( vec3 )
	return Vector3: new( self.x / vec3.x, self.y / vec3.y, self.z / vec3.z );
end


-- returns length (or magnitude) of the vector
function Vector3: length( )
	return math.sqrt( self.x^2 + self.y^2 + self.z^2 );
end


-- returns normalized vector (values of x, y and z will be between 0 and 1)
function Vector3: normalize( )
	return self:div( Vector3:new( self:length() ) );
end


-- returns a pointing direction of the vector
function Vector3: direction2D( )
	return math.deg( math.atan2( self.x, self.y ) );
end


-- returns dot product of 2 vectors
function Vector3: dot( vec3 )
	local mul = self:mul( vec3 );
	return mul.x + mul.y + mul.z;
end


-- returns cross product vector of 2 vectors
function Vector3: cross( vec3 )
	assert( type( vec3 ) == "table", "Vector3: cross - pass vector3 as an argument" );
	if type( vec3 ) ~= "table" then return false; end
	local fX = self.y * vec3.z - self.z * vec3.y;
	local fY = self.z * vec3.x - self.x * vec3.z;
	local fZ = self.x * vec3.y - self.y * vec3.x;
	return Vector3: new( fX, fY, fZ );
end


-- returns an angle between 2 vectors
function Vector3: angle( vec3 )
	-- formula:      vec x vec 
	--		ang = ---------------
	--			  sqrt of ( magnitude * magnitude )
	return math.deg( math.acos( self:dot( vec3 ) / math.sqrt( self:length( ) * vec3:length( ) ) ) );
end


-- inverses the vector
function Vector3: inverse( )
	return self:mul( -1 );
end


function Vector3: interpolate( vTarget, fFactor )
	if type( vTarget ) ~= "table" then return false; end
	if fFactor < 0 then fFactor = 0; end
	if fFactor > 1 then fFactor = 1; end
	return self: add( vTarget: sub( self ):mul( fFactor ) );
end


function Vector3: print( )
	outputDebugString( "< " .. tostring( self.x ) .. " ,  " .. tostring( self.y ) .. " ,  ".. tostring( self.z ) .. " >" );
end


function Vector3: tostring( )
	return "< " .. tostring( self.x ) .. " ,  " .. tostring( self.y ) .. " ,  ".. tostring( self.z ) .. " >";
end

function Vector3: draw( vOffset, iColour )
	if type( vOffset ) == "table" then
		dxDrawLine3D( vOffset.x, vOffset.y, vOffset.z, self.x + vOffset.x, self.y + vOffset.y, self.z + vOffset.z, iColour and iColour or COLOUR.RED, 5, false, 0 );
	elseif type( vOffset ) == "number" then
		dxDrawLine3D( 0, 0, 0, self.x, self.y, self.z, vOffset, 5, false, 0 );
	else 
		dxDrawLine3D( 0, 0, 0, self.x, self.y, self.z, tocolor( 255, 0, 0 ), 5, false, 65635 );
	end
end