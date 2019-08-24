function msToTimeStr(ms)
	if not ms then
		return ''
	end
	
	if ms < 0 then
		return "0","00","00"
	end
	
	local centiseconds = tostring(math.floor(math.fmod(ms, 1000)/10))
	if #centiseconds == 1 then
		centiseconds = '0' .. centiseconds
	end
	local s = math.floor(ms / 1000)
	local seconds = tostring(math.fmod(s, 60))
	if #seconds == 1 then
		seconds = '0' .. seconds
	end
	local minutes = tostring(math.floor(s / 60))
	
	return minutes, seconds, centiseconds
end