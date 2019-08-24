screenW, screenH = guiGetScreenSize()

local baseX = 1680
local zoom = 1.0
local minZoom = 1.8
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local font = dxCreateFont("BebasNeue.otf", 28/zoom)

local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil

local function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end

local function camRender()
	if (sm.moov == 1) then
		local x1,y1,z1 = getElementPosition(sm.object1)
		local x2,y2,z2 = getElementPosition(sm.object2)
		setCameraMatrix(x1,y1,z1,x2,y2,z2)
	end
end
addEventHandler("onClientPreRender",root,camRender)

function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	sm.object1 = createObject(1337,x1,y1,z1)
	sm.object2 = createObject(1337,x1t,y1t,z1t)
	setElementAlpha(sm.object1,0)
	setElementAlpha(sm.object2,0)
	setObjectScale(sm.object1,0.01)
	setObjectScale(sm.object2,0.01)
	moveObject(sm.object1,time,x2,y2,z2,0,0,0,"InOutQuad")
	moveObject(sm.object2,time,x2t,y2t,z2t,0,0,0,"InOutQuad")
	sm.moov = 1
	setTimer(removeCamHandler,time,1)
	setTimer(destroyElement,time,1,sm.object1)
	setTimer(destroyElement,time,1,sm.object2)
	return true
end

VehicleUpgrades = {
	{itemid="1000",name="Pro",price="14500"},
	{itemid="1001",name="Win",price="25500"},
	{itemid="1002",name="Drag",price="16500"},
	{itemid="1003",name="Alpha",price="22500"},
	{itemid="1004",name="Champ Scoop",price="19500"},
	{itemid="1005",name="Fury Scoop",price="21500"},
	{itemid="1006",name="Roof Scoop",price="21500"},
	{itemid="1007",name="R Sideskirt",price="15500"},
	{itemid="1010",name="Nitro",price="40000"},
	{itemid="1011",name="Race Scoop",price="22200"},
	{itemid="1012",name="Worx Scoop",price="22500"},
	{itemid="1013",name="Round Fog Lamp",price="11500"},
	{itemid="1014",name="Champ Spoiler",price="22400"},
	{itemid="1015",name="Race Spoiler",price="24500"},
	{itemid="1016",name="Worx Spoiler",price="22800"},
	{itemid="1017",name="L Sideskirt",price="15000"},
	{itemid="1018",name="Upsweptc Exhaust",price="23500"},
	{itemid="1019",name="Twin Cylinder Exhaust",price="24500"},
	{itemid="1020",name="Large Exhaust",price="21500"},
	{itemid="1021",name="Medium Exhaust",price="18200"},
	{itemid="1022",name="Small Exhaust",price="16500"},
	{itemid="1023",name="Fury Spoiler",price="24500"},
	{itemid="1024",name="Square Fog Lamp",price="11500"},
	{itemid="1025",name="Off Road",price="18900"},
	{itemid="1026",name="R Alien Sideskirt",price="24800"},
	{itemid="1027",name="L Alien Sideskirt",price="24800"},
	{itemid="1028",name="Alien Exhaust",price="27700"},
	{itemid="1029",name="X-Flow Exhaust",price="26800"},
	{itemid="1030",name="L X-Flow Sideskirt",price="23700"},
	{itemid="1031",name="R X-Flow Sideskirt",price="23700"},
	{itemid="1032",name="Alien Roof Scoop",price="31700"},
	{itemid="1033",name="X-Flow Roof Scoop type 2",price="31200"},
	{itemid="1034",name="Alien Exhaust",price="27900"},
	{itemid="1035",name="X-Flow Exhaust",price="31500"},
	{itemid="1036",name="R Alien Sideskirt",price="25900"},
	{itemid="1037",name="X-Flow Exhaust",price="26900"},
	{itemid="1038",name="Alien Roof Scoop",price="31900"},
	{itemid="1039",name="L X-Flow Sideskirt",price="23900"},
	{itemid="1040",name="L Alien Sideskirt",price="25900"},
	{itemid="1041",name="R X-Flow Sideskirt",price="23900"},
	{itemid="1042",name="R Chrome Sideskirt",price="26900"},
	{itemid="1043",name="Slamin Exhaust",price="25800"},
	{itemid="1044",name="Chrome Exhaust",price="25600"},
	{itemid="1045",name="X-Flow Exhaust",price="25100"},
	{itemid="1046",name="Alien Exhaust",price="26100"},
	{itemid="1047",name="R Alien Sideskirt",price="26700"},
	{itemid="1048",name="R X-Flow Sideskirt",price="25300"},
	{itemid="1049",name="Alien Spoiler",price="28100"},
	{itemid="1050",name="X-Flow Spoiler",price="26200"},
	{itemid="1051",name="L Alien Sideskirt",price="26700"},
	{itemid="1052",name="L X-Flow Sideskirt",price="25300"},
	{itemid="1053",name="X-Flow Roof Scoop",price="21300"},
	{itemid="1054",name="Alien Roof Scoop",price="22100"},
	{itemid="1055",name="Alien Roof Scoop",price="22300"},
	{itemid="1056",name="R Alien Sideskirt",price="25200"},
	{itemid="1057",name="R X-Flow Sideskirt",price="24300"},
	{itemid="1058",name="Alien Spoiler",price="26200"},
	{itemid="1059",name="X-Flow Exhaust",price="23200"},
	{itemid="1060",name="X-Flow Spoiler",price="27300"},
	{itemid="1061",name="X-Flow Roof Scoop",price="21800"},
	{itemid="1062",name="L Alien Sideskirt",price="25200"},
	{itemid="1063",name="L X-Flow Sideskirt",price="24300"},
	{itemid="1064",name="Alien Exhaust",price="24300"},
	{itemid="1065",name="Alien Exhaust",price="23500"},
	{itemid="1066",name="X-Flow Exhaust",price="24500"},
	{itemid="1067",name="Alien Roof Scoop",price="22500"},
	{itemid="1068",name="X-Flow Roof Scoop",price="22900"},
	{itemid="1069",name="R Alien Sideskirt",price="25500"},
	{itemid="1070",name="R X-Flow Sideskirt",price="24500"},
	{itemid="1071",name="L Alien Sideskirt",price="25500"},
	{itemid="1072",name="L X-Flow SIdeskirt",price="2450"},
	{itemid="1073",name="Shadow",price="18500"},
	{itemid="1074",name="Mega",price="18300"},
	{itemid="1075",name="Rimshine",price="17900"},
	{itemid="1076",name="Wires",price="17200"},
	{itemid="1077",name="Classic",price="17800"},
	{itemid="1078",name="Twist",price="18100"},
	{itemid="1079",name="Cutter",price="16300"},
	{itemid="1080",name="Switch",price="16800"},
	{itemid="1081",name="Grove",price="14300"},
	{itemid="1082",name="Import",price="16200"},
	{itemid="1083",name="Dollar",price="13600"},
	{itemid="1084",name="Trance",price="14500"},
	{itemid="1085",name="Atomic",price="17700"},
	{itemid="1086",name="Stereo",price="15000"},
	{itemid="1087",name="Hydraulics",price="30390"},
	{itemid="1088",name="Alien Roof Scoop",price="21500"},
	{itemid="1089",name="X-Flow Exhaust",price="20500"},
	{itemid="1090",name="R Alien Sideskirt",price="21500"},
	{itemid="1091",name="X-Flow Exhaust",price="21000"},
	{itemid="1092",name="Alien Exhaust",price="22100"},
	{itemid="1093",name="R X-Flow Sideskirt",price="23500"},
	{itemid="1094",name="L Alien Sideskirt",price="24500"},
	{itemid="1095",name="R X-Flow Sideskirt",price="23500"},
	{itemid="1096",name="Ahab",price="21500"},
	{itemid="1097",name="Virtual",price="13500"},
	{itemid="1098",name="Access",price="17400"},
	{itemid="1099",name="L Chrome Sideskirt",price="21000"},
	{itemid="1100",name="Chrome Grill",price="19400"},
	{itemid="1101",name="L Chrome Flames",price="21800"},
	{itemid="1102",name="L Chrome Strip",price="20300"},
	{itemid="1103",name="Convertible Roof",price="22500"},
	{itemid="1104",name="Chrome Exhaust",price="22100"},
	{itemid="1105",name="Slamin Exhaust",price="23400"},
	{itemid="1106",name="R Chrome Arches",price="23800"},
	{itemid="1107",name="L Chrome Strip",price="23800"},
	{itemid="1108",name="R Chrome Strip",price="23800"},
	{itemid="1109",name="Chrome R Bullbars",price="23100"},
	{itemid="1110",name="Slamin R Bullbars",price="25400"},
	{itemid="1111",name="Front Sign",price="24500"},
	{itemid="1112",name="Front Sign",price="23900"},
	{itemid="1113",name="Chrome Exhaust",price="26500"},
	{itemid="1114",name="Slamin Exhaust",price="25900"},
	{itemid="1115",name="Chrome Bullbars",price="21300"},
	{itemid="1116",name="Slamin Bullbars",price="26500"},
	{itemid="1117",name="Chrome F Bumper",price="27400"},
	{itemid="1118",name="R Chrome Trim",price="27200"},
	{itemid="1119",name="R WHeelcovers",price="19400"},
	{itemid="1120",name="L Chrome Trim",price="26400"},
	{itemid="1121",name="L Wheelcovers",price="19400"},
	{itemid="1122",name="R Chrome Flames",price="24800"},
	{itemid="1123",name="Chrome Bars",price="23600"},
	{itemid="1124",name="L Chrome Arches",price="24800"},
	{itemid="1125",name="Chrome Lights",price="21200"},
	{itemid="1126",name="Chrome Exhaust",price="23400"},
	{itemid="1127",name="Slamin Exhaust",price="22500"},
	{itemid="1128",name="Vinyl Hardtop",price="33400"},
	{itemid="1129",name="Chrome Exhaust",price="22500"},
	{itemid="1130",name="Hardtop",price="35800"},
	{itemid="1131",name="Softtop",price="32900"},
	{itemid="1132",name="Slamin Exhaust",price="25900"},
	{itemid="1133",name="R Chrome Strip",price="28300"},
	{itemid="1134",name="R Chrome Strip",price="23600"},
	{itemid="1135",name="Slamin Exhaust",price="25000"},
	{itemid="1136",name="Chrome Exhaust",price="24900"},
	{itemid="1137",name="L Chrome Strip",price="24100"},
	{itemid="1138",name="Alien Spoiler",price="25800"},
	{itemid="1139",name="X-Flow Spoiler",price="32700"},
	{itemid="1140",name="X-Flow R Bumper",price="31700"},
	{itemid="1141",name="ALien R Bumper",price="31800"},
	{itemid="1142",name="Left Oval Vents",price="25700"},
	{itemid="1143",name="R Oval Vents",price="22000"},
	{itemid="1144",name="L Square Vents",price="22100"},
	{itemid="1145",name="R Square Vents",price="23100"},
	{itemid="1146",name="X-Flow Spoiler",price="27900"},
	{itemid="1147",name="Alien Spoiler",price="28700"},
	{itemid="1148",name="X-Flow R Bumper",price="27800"},
	{itemid="1149",name="EAlien R Bumper",price="23000"},
	{itemid="1150",name="Alien R Bumper",price="23900"},
	{itemid="1151",name="X-Flow R Bumper",price="23400"},
	{itemid="1152",name="X-Flow F Bumper",price="29100"},
	{itemid="1153",name="Alien F Bumper",price="28000"},
	{itemid="1154",name="Alien R Bumper",price="27300"},
	{itemid="1155",name="Alien F Bumper",price="28300"},
	{itemid="1156",name="X-Flow R Bumper",price="29200"},
	{itemid="1157",name="X-Flow F Bumper",price="28300"},
	{itemid="1158",name="X-Flow Spoiler",price="28500"},
	{itemid="1159",name="Alien R Bumper",price="27500"},
	{itemid="1160",name="Alien F Bumper",price="26500"},
	{itemid="1161",name="X-Flow R Bumper",price="27500"},
	{itemid="1162",name="Alien Spoiler",price="27500"},
	{itemid="1163",name="X-Flow Spoiler",price="24500"},
	{itemid="1165",name="X-Flow F Bumper",price="28500"},
	{itemid="1166",name="Alien F Bumper",price="28500"},
	{itemid="1167",name="X-Flow R Bumper",price="28500"},
	{itemid="1168",name="Alien R Bumper",price="29500"},
	{itemid="1169",name="Alien F Bumper",price="29700"},
	{itemid="1170",name="X-Flow F Bumper",price="28800"},
	{itemid="1171",name="Alien F Bumper",price="29900"},
	{itemid="1172",name="X-Flow F Bumper",price="29000"},
	{itemid="1173",name="X-Flow F Bumper",price="29500"},
	{itemid="1174",name="Chrome F Bumper",price="27000"},
	{itemid="1175",name="Slamin R Bumper",price="29000"},
	{itemid="1176",name="Chrome F Bumper",price="28400"},
	{itemid="1177",name="Slamin R Bumper",price="29300"},
	{itemid="1178",name="Slamin R Bumper",price="23500"},
	{itemid="1179",name="Chrome F Bumper",price="28500"},
	{itemid="1180",name="Chrome R Bumper",price="29300"},
	{itemid="1181",name="Slamin F Bumper",price="27400"},
	{itemid="1182",name="Chrome F Bumper",price="28500"},
	{itemid="1183",name="Slamin R Bumper",price="26500"},
	{itemid="1184",name="Chrome R Bumper",price="28500"},
	{itemid="1185",name="Slamin F Bumper",price="27400"},
	{itemid="1186",name="Slamin R Bumper",price="27950"},
	{itemid="1187",name="Chrome R Bumper",price="26750"},
	{itemid="1188",name="Slamin F Bumper",price="25800"},
	{itemid="1189",name="Chrome F Bumper",price="27100"},
	{itemid="1190",name="Slamin F Bumper",price="24500"},
	{itemid="1191",name="Chrome F Bumper",price="28800"},
	{itemid="1192",name="Chrome R Bumper",price="28400"},
	{itemid="1193",name="Slamin R Bumper",price="27600"},
	{itemid="69", name="Kontrola zawieszenia", price="20000"},
}


local vpaintjobs={
    [483]={0},        -- camper
    [534]={0,1,2},    -- remington
    [535]={0,1,2},    -- slamvan
    [536]={0,1,2},    -- blade
    [558]={0,1,2},    -- uranus
    [559]={0,1,2},    -- jester
    [560]={0,1,2},    -- sultan
    [561]={0,1,2},    -- stratum
    [562]={0,1,2},    -- elegy
    [565]={0,1,2},    -- flash
    [567]={0,1,2},    -- savanna
    [575]={0,1},      -- broadway
    [576]={0,1,2},    -- tornado
}

local modifiers= {
	[1] = {name="Modyfikator silnika", price=50000},
	[2] = {name="Modyfikator skoku", price=20000},
	[3] = {name="Modyfikator zdrowia", price=40000},
	[4] = {name="Modyfikator zawieszenia", price=10000},
}

class "CTuneShop"
{
	__init__ = function(self, vehicle, id)
		self.id = id 
		
		self.show = false

		self.categories = {} -- "KOŁA", "SPOILERY", "WYDECH", "DACH", "LISTWY PROGOWE", "PRZEDNIE ZDERZAKI", "TYLNE ZDERZAKI", "MASKA", "DODATKI - nitro, hydraulika"
		self.selectedCategory = 0

		self.renderFunc = function() self:onRender() end
		self.keysFunc = function(a, b) self:handleKeys(a, b) end
		addEventHandler("onClientRender", root, self.renderFunc)
		addEventHandler("onClientKey", root, self.keysFunc)
		
		self.vehicle = vehicle
		local x,y,z = getElementPosition(self.vehicle)
		
		self.r1, self.g1, self.b1, self.r2, self.g2, self.b2, self.r3, self.g3, self.b3, self.r4, self.g4, self.b4 = getVehicleColor(vehicle, true)
		self.lr, self.lg, self.lb = getVehicleHeadLightColor(vehicle)
		setVehicleOverrideLights(vehicle, 2)

		setElementAlpha(localPlayer, 0)

		self.selectedUpgradeIndex = 1
		self.previousUpgrade = false

		self.upgrades = getVehicleCompatibleUpgrades(vehicle)
		self.wheels = {}
		self.spoilers = {}
		self.exhausts = {}
		self.roofs = {}
		self.sideskirts = {}
		self.frontbumpers = {}
		self.rearbumpers = {}
		self.hoods = {}
		self.addons = {}
		self.modifiers = {
			0, -- silnik
			0, -- jump 
			0, -- hp
		}
		
		if getVehicleType(vehicle) == "Automobile" or getVehicleType(vehicle) == "Bike" then 
			self:addCategory("MODYFIKATORY")
			
			local vehModifiers =  getElementData(vehicle, "vehicle:upgrade_addons") or {engine=0, jump=0, hp=0, suspension={installed=0, value=0}}
			self.modifiers = {vehModifiers.engine, vehModifiers.jump, vehModifiers.hp, vehModifiers.suspension}
		end 
		
		for _, v in ipairs ( self.upgrades ) do
			local type = getVehicleUpgradeSlotName ( v )
			if type == "Hood" then
				self:addCategory("MASKI")
				table.insert(self.hoods, v)
			elseif type == "Spoiler" then
				self:addCategory("SPOILERY")
				table.insert(self.spoilers, v)
				
				local found = false 
				for _, can in ipairs(VehicleUpgrades) do 
					if v == tonumber(can.itemid) then 
						found = true 
					end 
				end 
				
				if not found then 
					table.remove(self.spoilers, #self.spoilers)
				end 
			elseif type == "Sideskirt" then
				self:addCategory("LISTWY PROGOWE")
				table.insert(self.sideskirts, v)
			elseif type == "Roof" then
				self:addCategory("DACHY")
				table.insert(self.roofs, v)
			elseif type == "Front Bumper" then
				self:addCategory("PRZEDNIE ZDERZAKI")
				table.insert(self.frontbumpers, v)
			elseif type == "Nitro" then
				if v == 1010 then 
					self:addCategory("DODATKI")
					table.insert(self.addons, v)
				end
			elseif type == "Rear Bumper" then
				self:addCategory("TYLNE ZDERZAKI")
				table.insert(self.rearbumpers, v)
			elseif type == "Hydraulics" then
				self:addCategory("DODATKI")
				table.insert(self.addons, v)
			elseif type == "Wheels" then
				self:addCategory("KOŁA")
				table.insert(self.wheels, v)
			elseif type == "Exhaust" then
				self:addCategory("WYDECHY")
				table.insert(self.exhausts, v)
			end
		end

		table.insert(self.categories, "KOLOR")

		-- paintjoby
		local model = getElementModel(self.vehicle)
		local paintjobs = vpaintjobs[model]
		if paintjobs then
			self.paintjobs = paintjobs
			table.insert(self.categories, "MALOWANIA")
		end
		self.vehiclePaintjob = getVehiclePaintjob(self.vehicle)
		
		if getVehicleType(self.vehicle) == "Automobile" then 
			-- neony
			table.insert(self.categories, "NEONY")
			self.neonColor = getElementData(self.vehicle, "vehicle:neon")
				
			-- zawieszenie w dodatkach 
			table.insert(self.addons, 69)
		end
		
		table.sort(self.categories)
		self.tableByCategory =
		{
			["MASKI"] = self.roofs,
			["SPOILERY"] = self.spoilers,
			["LISTWY PROGOWE"] = self.sideskirts,
			["DACHY"] = self.roofs,
			["DODATKI"] = self.addons,
			["KOŁA"] = self.wheels,
			["WYDECHY"] = self.exhausts,
			["PRZEDNIE ZDERZAKI"] = self.frontbumpers,
			["TYLNE ZDERZAKI"] = self.rearbumpers,
			["MALOWANIA"] = self.paintjobs,
			["MODYFIKATORY"] = self.modifiers,
		}

		self.slotsByName =
		{
			["Hood"] = 0,
			["Vent"] = 1,
			["Spoiler"] = 2,
			["Sideskirt"] = 3,
			["Headlights"] = 6,
			["Roof"] = 7,
			["Nitro"] = 8,
			["Hydraulics"] = 9,
			["Wheels"] = 12,
			["Exhaust"] = 13,
			["Front Bumper"] = 14,
			["Rear Bumper"] = 15
		}

		self.bgDescription = {} 
		self.bgDescriptionLine = {} 
		
		self.installedUpgrades = getVehicleUpgrades(vehicle)
		if getElementData(vehicle, "vehicle:hasNOS") then 
			table.insert(self.installedUpgrades, 1010)
		end 
		
		toggleAllControls(false)
		showChat(false)
		smoothMoveCamera(1418.4205322266, -6.190999984741, 1004.1290283203, 1417.5073242188, -6.5472993850708, 1003.931274414, 1399.2434082031, -12.975099563599, 1000.8358764648, 1398.3311767578, -13.384677886963, 1000.8305664063,4000)
		showCursor(true)
		triggerEvent("onClientShowHUD", localPlayer, false)
		triggerEvent("onClientShowRadar", localPlayer, false)
		setElementData(localPlayer, "player:inTuneShop", true)
	end,

	addCategory = function(self, category)
		local found = false
		for k,v in ipairs(self.categories) do
			if string.find(v, category) then
				found = true
			end
		end

		if not found then table.insert(self.categories, category) end
	end,

	getUpgradeData = function(self, upgrade)
		for k,v in ipairs(VehicleUpgrades) do
			if tonumber(v.itemid) == upgrade then
				return v.name, v.price
			end
		end
	end,

	destroy = function(self)
		fadeCamera(false, 0.5)
		setTimer(
		function()
			setElementData(localPlayer, "player:inTuneShop", false)
			
			setElementAlpha(localPlayer, 255)
			setVehicleColor(self.vehicle, self.r1, self.g1, self.b1, self.r2, self.g2, self.b2)
			setVehicleHeadLightColor(self.vehicle, self.lr, self.lg, self.lb)
			setVehiclePaintjob(self.vehicle, self.vehiclePaintjob)
			
			for k,v in ipairs(getVehicleUpgrades(self.vehicle)) do  -- update po stronie clienta
				removeVehicleUpgrade(self.vehicle, v)
			end

			for k,v in ipairs(self.installedUpgrades) do
				addVehicleUpgrade(self.vehicle, v)
			end

			showChat(true)
			colorPicker.closeSelect()
			triggerEvent("onClientShowHUD", localPlayer, true)
			triggerEvent("onClientShowRadar", localPlayer, true)
			toggleAllControls(true)
			fadeCamera(true, 0.5)
			showCursor(false)
			removeEventHandler("onClientKey", root, self.keysFunc)
			removeEventHandler("onClientRender", root, self.renderFunc)
			setCameraTarget(localPlayer, localPlayer)
			
			setElementData(self.vehicle, "vehicle:neon", self.neonColor)
			
			triggerServerEvent("onPlayerExitTuneShop", localPlayer, self.id)
		end, 500, 1)
		
				
		tuneShop = false 
	end,

	moveCamera = function(self)
		local x1,y1,z1,x1t,y1t,z1t = getCameraMatrix()
		local name = self.categories[self.selectedCategory]
		if name == "SPOILERY" then
			smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t, 1384.3649902344, -16.749500274658, 1002.4262695313, 1385.3514404297, -16.744554519653, 1002.2621459961, 700)
		elseif name == "MASKI" then
			smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t, 1397.3566894531, -16.653600692749, 1002.3283081055, 1396.3776855469, -16.66392326355, 1002.1248779297, 700)
		elseif name == "LISTWY PROGOWE" then
			smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t, 1394.0245361328, -20.571599960327, 1000.2954711914, 1393.5466308594, -19.715785980225, 1000.493286132, 700)
		elseif name == "DACHY" then
			smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t, 1397.3566894531, -16.653600692749, 1002.3283081055, 1396.3776855469, -16.66392326355, 1002.1248779297, 700)
		elseif name == "KOŁA" then
			smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t, 1395.4847412109, -12.815999984741, 1000.7020874023, 1394.8072509766, -13.545837402344, 1000.7930908203, 700)
		elseif name == "DODATKI" then
			smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t, 1399.2434082031, -12.975099563599, 1000.8358764648, 1398.3311767578, -13.384677886963, 1000.8305664063, 700)
		elseif name == "WYDECHY" then
			smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t, 1386.2930908203, -16.694400787354, 1000.8353271484, 1387.2911376953, -16.697444915771, 1000.8984375, 700)
		elseif name == "PRZEDNIE ZDERZAKI" then
			smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t, 1397.4615478516, -16.737400054932, 1000.8118286133, 1396.4638671875, -16.732767105103, 1000.87890625, 700)
		elseif name == "TYLNE ZDERZAKI" then
			smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t, 1386.2930908203, -16.694400787354, 1000.8353271484, 1387.2911376953, -16.697444915771, 1000.8984375, 700)
		elseif name == "KOLOR" then
			smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t, 1404.1650390625, -19.020700454712, 1002.6848754883, 1403.1893310547, -18.837604522705, 1002.5643310547, 700)
		elseif name == "MALOWANIA" then
			smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t, 1404.1650390625, -19.020700454712, 1002.6848754883, 1403.1893310547, -18.837604522705, 1002.5643310547, 700)
		elseif name == "NEONY" then 
			smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t, 1399.2434082031, -12.975099563599, 1000.8358764648, 1398.3311767578, -13.384677886963, 1000.8305664063, 700)
		end
	end,
	
	setTune = function(self)
		for k,v in ipairs(getVehicleUpgrades(self.vehicle)) do 
			removeVehicleUpgrade(self.vehicle, v)
		end 
		
		for k,v in ipairs(self.installedUpgrades) do 
			addVehicleUpgrade(self.vehicle, v)
		end
		
		setElementData(self.vehicle, "vehicle:upgrades_addons", self.modifiers)
	end, 
	
	handleKeys = function(self, key, press)
		if sm.moov == 1 then return end
		if key == "escape" and press then
			self:destroy()
			cancelEvent()
		elseif key == "arrow_u" and press then
			if self.selectedCategory == 0 then return end
			if self.categories[self.selectedCategory] ~= "KOLOR" and self.categories[self.selectedCategory] ~= "MODYFIKATORY" and self.categories[self.selectedCategory] ~= "NEONY" then
				if self.categories[self.selectedCategory] ~= "MALOWANIA" then
					self:setTune()
				else
					setVehiclePaintjob(self.vehicle, self.vehiclePaintjob)
				end
			end
			self.selectedCategory = self.selectedCategory-1
			if self.selectedCategory < 1 then self.selectedCategory = #self.categories end

			self.selectedUpgradeIndex = 1
			self:moveCamera()
		elseif key == "arrow_d" and press then
			if self.categories[self.selectedCategory] ~= "KOLOR" and self.categories[self.selectedCategory] ~= "MODYFIKATORY" and self.categories[self.selectedCategory] ~= "NEONY" and self.selectedCategory ~= 0 then
				if self.categories[self.selectedCategory] ~= "MALOWANIA" then
					self:setTune()
				else
					setVehiclePaintjob(self.vehicle, self.vehiclePaintjob)
				end
			end

			self.selectedCategory = self.selectedCategory+1
			if self.selectedCategory > #self.categories then self.selectedCategory = 1 end

			self.selectedUpgradeIndex = 1
			self:moveCamera()
		elseif key == "arrow_l" and press then
			if self.categories[self.selectedCategory] ~= "KOLOR" and self.categories[self.selectedCategory] ~= "MODYFIKATORY" then
				self:setTune()
			end

			self.selectedUpgradeIndex = self.selectedUpgradeIndex-1
			if self.selectedUpgradeIndex < 1 then
				self.selectedUpgradeIndex = #self.tableByCategory[self.categories[self.selectedCategory]]
			end
		elseif key == "arrow_r" and press then
			if self.categories[self.selectedCategory] ~= "KOLOR" and self.categories[self.selectedCategory] ~= "MODYFIKATORY" then
				self:setTune()
			end

			self.selectedUpgradeIndex = self.selectedUpgradeIndex+1
			if self.selectedUpgradeIndex > #self.tableByCategory[self.categories[self.selectedCategory]] then
				self.selectedUpgradeIndex = 1
			end
		elseif key == "mouse1" and press then 
			if self.categories[self.selectedCategory] == "MODYFIKATORY" then
				local money = getElementData(localPlayer, "player:money") or 0 
				local x, y, w, h = 450/zoom, screenH/2-400/zoom/2, 700/zoom, 400/zoom
				local offsetX = (55/zoom)*3
				local offsetY = 0 
				
				-- PRZYSPIESZENIE
				-- dodanie
				local bx, by, bw, bh = x+20/zoom+offsetX+80/zoom, y+100/zoom+offsetY, 100/zoom, 40/zoom
				if isCursorOnElement(bx, by, bw, bh) then 
					if self.modifiers[1] >= 4 then 
						triggerEvent("onClientAddNotification", localPlayer, "Nie możesz więcej zwiększyć tego modyfikatora.", "error")
						return
					end 
					
					local upgradePrice = modifiers[1].price * math.max(1, self.modifiers[1]+1)
					if upgradePrice > money then 
						triggerEvent("onClientAddNotification", localPlayer, "Nie stać cię na to ulepszenie.", "error")
						return
					end 
					
					self.modifiers[1] = self.modifiers[1]+1
					local vehModifiers = {engine=self.modifiers[1], jump=self.modifiers[2], hp=self.modifiers[3], suspension=self.modifiers[4]}
					triggerServerEvent("onPlayerAddModifier", localPlayer, vehModifiers, upgradePrice)
					
					playSoundFrontEnd(46)
				end 
				
				-- odjęcie
				local bx, by, bw, bh = x+20/zoom+offsetX+200/zoom, y+100/zoom+offsetY, 100/zoom, 40/zoom
				if isCursorOnElement(bx, by, bw, bh) then 
					if self.modifiers[1] <= 0 then 
						triggerEvent("onClientAddNotification", localPlayer, "Nie możesz więcej zmniejszyć tego modyfikatora.", "error")
						return
					end 
					
					local upgradePrice = modifiers[1].price * math.max(1, self.modifiers[1])
					
					self.modifiers[1] = self.modifiers[1]-1
					local vehModifiers = {engine=self.modifiers[1], jump=self.modifiers[2], hp=self.modifiers[3], suspension=self.modifiers[4]}
					triggerServerEvent("onPlayerRemoveModifier", localPlayer, vehModifiers, upgradePrice)
					
					playSoundFrontEnd(46)
				end
				
				-- SKOK POJAZDU
				offsetY = offsetY+80/zoom
				
				-- dodanie
				local bx, by, bw, bh = x+20/zoom+offsetX+80/zoom, y+100/zoom+offsetY, 100/zoom, 40/zoom
				if isCursorOnElement(bx, by, bw, bh) then 
					if self.modifiers[2] >= 4 then 
						triggerEvent("onClientAddNotification", localPlayer, "Nie możesz więcej zwiększyć tego modyfikatora.", "error")
						return
					end 
					
					local upgradePrice = modifiers[2].price * math.max(1, self.modifiers[2]+1)
					if upgradePrice > money then 
						triggerEvent("onClientAddNotification", localPlayer, "Nie stać cię na to ulepszenie.", "error")
						return
					end 
					
					self.modifiers[2] = self.modifiers[2]+1
					local vehModifiers = {engine=self.modifiers[1], jump=self.modifiers[2], hp=self.modifiers[3], suspension=self.modifiers[4]}
					triggerServerEvent("onPlayerAddModifier", localPlayer, vehModifiers, upgradePrice)
					
					playSoundFrontEnd(46)
				end 
				
				-- odjęcie
				local bx, by, bw, bh = x+20/zoom+offsetX+200/zoom, y+100/zoom+offsetY, 100/zoom, 40/zoom
				if isCursorOnElement(bx, by, bw, bh) then 
					if self.modifiers[2] <= 0 then 
						triggerEvent("onClientAddNotification", localPlayer, "Nie możesz więcej zmniejszyć tego modyfikatora.", "error")
						return
					end 
					
					local upgradePrice = modifiers[2].price * math.max(1, self.modifiers[2])
					
					self.modifiers[2] = self.modifiers[2]-1
					local vehModifiers = {engine=self.modifiers[1], jump=self.modifiers[2], hp=self.modifiers[3], suspension=self.modifiers[4]}
					triggerServerEvent("onPlayerRemoveModifier", localPlayer, vehModifiers, upgradePrice)
					
					playSoundFrontEnd(46)
				end
				
				-- DODATKOWE HP
				offsetY = offsetY+80/zoom
				
				-- dodanie
				local bx, by, bw, bh = x+20/zoom+offsetX+80/zoom, y+100/zoom+offsetY, 100/zoom, 40/zoom
				if isCursorOnElement(bx, by, bw, bh) then 
					if self.modifiers[3] >= 4 then 
						triggerEvent("onClientAddNotification", localPlayer, "Nie możesz więcej zwiększyć tego modyfikatora.", "error")
						return
					end 
					
					local upgradePrice = modifiers[3].price * math.max(1, self.modifiers[3]+1)
					if upgradePrice > money then 
						triggerEvent("onClientAddNotification", localPlayer, "Nie stać cię na to ulepszenie.", "error")
						return
					end 
					
					self.modifiers[3] = self.modifiers[3]+1
					local vehModifiers = {engine=self.modifiers[1], jump=self.modifiers[2], hp=self.modifiers[3], suspension=self.modifiers[4]}
					triggerServerEvent("onPlayerAddModifier", localPlayer, vehModifiers, upgradePrice)
					
					playSoundFrontEnd(46)
				end 
				
				-- odjęcie
				local bx, by, bw, bh = x+20/zoom+offsetX+200/zoom, y+100/zoom+offsetY, 100/zoom, 40/zoom
				if isCursorOnElement(bx, by, bw, bh) then 
					if self.modifiers[3] <= 0 then 
						triggerEvent("onClientAddNotification", localPlayer, "Nie możesz więcej zmniejszyć tego modyfikatora.", "error")
						return
					end 
					
					local upgradePrice = modifiers[3].price * math.max(1, self.modifiers[3])
					
					self.modifiers[3] = self.modifiers[3]-1
					local vehModifiers = {engine=self.modifiers[1], jump=self.modifiers[2], hp=self.modifiers[3], suspension=self.modifiers[4]}
					triggerServerEvent("onPlayerRemoveModifier", localPlayer, vehModifiers, upgradePrice)
					
					playSoundFrontEnd(46)
				end
			end
		elseif key == "enter" and press then
			if self.categories[self.selectedCategory] ~= "KOLOR" and self.categories[self.selectedCategory] ~= "MALOWANIA" and self.categories[self.selectedCategory] ~= "MODYFIKATORY" and self.categories[self.selectedCategory] ~= "NEONY" then
				local upgrade = self.tableByCategory[self.categories[self.selectedCategory]][self.selectedUpgradeIndex]
				if upgrade ~= 69 then local upgradeType = getVehicleUpgradeSlotName(upgrade) end
				if not upgrade then return end
				local upgradeName, upgradePrice = self:getUpgradeData(upgrade)

				local isInstalled = false 
				if upgrade == 69 then
					isInstalled = self.modifiers[4].installed == 1
				else
					for k,v in ipairs(self.installedUpgrades) do 
						if v == upgrade then 
							isInstalled = true 
						end 
					end 
				end
				
					
				local money = getElementData(localPlayer, "player:money")
				if money < tonumber(upgradePrice) and not isInstalled then
					triggerEvent("onClientAddNotification", localPlayer, "Nie stać cię na tą część!", "error")
					return
				end

				playSoundFrontEnd(46)
				if upgrade == 69 then 
					if isInstalled then 
						self.modifiers[4].installed = 0
						triggerServerEvent("onPlayerSellUpgrade", localPlayer, upgrade, tonumber(upgradePrice), {engine=self.modifiers[1], jump=self.modifiers[2], hp=self.modifiers[3], suspension=self.modifiers[4]})
					else 
						triggerEvent("onClientAddNotification", localPlayer, "Od teraz możesz kontrolować zawieszenie pojazdu używając klawiszy [ i ] w każdej chwili.", "success", 10000)
						self.modifiers[4].installed = 1
						triggerServerEvent("onPlayerAddUpgrade", localPlayer, upgrade, tonumber(upgradePrice), {engine=self.modifiers[1], jump=self.modifiers[2], hp=self.modifiers[3], suspension=self.modifiers[4]})
					end
				else
					for k,v in ipairs(self.installedUpgrades) do -- zdejmujemy czesci z tej samej kategorii
						if v == upgrade then -- gracz posiada tą część, więc ją sprzedajemy za pol ceny
							triggerServerEvent("onPlayerSellUpgrade", localPlayer, upgrade, tonumber(upgradePrice))
							table.remove(self.installedUpgrades, k)
							return
						else
							if getVehicleUpgradeSlotName(v) == upgradeType then
								removeVehicleUpgrade(self.vehicle, v)
								table.remove(self.installedUpgrades, k)
							end
						end
					end

					triggerServerEvent("onPlayerAddUpgrade", localPlayer, upgrade, tonumber(upgradePrice))
					self:setTune()
					
					table.insert(self.installedUpgrades, upgrade)
				end 
			elseif self.categories[self.selectedCategory] == "MALOWANIA" then
				local paintjob = self.tableByCategory[self.categories[self.selectedCategory]][self.selectedUpgradeIndex]
				if paintjob == self.vehiclePaintjob then
					triggerServerEvent("onPlayerRemovePaintjob", localPlayer, paintjob, 2000)
					playSoundFrontEnd(46)
					self.vehiclePaintjob = 3
				else
					local money = getElementData(localPlayer, "player:money")
					if money < 2000 then
						triggerEvent("onClientAddNotification", localPlayer, "Nie stać cię na tą część!", "error")
						return
					end

					triggerServerEvent("onPlayerAddPaintjob", localPlayer, paintjob, 2000)
					playSoundFrontEnd(46)
					self.vehiclePaintjob = paintjob
				end
			elseif self.categories[self.selectedCategory] == "KOLOR" then
				local upgradePrice=0
				if guiCheckBoxGetSelected(checkColor1) then -- 1
					upgradePrice=upgradePrice+250
				end

				if guiCheckBoxGetSelected(checkColor2) then -- 2
					upgradePrice=upgradePrice+500
				end

				if guiCheckBoxGetSelected(checkColor5) then -- swiatla
					upgradePrice=upgradePrice+3000
				end

				if upgradePrice == 0 then
					triggerEvent("onClientAddNotification", localPlayer, "Nie zaznaczyłeś żadnego pola!", "error")
					return
				end

				local money = getElementData(localPlayer, "player:money")
				if money < upgradePrice then
					triggerEvent("onClientAddNotification", localPlayer, "Nie stać cię na tą część!", "error")
					return
				end

				self.r1, self.g1, self.b1, self.r2, self.g2, self.b2 = getVehicleColor(self.vehicle, true)
				self.lr, self.lg, self.lb = getVehicleHeadLightColor(self.vehicle)
				playSoundFrontEnd(46)
				triggerServerEvent("onPlayerSetColor", localPlayer, {self.r1, self.g1, self.b1, self.r2, self.g2, self.b2}, {self.lr, self.lg, self.lb}, upgradePrice)
			elseif self.categories[self.selectedCategory] == "NEONY" then 
				if not guiCheckBoxGetSelected(checkColor1) then
					triggerEvent("onClientAddNotification", localPlayer, "Nie wybrałeś koloru neonu.", "error")
					return
				end 
				
				local upgradePrice = 35000 
				local money = getElementData(localPlayer, "player:money") or 0
				if money < upgradePrice then
					triggerEvent("onClientAddNotification", localPlayer, "Nie stać cię na tą część!", "error")
					return
				end
				
				playSoundFrontEnd(46)
				triggerServerEvent("onPlayerBuyNeon", localPlayer, upgradePrice)
				self.neonColor = getElementData(self.vehicle, "vehicle:neon")
			end
		end

		if self.categories[self.selectedCategory] == "KOLOR" or self.categories[self.selectedCategory] == "NEONY" then
			colorPicker.openSelect()
		else
			colorPicker.closeSelect()
		end
	end,

	onRender = function(self)		
		-- update koloru
		if colorPicker.isSelectOpen then
			local r, g, b, a = colorPicker.value[1], colorPicker.value[2], colorPicker.value[3], colorPicker.value[4]

			local r1,g1,b1,r2,g2,b2,r3,g3,b3,r4,g4,b4 = getVehicleColor(self.vehicle, true)
			local r5,g5,b5 = getVehicleHeadLightColor(self.vehicle)
			if guiCheckBoxGetSelected(checkColor1) then -- 1
				r1,g1,b1=r,g,b
			else
				r1,g1,b1=self.r1,self.g1,self.b1
			end

			if guiCheckBoxGetSelected(checkColor2) then -- 2
				r2,g2,b2=r,g,b
			else
				r2,g2,b2=self.r2,self.g2,self.b2
			end

			if guiCheckBoxGetSelected(checkColor5) then -- swiatla
				r5,g5,b5=r,g,b
			else
				r5,g5,b5=self.lr,self.lg,self.lb
			end
			
			if self.categories[self.selectedCategory] == "KOLOR" then
				setVehicleColor(self.vehicle, r1,g1,b1,r2,g2,b2)
				setVehicleHeadLightColor(self.vehicle, r5, g5, b5)
				guiSetVisible(checkColor2, true)
				guiSetVisible(checkColor5, true)
			elseif self.categories[self.selectedCategory] == "NEONY" then 
				if guiCheckBoxGetSelected(checkColor1) then 
					setElementData(self.vehicle, "vehicle:neon", {r1, g1, b1, 255})
				end 
				
				guiSetVisible(checkColor2, false)
				guiSetVisible(checkColor5, false)
			end
		else
			setVehicleColor(self.vehicle, self.r1, self.g1, self.b1, self.r2, self.g2, self.b2)
			setVehicleHeadLightColor(self.vehicle, self.lr, self.lg, self.lb)
			setElementData(self.vehicle, "vehicle:neon", self.neonColor)
		end
		
		if self.selectedCategory > 0 then
			local upgrade,upgradeName,upgradePrice=false,false,false
			if self.categories[self.selectedCategory] ~= "KOLOR" and self.categories[self.selectedCategory] ~= "MALOWANIA" and self.categories[self.selectedCategory] ~= "MODYFIKATORY" and self.categories[self.selectedCategory] ~= "NEONY" then
				upgrade = self.tableByCategory[self.categories[self.selectedCategory]][self.selectedUpgradeIndex]
				upgradeName, upgradePrice = self:getUpgradeData(upgrade)
				addVehicleUpgrade(self.vehicle, upgrade)

			elseif self.categories[self.selectedCategory] == "MALOWANIA" then
				local paintjob = self.tableByCategory[self.categories[self.selectedCategory]][self.selectedUpgradeIndex]
				upgradeName="ID: "..tostring(paintjob)
				upgradePrice="2000"
				setVehiclePaintjob(self.vehicle, paintjob)
			elseif self.categories[self.selectedCategory] == "KOLOR" then
				upgradeName="WYBÓR KOLORU"
				upgradePrice=0
				if guiCheckBoxGetSelected(checkColor1) then -- 1
					upgradePrice=upgradePrice+250
				end

				if guiCheckBoxGetSelected(checkColor2) then -- 2
					upgradePrice=upgradePrice+500
				end

				if guiCheckBoxGetSelected(checkColor5) then -- swiatla
					upgradePrice=upgradePrice+3000
				end
			elseif self.categories[self.selectedCategory] == "NEONY" then 
				upgradeName = "Montaż neonu"
				upgradePrice = "35000"
			end
			
			r, g,b = 255, 255, 255
			if self.categories[self.selectedCategory] ~= "KOLOR" and self.categories[self.selectedCategory] ~= "MALOWANIA" and self.categories[self.selectedCategory] ~= "MODYFIKATORY" and self.categories[self.selectedCategory] ~= "NEONY" then
				if upgrade == 69 then
					if self.modifiers[4].installed == 1 then 
						r,g,b = 51,204,0
					end
				else
					for k,v in ipairs(self.installedUpgrades) do
						if v == upgrade then
							r,g,b = 51,204,0
						end
					end
				end
			elseif self.categories[self.selectedCategory] == "MALOWANIA" then
				local paintjob = self.tableByCategory[self.categories[self.selectedCategory]][self.selectedUpgradeIndex]
				if self.vehiclePaintjob == paintjob then
					r,g,b = 51,204,0
				end
			end

			if self.categories[self.selectedCategory] == "MODYFIKATORY" then
				local x, y, w, h = 450/zoom, screenH/2-400/zoom/2, 700/zoom, 400/zoom
				exports["ms-gui"]:dxDrawBluredRectangle(x, y, w, h, tocolor(200, 200, 200, 255), true)
				dxDrawText("Modyfikatory", x, y+20/zoom, x+w, y, tocolor(255, 255, 255, 255), 0.8, font, "center", "top", false, false, true, false, false)
				
				-- Przyspieszenie
				local offsetY = 0 
				
				dxDrawText("Przyśpieszenie", x+20/zoom, y+70/zoom+offsetY, x, y, tocolor(255, 255, 255, 255), 0.7, font, "left", "top", false, false, true, false, false)
				local offsetX = 0
				for i=1, 4 do 
					offsetX = (i-1)*(55/zoom)
					if i <= self.modifiers[1] then 
						dxDrawRectangle(x+20/zoom+offsetX, y+100/zoom+offsetY, 50/zoom, 40/zoom, tocolor(51, 102, 255, 220), true)
					else 
						dxDrawRectangle(x+20/zoom+offsetX, y+100/zoom+offsetY, 50/zoom, 40/zoom, tocolor(20, 20, 20, 220), true)
					end
				end
				
				local bx, by, bw, bh = x+20/zoom+offsetX+80/zoom, y+100/zoom+offsetY, 100/zoom, 40/zoom
				if isCursorOnElement(bx, by, bw, bh) then 
					dxDrawRectangle(bx, by, bw, bh, tocolor(51, 102, 255, 255), true)
				else 
					dxDrawRectangle(bx, by, bw, bh, tocolor(51, 102, 255, 200), true)
				end
				dxDrawText("Dodaj", bx, by, bx+bw, by+bh, tocolor(255, 255, 255, 255), 0.65, font, "center", "center", false, false, true, false, false)
				
				local bx, by, bw, bh = x+20/zoom+offsetX+200/zoom, y+100/zoom+offsetY, 100/zoom, 40/zoom
				if isCursorOnElement(bx, by, bw, bh) then 
					dxDrawRectangle(bx, by, bw, bh, tocolor(51, 102, 255, 255), true)
				else 
					dxDrawRectangle(bx, by, bw, bh, tocolor(51, 102, 255, 200), true)
				end
				dxDrawText("Odejmij", bx, by, bx+bw, by+bh, tocolor(255, 255, 255, 255), 0.65, font, "center", "center", false, false, true, false, false)
				
				local upgradePrice = modifiers[1].price * math.max(1, self.modifiers[1]+1)
				if self.modifiers[1] < 4 then
					local priceWidth = dxGetTextWidth(upgradePrice, 1, font)
					dxDrawText("$"..tostring(upgradePrice), x+w-priceWidth-80/zoom, y+97/zoom+offsetY, w, h, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, true, false, false)
				end 
				
				-- Skok pojazdu
				offsetY = offsetY+80/zoom
				dxDrawText("Skok pojazdu", x+20/zoom, y+70/zoom+offsetY, x, y, tocolor(255, 255, 255, 255), 0.7, font, "left", "top", false, false, true, false, false)
				local offsetX = 0
				for i=1, 4 do 
					offsetX = (i-1)*(55/zoom)
					if i <= self.modifiers[2] then 
						dxDrawRectangle(x+20/zoom+offsetX, y+100/zoom+offsetY, 50/zoom, 40/zoom, tocolor(51, 102, 255, 220), true)
					else 
						dxDrawRectangle(x+20/zoom+offsetX, y+100/zoom+offsetY, 50/zoom, 40/zoom, tocolor(20, 20, 20, 220), true)
					end
				end
				
				local bx, by, bw, bh = x+20/zoom+offsetX+80/zoom, y+100/zoom+offsetY, 100/zoom, 40/zoom
				if isCursorOnElement(bx, by, bw, bh) then 
					dxDrawRectangle(bx, by, bw, bh, tocolor(51, 102, 255, 255), true)
				else 
					dxDrawRectangle(bx, by, bw, bh, tocolor(51, 102, 255, 200), true)
				end
				dxDrawText("Dodaj", bx, by, bx+bw, by+bh, tocolor(255, 255, 255, 255), 0.65, font, "center", "center", false, false, true, false, false)
				
				local bx, by, bw, bh = x+20/zoom+offsetX+200/zoom, y+100/zoom+offsetY, 100/zoom, 40/zoom
				if isCursorOnElement(bx, by, bw, bh) then 
					dxDrawRectangle(bx, by, bw, bh, tocolor(51, 102, 255, 255), true)
				else 
					dxDrawRectangle(bx, by, bw, bh, tocolor(51, 102, 255, 200), true)
				end
				dxDrawText("Odejmij", bx, by, bx+bw, by+bh, tocolor(255, 255, 255, 255), 0.65, font, "center", "center", false, false, true, false, false)
				
				local upgradePrice = modifiers[2].price * math.max(1, self.modifiers[2]+1)
				if self.modifiers[2] < 4 then
					local priceWidth = dxGetTextWidth(upgradePrice, 1, font)
					dxDrawText("$"..tostring(upgradePrice), x+w-priceWidth-80/zoom, y+97/zoom+offsetY, w, h, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, true, false, false)
				end 
				
				-- HP
				offsetY = offsetY+80/zoom
				dxDrawText("Dodatkowe HP pojazdu", x+20/zoom, y+70/zoom+offsetY, x, y, tocolor(255, 255, 255, 255), 0.7, font, "left", "top", false, false, true, false, false)
				local offsetX = 0
				for i=1, 4 do 
					offsetX = (i-1)*(55/zoom)
					if i <= self.modifiers[3] then 
						dxDrawRectangle(x+20/zoom+offsetX, y+100/zoom+offsetY, 50/zoom, 40/zoom, tocolor(51, 102, 255, 220), true)
					else 
						dxDrawRectangle(x+20/zoom+offsetX, y+100/zoom+offsetY, 50/zoom, 40/zoom, tocolor(20, 20, 20, 220), true)
					end
				end
				
				local bx, by, bw, bh = x+20/zoom+offsetX+80/zoom, y+100/zoom+offsetY, 100/zoom, 40/zoom
				if isCursorOnElement(bx, by, bw, bh) then 
					dxDrawRectangle(bx, by, bw, bh, tocolor(51, 102, 255, 255), true)
				else 
					dxDrawRectangle(bx, by, bw, bh, tocolor(51, 102, 255, 200), true)
				end
				dxDrawText("Dodaj", bx, by, bx+bw, by+bh, tocolor(255, 255, 255, 255), 0.65, font, "center", "center", false, false, true, false, false)
				
				local bx, by, bw, bh = x+20/zoom+offsetX+200/zoom, y+100/zoom+offsetY, 100/zoom, 40/zoom
				if isCursorOnElement(bx, by, bw, bh) then 
					dxDrawRectangle(bx, by, bw, bh, tocolor(51, 102, 255, 255), true)
				else 
					dxDrawRectangle(bx, by, bw, bh, tocolor(51, 102, 255, 200), true)
				end
				dxDrawText("Odejmij", bx, by, bx+bw, by+bh, tocolor(255, 255, 255, 255), 0.65, font, "center", "center", false, false, true, false, false)
				
				local upgradePrice = modifiers[3].price * math.max(1, self.modifiers[3]+1)
				if self.modifiers[3] < 4 then
					local priceWidth = dxGetTextWidth(upgradePrice, 1, font)
					dxDrawText("$"..tostring(upgradePrice), x+w-priceWidth-80/zoom, y+97/zoom+offsetY, w, h, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, true, false, false)
				end 
				
				dxDrawText("Odjęcie modyfikatora zwróci ci 50% jego ceny.", x, y+h-50/zoom, x+w, h, tocolor(255, 255, 255, 255), 0.7, font, "center", "top", false, false, true, false, false)
			else
				local upgradePrice = "$"..tostring(upgradePrice)
				
				local w = dxGetTextWidth(upgradeName, 0.8, font)+dxGetTextWidth(upgradePrice, 0.8, font)+60/zoom
				local x, y, h = screenW-w-50/zoom, screenH-100/zoom, 75/zoom
				exports["ms-gui"]:dxDrawBluredRectangle(x, y, w, h, tocolor(200, 200, 200, 255), true)
			
				dxDrawText(tostring(upgradeName), x+20/zoom, y, w, y+h, tocolor(r, g, b, 255), 0.8, font, "left", "center", false, false, true, false, false)
				dxDrawText(upgradePrice, x+w-dxGetTextWidth(upgradePrice, 0.8, font)-20/zoom, y, w, y+h, tocolor(51, 102, 255, 220), 0.8, font, "left", "center", false, false, true, false, false)
			end
		end

		local x, y, w, h = screenW-350/zoom, screenH/2-300/zoom, 300/zoom, dxGetFontHeight(0.85, font)+5/zoom
		for k, v in ipairs(self.categories) do
			y = y+h
			
			exports["ms-gui"]:dxDrawBluredRectangle(x, y, w, h, tocolor(200, 200, 200, 255))
			if self.selectedCategory == k then 
				dxDrawRectangle(x, y, w, h, tocolor(51, 102, 255, 200), true)
			end
			dxDrawText(v, x+20/zoom, y, x+w, y+h, tocolor(255, 255, 255, 255), 0.7, font, "left", "center", false, false, true)
		end
		
		local money = getElementData(localPlayer, "player:money") or 0
		dxDrawText("$".. money .."", 50/zoom+1, 75/zoom+1, 100/zoom, 0, tocolor(0, 0, 0, 255), 1.00, font, "left", "top", false, false, false, false, false)
		dxDrawText("$".. money .."", 50/zoom, 75/zoom, 100/zoom, 0, tocolor(51,204,0, 255), 1.00, font, "left", "top", false, false, false, false, false)
		
		local x, y, w, h = screenW-500/zoom, 50/zoom, 450/zoom, 105/zoom
		exports["ms-gui"]:dxDrawBluredRectangle(x, y, w, h, tocolor(200, 200, 200, 255), true)
		--dxDrawRectangle(x, y+h, w, 3/zoom, tocolor(51, 102, 255, 255), true)
		dxDrawText("#3366FFSTRZAŁKI #FFFFFF- wybór części/kategorii \n#3366FFENTER #FFFFFF- kupno części/sprzedaż za pół ceny\n#3366FFESC#FFFFFF - wyjście", x, y+15/zoom, x+w, y+h, tocolor(255, 255, 255, 255), 0.6, font, "center", "top", false, false, true, true, false)
	end,
}

--obj = createObject(8553, 1415, -18.794, 999)
--setElementRotation(obj, 92, 266, 4)

function onPlayerShowTuneShop(vehicle, id)
	tuneShop = CTuneShop(vehicle, id)
end
addEvent("onPlayerShowTuneShop", true)
addEventHandler("onPlayerShowTuneShop", root, onPlayerShowTuneShop)

addEventHandler("onClientResourceStop", resourceRoot, function()
	if tuneShop then 
		tuneShop:destroy()
	end
end)

function isCursorOnElement(x,y,w,h)
	if not isCursorShowing() then return end
	local mx,my = getCursorPosition ()
	local fullx,fully = guiGetScreenSize()
	cursorx,cursory = mx*fullx,my*fully
	if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
		return true
	else
		return false
	end
end