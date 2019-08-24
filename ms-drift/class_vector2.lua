
Vector2 = { };
Vector2.__index = Vector2;

function Vector2: new( x, y )
	if type( x ) == "string" then
		local temp = string.sub( x, 2, -2 ); -- remove [ and ] from START and END of the string
		temp = split( temp, "," ); -- split by comma
		x = tonumber( temp[ 1 ] );
		y = tonumber( temp[ 2 ] );
	end
	if ( type( x ) == "number" ) and ( not y ) then
		x, y = x, x;
	end
	local vec2 = {
		x = x,
		y = y,
	}
	self.__index = self;
	setmetatable( vec2, self );
	return vec2;
end

-- returns x, y and z respectively
function Vector2: explode( )
	return self.x, self.y;
end


function Vector2: zero( )
	return Vector2:new( 0 );
end


function Vector2: one( )
	return Vector2:new( 1 );
end


function Vector2: add( vec2 )
	if type( vec2 ) == "table" then
		return Vector2: new( self.x + vec2.x, self.y + vec2.y );
	elseif type( vec2 ) == "number" then
		return Vector2: new( self.x + vec2, self.y + vec2 );
	end
end


function Vector2: sub( vec2 )
	if type( vec2 ) == "table" then
		return Vector2: new( self.x - vec2.x, self.y - vec2.y );
	elseif type( vec2 ) == "number" then
		return Vector2: new( self.x - vec2, self.y - vec2 );
	end
end


function Vector2: mul( vec2 )
	if type( vec2 ) == "table" then
		return Vector2: new( self.x * vec2.x, self.y * vec2.y );
	elseif type( vec2 ) == "number" then
		return Vector2: new( self.x * vec2, self.y * vec2 );
	end
end


function Vector2: div( vec2 )
	if type( vec2 ) == "table" then
		return Vector2: new( self.x / vec2.x, self.y / vec2.y );
	elseif type( vec2 ) == "number" then
		return Vector2: new( self.x / vec2, self.y / vec2 );
	end
end


-- returns length (or magnitude) of the vector
function Vector2: length( )
	return math.sqrt( self.x^2 + self.y^2 );
end


-- returns normalized vector (values of x, y and z will be between 0 and 1)
function Vector2: normalize( )
	return self:div( Vector2:new( self:length() ) );
end


-- returns a pointing direction of the vector
function Vector2: direction( )
	return math.deg( math.atan2( self.x, self.y ) );
end


-- returns dot product of 2 vectors (
function Vector2: dot( vec2 )
	local mul = self:mul( vec2 );
	return mul.x + mul.y;
end


-- returns an angle between 2 vectors
function Vector2: angle( vec2 )
	-- FORMULA:
	--              dot product of vectors: vec x vec 
	--		ang = -------------------------------------
	--			    sqrt of ( magnitude * magnitude )
	--local t = math.deg( math.acos( self: dot( vec2 ) / math.sqrt( self: length( ) * vec2: length( ) ) ) );
	return math.deg( math.acos( self: dot( vec2 ) / math.sqrt( (self: length( ) * vec2: length( ) ) ^ 2 ) ) );
end


-- inverses the vector
function Vector2: inverse( )
	return self:mul( -1 );
end


function Vector2: isOnLine( vec2 )
	local ang = self: angle( vec2 )
	if ang < 1.5 and vec2: length() > self: length( ) then
		return true;
	else
		return false;
	end
end


function Vector2: print( )
	outputDebugString( "< " .. tostring( self.x ) .. " ,  " .. tostring( self.y ) .. " >" );
end


function Vector2: tostring( )
	return "< " .. tostring( self.x ) .. " ,  " .. tostring( self.y ) .. " >";
end

