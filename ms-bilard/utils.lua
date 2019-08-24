ballNames={
	[2995]="Jedynka połówka",
	[2996]="Dwójka połówka",
	[2997]="Trójka połówka",
	[2998]="Czwórka połówka",
	[2999]="Piątka połówka",
	[3000]="Szóstka połówka",
	[3001]="Siódemka połówka",

	[3002]="Jedynka cała", 

	[3003]="Biała cała",

	[3100]="Dwójka cała",
	[3101]="Trójka cała",
	[3102]="Czwórka cała",
	[3103]="Piątka cała",
	[3104]="Szóstka cała",
	[3105]="Siódemka cała",
	[3106]="Ósemka",
}


function shuffle(t)
  local n = #t
 
  while n >= 2 do
    -- n is now the last pertinent index
    local k = math.random(n) -- 1 <= k <= n
    -- Quick swap
    t[n], t[k] = t[k], t[n]
    n = n - 1
  end
 
  return t
end

function findRotation(startX, startY, targetX, targetY)	-- Doomed-Space-Marine
	local t = -math.deg(math.atan2(targetX - startX, targetY - startY))
	
	if t < 0 then
		t = t + 360
	end
	
	return t
end
