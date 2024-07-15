local function _1v1()
    ScenEdit_AddSide({side="Blue"})
    ScenEdit_AddSide({side="Red"})
    ScenEdit_AddSide({side="SAR"})
    ScenEdit_SetSidePosture("Blue", "Red", "H")
    ScenEdit_SetSidePosture("Blue", "SAR", "N")
    ScenEdit_SetSidePosture("Red", "Blue", "H")
    ScenEdit_SetSidePosture("Red", "SAR", "N")
end

local function ScenTime_Long()
end

local function Import_inst()
end


local function RealisticCommunication()
end




-----*****DRIVER CODE*****-----
_1v1()
ScenTime_Long()
Import_inst()
RealisticCommunication()
-------------------------------