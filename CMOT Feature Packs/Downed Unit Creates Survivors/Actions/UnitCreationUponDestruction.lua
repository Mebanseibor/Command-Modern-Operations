--[[
    Development Notes:
        -Survivor probablity depends on:
            - Unit's Fired upon status
            - Unit's Out-of-fuel status
            - Unit's Proficiency
            - Number of crew
                - Use "_unit.crew"
        - Survived pilots/passengers are created within a close proximity from the wreckage
        Future enhancements:
            - What about paratroppers or soldiers that were in the aircraft?
            - Handle for events that happen over-water
                - Aircraft don't have lift rafts right?
        DBIDs:
            2046 Stranded Personnel (1x)
            2441 Stranded Personnel (1x, Immobile)
            3135 Stranded Personnel (5x)
            3136 Stranded Personnel (10x)
    
    
    
    Indicators:
        Down Aircraft:
            2350, Marker (Aircraft Wreckage)
        Survivor:
            414, Marker (Extraction Zone)
            2441, Stranded Personnel (1x, Immobile)
    Code Infomation:
        Base Probability
        Wreckage Probabilty
        Survival Probability
]]--





--<<Objects and other information>>--
local _unit = ScenEdit_UnitX()
local _proficiency = _unit.proficiency
local is_OutOfFuel = (_unit.fuel[2001].current<=1) --fuel[2001] is aviation fuel



--<<Probabilities>>--
local base_probability = 0.5
local wreckage_probability = 0.20
local prob_proficiency = 0.0
local prob_OutOfFuel = 0.6



--<<Values and Thresholds>>--
--factors--
local factor_proficiency = 1.0

--survivor distance from wreckage
local min_distance_from_wreckage = 0.5    --in nm
local max_distance_from_wreckage = 1.5    --in nm
local distance_decimal_place = 10


--proficiencies--
local prob_proficiency_Novice = 0.1
local prob_proficiency_Cadet = 0.2
local prob_proficiency_Regular = 0.3
local prob_proficiency_Veteran = 0.5
local prob_proficiency_Ace = 0.6



--<<Calculations>>--
--Out of fuel
if is_OutOfFuel then
    wreckage_probability = wreckage_probability + prob_OutOfFuel
end
--proficiency
if _proficiency == "Novice" then
    prob_proficiency = prob_proficiency_Novice
elseif _proficiency == "Cadet" then
    prob_proficiency = prob_proficiency_Cadet
elseif _proficiency == "Regular" then
    prob_proficiency = prob_proficiency_Regular
elseif _proficiency == "Veteran" then
    prob_proficiency = prob_proficiency_Veteran
elseif _proficiency == "Ace" then
    prob_proficiency = prob_proficiency_Ace
end
prob_proficiency = prob_proficiency*factor_proficiency





local function Create_Wreckage()
    local random_number = math.random()
    if random_number <= wreckage_probability then

        -- Delete older wreckage if AircraftWreckageLimit is reached (if any)
            if #CMOT_SAR_AircraftWreckageList==CMOT_SAR_AircraftWreckageLimit then
                ScenEdit_DeleteUnit(CMOT_SAR_AircraftWreckageList[1])
                table.remove(CMOT_SAR_AircraftWreckageList, 1)
            end

        
        -- Create Aircraft Wreckage
            local _unit = ScenEdit_UnitX()
            local _table = {}
            _table.type = "Facility"
            _table.unitname = "Aircraft Wreckage of ".._unit.name
            _table.side = CMOT_SAR_SARSide
            _table.dbid = 2350
            _table.latitude = _unit.latitude
            _table.longitude = _unit.longitude
            _table.altitude = World_GetElevation({latitude = _unit.latitude, longitude=_unit.longitude})

            local _unit = ScenEdit_AddUnit(_table)
            _unit.autodetectable = false

        --Add the created Aircraft Wreckage to CMOT_SAR_AircraftWreckageList
            local _table = {}
            _table.guid = _unit.guid
            table.insert(CMOT_SAR_AircraftWreckageList, _table)
    end
end

local function Create_Survivor()
    local function RandomPoint(_latitude, _longitude, min, max, DecimalPlaces)   --DecimalPlaces is meant for conversion float values to Decimal by multiplication
        local _table = {}
        _table.latitude = _latitude
        _table.longitude = _longitude
        _table.distance = math.random(min, max)/DecimalPlaces
        _table.bearing = math.random(0,359)
        return World_GetPointFromBearing (_table)
    end

    --Conditions to not create any survivor:
    if(_unit.crew==0)then return end

    local random_number = math.random()
    if random_number <= prob_proficiency+wreckage_probability then
        local _table={}
        _table.type = "Facility"
        _table.unitname = "Survivor from ".._unit.name
        _table.side = CMOT_SAR_SARSide
        _table.dbid = 2441  --Personel
        local random_point = RandomPoint(_unit.latitude, _unit.longitude, min_distance_from_wreckage*distance_decimal_place, max_distance_from_wreckage*distance_decimal_place, distance_decimal_place)
        _table.latitude = random_point.latitude
        _table.longitude = random_point.longitude
        _table.altitude = World_GetElevation(random_point)
        local unit_Survivor = ScenEdit_AddUnit(_table)
        unit_Survivor.autodetectable = false

        -- for Extraction marker
        local unit_Marker = nil
        if true then
            _table.unitname = "Survivor Smoke Bomb"
            _table.dbid = 414
            local random_point = RandomPoint(unit_Survivor.latitude, unit_Survivor.longitude, 0.3, 0.5, 10)
            _table.latitude = random_point.latitude
            _table.longitude = random_point.longitude
            _table.altitude = World_GetElevation(random_point)
            unit_Marker = ScenEdit_AddUnit(_table)
            unit_Marker.autodetectable = false
        end
        table.insert(CMOT_SAR_Aircraft_SurvivorList, {survivor=unit_Survivor.guid, marker=unit_Marker.guid})
        KeyStore_SetTable("CMOT_SAR_Aircraft_SurvivorList", CMOT_SAR_Aircraft_SurvivorList)
    end
end

--<<Final Calculation>>--
local random_number = math.random()
if random_number<=base_probability then
    Create_Wreckage()
    Create_Survivor()
end