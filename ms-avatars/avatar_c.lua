local avatars = {} 

function loadAvatar(uid)
	if avatars[uid] then 
		if isElement(avatars[uid].image) then 
			return avatars[uid].image
		else 
			return ":ms-avatars/avatar.png"
		end 
	else 
		avatars[uid] = {} 
		triggerServerEvent("onClientRequestAvatar", localPlayer, uid)
		return ":ms-avatars/avatar.png"
	end 
end 


function resetAvatar(uid)
	triggerServerEvent("onPlayerResetAvatar", localPlayer, uid)
end 

function onClientResetAvatar(uid)
	if avatars[uid] then 
		if isElement(avatars[uid].image) then 
			destroyElement(avatars[uid].image)
		end 
		
		avatars[uid] = false 
	end 
end 
addEvent("onClientResetAvatar", true)
addEventHandler("onClientResetAvatar", root, onClientResetAvatar)

function onClientGetAvatar(data, uid, url)
	if not isElement(avatars[uid].image) then 
		avatars[uid].image = dxCreateTexture(data, "dxt1", true, "clamp", "2d")
		if not isElement(avatars[uid].image) then return end 
		
		local w,h = dxGetMaterialSize(avatars[uid].image)
		if w > 257 or h > 257 then 
			if uid == getElementData(localPlayer, "player:uid") then 
				setElementData(localPlayer, "player:avatar", false)
				destroyElement(avatars[uid].image)
				avatars[uid] = false 
				triggerEvent("onClientAddNotification", localPlayer, "Twój avatar nie może przekraczać rozmiarów 256x256.", "error")
				resetAvatar(uid)
				triggerServerEvent("onPlayerDeleteAvatar", localPlayer, uid)
			end 
		end 
	end 
end 
addEvent("onClientGetAvatar", true)
addEventHandler("onClientGetAvatar", root, onClientGetAvatar)