--[[
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
]]--

--<<Objects and other information>>--
local unit = {}
unit.x = ScenEdit_UnitX()

local probability = {}
probability.base = 0.50

probability.survival = {}
probability.survival.base = 0.0
probability.survival.final = 0.0
probability.survival.outOfFuel = 0.60
probability.survival.proficiency = 0.0

probability.wreckage = {}
probability.wreckage.base = 0.40
probability.wreckage.final = 0.0
probability.wreckage.outOfFuel = 0.80

probability.proficiency = {}
probability.proficiency.factor = 1.0
probability.proficiency.novice = 0.1
probability.proficiency.cadet = 0.2
probability.proficiency.regular = 0.3
probability.proficiency.veteran = 0.5
probability.proficiency.ace = 0.6

probability.check = {}
function probability.check.outOfFuel()
    if (unit.x.fuel[2001].current <=1 ) then
        probability.survival.final = probability.survival.final + probability.survival.outOfFuel
        probability.wreckage.final = probability.wreckage.final + probability.wreckage.outOfFuel
    end
end



distance = {}
distance.fromWreckageToSurvivor = {}
distance.fromWreckageToSurvivor.min = 0.5       -- in nm
distance.fromWreckageToSurvivor.max = 1.5       -- in nm

distance.fromSurvivorToMarker = {}
distance.fromSurvivorToMarker.min = 0.3         -- in nm
distance.fromSurvivorToMarker.max = 0.5         -- in nm





--<<Unit Creation>>--
local create = {}
function create.wreckage()
    if (math.random() < probability.wreckage.final) then return end

    -- remove oldest aircraft wreckage if the aircraft wreckage limit is reached
    if CMOT.SAR.wreckage.size() == CMOT.SAR.wreckage.limit then
        ScenEdit_DeleteUnit(CMOT.SAR.wreckage.list[1])
        table.remove(CMOT.SAR.list.wreckage.list, 1)
    end

    -- Create Aircraft Wreckage
    local properties = {}
    properties.type = "Facility"
    properties.unitname = "Aircraft Wreckage of ".. unit.x.name
    properties.side = CMOT.SAR.side.searchAndRescue
    properties.dbid = 2350
    properties.latitude = unit.x.latitude
    properties.longitude = unit.x.longitude
    properties.altitude = World_GetElevation({latitude = unit.x.latitude, longitude=unit.x.longitude})

    unit.wreckage = ScenEdit_AddUnit(properties)
    unit.wreckage.autodetectable = false

    -- Add info about the recently created aircraft wreckage to CMOT.SAR.wreckage.list
    local info = {}
    info.guid = unit.wreckage.guid
    table.insert(CMOT.SAR.wreckage.list, info)
    KeyStore_SetTable("CMOT.SAR.wreckage.list", CMOT.SAR.wreckage.list)
end

function create.survivor()
    if (math.random() < probability.survival.final) then return end

    local function randomPointFromUnit(unit, distance)
        local properties = {}
        properties.latitude = unit.latitude
        properties.longitude = unit.longitude
        properties.distance = math.random(distance.min, distance.max)
        properties.bearing = math.random(0,359)
        return World_GetPointFromBearing (properties)
    end

    -- conditions to not create any survivor:
    if(unit.x.crew == 0)then return end
    
    -- creation of unit
    local randomPoint = randomPointFromUnit(unit.x, distance.fromWreckageToSurvivor)
    local properties = {}
    properties.type = "Facility"
    properties.unitname = "Survivor from ".. unit.x.name
    properties.side = CMOT.SAR.side.searchAndRescue
    properties.dbid = 2441  -- personel
    properties.latitude = randomPoint.latitude
    properties.longitude = randomPoint.longitude
    properties.altitude = World_GetElevation(randomPoint)
    
    unit.survivor = ScenEdit_AddUnit(properties)
    unit.survivor.autodetectable = false

    
    
    -- creation of extraction marker
    local randomPoint = randomPointFromUnit(unit.survivor, distance.fromSurvivorToMarker)
    local properties = {}
    properties.unitname = "Survivor Smoke"
    properties.dbid = 414
    properties.latitude = randomPoint.latitude
    properties.longitude = randomPoint.longitude
    properties.altitude = World_GetElevation(randomPoint)
    
    unit.marker = ScenEdit_AddUnit(properties)
    unit.marker.autodetectable = false
    
    
    
    -- adding the survivor-marker pair to CMOT.SAR.survivor.list
    local survivorPair = {}
    survivorPair.survivor = unit.survivor.guid
    survivorPair.marker = unit.marker.guid
    table.insert(CMOT.SAR.survivor.list, survivorPair)
    KeyStore_SetTable("CMOT.SAR.survivor.list", CMOT.SAR.survivor.list)
end



-----<<//Driver Code>>-----
-- calculate probability accounting for unit's proficiency
for k, v in pairs(probability.proficiency) do
    if k == unit.x.proficiency then
        probability.survival.proficiency = probability.proficiency.factor * v
    end
end

-- calculate probability accounting for any out-of-fuel status
probability.check.outOfFuel()

-- calculate probability final
probability.survival.final = probability.survival.base + probability.survival.proficiency

-- create units based on probability.base
if(probability.base <= math.random()) then
    create.wreckage()
    create.survivor()
end
-----<<//Driver Code>>-----