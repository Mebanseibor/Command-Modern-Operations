    local _list = VP_GetSide({side=ScenEdit_PlayerSide()}):unitsBy("Aircraft")
    for k,aircraft in pairs(_list) do
        local aircraft_obj = ScenEdit_GetUnit({guid=aircraft.guid})
        local _fuel = aircraft_obj.fuel
        _fuel[2001].current=aircraft_obj.fuel[2001].max
        aircraft_obj.fuel = _fuel
        print("")
    end