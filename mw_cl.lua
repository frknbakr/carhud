
local screenPosX = 0.165                  
local screenPosY = 0.882                   

local enableController = true              

local speedLimit = 150.0                   
local speedColorText = {255, 255, 255}     
local speedColorUnder = {255, 255, 255}     
local speedColorOver = {255, 96, 96}       
local speedTextScale = {0.5, 0.5}

local fuelShowPercentage = false           
local fuelWarnLimit = 20.0                
local fuelColorText = {255, 255, 255}      
local fuelColorOver = {255, 255, 255}      
local fuelColorUnder = {255, 96, 96}      
local fuelTextScale = {0.5, 0.5}

local seatbeltInput = 311                 
local seatbeltPlaySound = true              
local seatbeltDisableExit = true           
local seatbeltEjectSpeed = 65.13          
local seatbeltEjectAccel = 60.0            
local seatbeltColorOn = {160, 255, 160, 0}   
local seatbeltColorOff = {255, 96, 96, 0}     

local cruiseInput = 246                   
local cruiseColorOn = {160, 255, 160, 0}      
local cruiseColorOff = {255, 255, 255, 0}      

local locationAlwaysOn = false              
local locationColorText = {255, 255, 255}   

 local directions = { [0] = 'Kuzey', [1] = 'Kuzey Batı', [2] = 'Batı', [3] = 'Güney Batı', [4] = 'Güney', [5] = 'Güney Dogu', [6] = 'Dogu', [7] = 'Kuzey Dogu', [8] = 'Kuzey' } 
 local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }

local pedInVeh = false
local timeText = ""
local locationText = ""
local currentFuel = 0.0

Citizen.CreateThread(function()
    local currSpeed = 0.0
    local cruiseSpeed = 999.0
    local prevVelocity = {x = 0.0, y = 0.0, z = 0.0}
    local cruiseIsOn = false
    local seatbeltIsOn = false

    while true do
        Citizen.Wait(0)

        local player = PlayerPedId()
        local position = GetEntityCoords(player)
        local vehicle = GetVehiclePedIsIn(player, false)

        if IsPedInAnyVehicle(player, false) then
            pedInVeh = true
        else
            pedInVeh = false
            cruiseIsOn = false
        end
        
        if pedInVeh or locationAlwaysOn then
            drawTxt(timeText, 4, locationColorText, 0.36, screenPosX, screenPosY + 0.028)
            drawTxt(locationText, 4, locationColorText, 0.4, screenPosX, screenPosY + 0.076)
            local vehicleClass = GetVehicleClass(vehicle)
            if pedInVeh and GetIsVehicleEngineRunning(vehicle) and vehicleClass ~= 13 then
                local prevSpeed = currSpeed
                currSpeed = GetEntitySpeed(vehicle)
                SetPedConfigFlag(PlayerPedId(), 32, true)
            
                if IsControlJustReleased(0, seatbeltInput) and (enableController or GetLastInputMethod(0)) and vehicleClass ~= 8 then
                    if not seatbeltIsOn then
                        exports['mythic_notify']:SendAlert('success', 'Kemer Takıldı')
                        else
                        exports['mythic_notify']:SendAlert('error', 'Kemer Çıkartıldı')
                        end
                    seatbeltIsOn = not seatbeltIsOn
                    if seatbeltPlaySound then
                        PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
                    end
               	end
                if not seatbeltIsOn then
                    local vehIsMovingFwd = GetEntitySpeedVector(vehicle, true).y > 1.0
                    local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()
                    if not seatbeltIsOn and (vehIsMovingFwd and (prevSpeed > (seatbeltEjectSpeed/45.2)) and (vehAcc > (seatbeltEjectAccel*25.0))) then
                        SetEntityCoords(player, position.x, position.y, position.z - 0.47, true, true, true)
                        SetEntityVelocity(player, prevVelocity.x, prevVelocity.y, prevVelocity.z)
                        Citizen.Wait(1)
                        SetPedToRagdoll(player, 1000, 1000, 0, 0, 0, 0)
                    else
                        prevVelocity = GetEntityVelocity(vehicle)
                    end
                elseif seatbeltDisableExit then
                    DisableControlAction(0, 75)
                end
                if (GetPedInVehicleSeat(vehicle, -1) == player) then
                    if IsControlJustReleased(0, cruiseInput) and (enableController or GetLastInputMethod(0)) then
                        cruiseIsOn = not cruiseIsOn
                        if cruiseIsOn then
                            exports['mythic_notify']:SendAlert('success', 'Hız Sabitlendi')
                            elseif not curiseIsOn then
                            exports['mythic_notify']:SendAlert('error', 'Hız Sabitlemesi Kaldırıldı')
                            end
                        cruiseSpeed = currSpeed
                    end
                    local maxSpeed = cruiseIsOn and cruiseSpeed or GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
                    SetEntityMaxSpeed(vehicle, maxSpeed)
                else

                    cruiseIsOn = false
                end

                if GetPedInVehicleSeat(vehicle, -1) then
                    if ShouldUseMetricMeasurements() then
                        local speed = currSpeed*3.6
                        local speedColor = (speed >= speedLimit) and speedColorOver or speedColorUnder
                        drawTxt(("%.3d"):format(math.ceil(speed)), 2, speedColor, 0.49, screenPosX + 0.000, screenPosY + 0.050)
                        drawTxt("KMH", 2, speedColorText, 0.3, screenPosX + 0.018, screenPosY + 0.059)
                    else
                        local speed = currSpeed*3.6
                        local speedColor = (speed >= speedLimit) and speedColorOver or speedColorUnder
                        drawTxt(("%.3d"):format(math.ceil(speed)), 2, speedColor, 0.49, screenPosX + 0.000, screenPosY + 0.050)
                        drawTxt("KMH", 2, speedColorText, 0.3, screenPosX + 0.018, screenPosY + 0.059)
                    end
                    
                    local fuelColor = (currentFuel >= fuelWarnLimit) and fuelColorOver or fuelColorUnder
                    drawTxt(("%.3d"):format(math.ceil(currentFuel)), 4, fuelColor, 0.49, screenPosX + 0.035, screenPosY + 0.050)
                    drawTxt("BENZIN", 2, fuelColorText, 0.3, screenPosX + 0.053, screenPosY + 0.057)
                else
                    if ShouldUseMetricMeasurements() then
                        local speed = currSpeed*3.6
                        local speedColor = (speed >= speedLimit) and speedColorOver or speedColorUnder
                        drawTxt(("%.3d"):format(math.ceil(speed)), 2, speedColor, 0.49, screenPosX + 0.000, screenPosY + 0.050)
                        drawTxt("KMH", 2, speedColorText, 0.3, screenPosX + 0.018, screenPosY + 0.059)
                    else
                        local speed = currSpeed*3.6
                        local speedColor = (speed >= speedLimit) and speedColorOver or speedColorUnder
                        drawTxt(("%.3d"):format(math.ceil(speed)), 2, speedColor, 0.49, screenPosX + 0.000, screenPosY + 0.050)
                        drawTxt("KMH", 2, speedColorText, 0.3, screenPosX + 0.018, screenPosY + 0.059)
                    end
                end
                  
                 local cruiseColor = cruiseIsOn and cruiseColorOn or cruiseColorOff
                 if CruiseIsOn == true then
                     ESX.ShowHelpNotification('Hız sabitleyici aktif.')
                 end  

                if vehicleClass ~= 8 then
                    local seatbeltColor = seatbeltIsOn and seatbeltColorOn or seatbeltColorOff
                    drawTxt("KEMER", 2, seatbeltColor, 0.4, screenPosX + 0.077, screenPosY + 0.053)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if pedInVeh or locationAlwaysOn then
            local player = PlayerPedId()
            local position = GetEntityCoords(player)

            local hour = GetClockHours()
            local minute = GetClockMinutes()
            timeText = ("%.2d"):format((hour == 0) and 24 or hour) .. ":" .. ("%.2d"):format( minute) .. ((hour < 24) and " " or " ")

            local heading = directions[math.floor((GetEntityHeading(player) + 22.5) / 45.0)]
            local zoneNameFull = zones[GetNameOfZone(position.x, position.y, position.z)]
            local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(position.x, position.y, position.z))
            
            locationText = heading
            locationText = (streetName == "" or streetName == nil) and (locationText) or (locationText .. " | " .. streetName)
            locationText = (zoneNameFull == "" or zoneNameFull == nil) and (locationText) or (locationText .. " | " .. zoneNameFull)

            if pedInVeh then
                local vehicle = GetVehiclePedIsIn(player, false)
                if fuelShowPercentage then

                    currentFuel = 100 * GetVehicleFuelLevel(vehicle) / GetVehicleHandlingFloat(vehicle,"CHandlingData","fPetrolTankVolume")
                else

                    currentFuel = GetVehicleFuelLevel(vehicle)
                end
            end
            Citizen.Wait(19000)
        else
            Citizen.Wait(0)
        end
    end
end)

function drawTxt(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1],colour[2],colour[3], 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end
