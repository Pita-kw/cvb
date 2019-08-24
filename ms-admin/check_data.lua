local check = {"player:rank", "player:premium", "player:exp", "player:level", "player:money", "player:sp"} -- dane do sprawdzania czy gracz nie manipuluje

addEventHandler( "onElementDataChange", root,
	function( name, old )
		if client then
			for k,v in ipairs(check) do
				if v == tostring(name) then
					if getElementData(client, "player:rank") == 3 then return end 
					
					-- nie można używać banMSPlayer bo to też może czasem zmanipulować
					banPlayer( client, true, false, true, "System", "Manipulowanie danymi (Element: " .. tostring( source ) .. ", name = " .. tostring( name ) .. ", value = " .. tostring( getElementData( source, name ) ) .. ", old = " .. tostring( old ) .. ")" )

					if isElement( source ) then
						if old == nil then
							removeElementData( source, name )
						else
							setElementData( source, name, old )
						end
					end
				end

			end
		end
	end
)
