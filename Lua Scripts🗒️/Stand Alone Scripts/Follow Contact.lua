--Tool_Bearing ( fromHere, toHere)
--Tool_Range (fromHere, toHere [,useSlant])
--World_GetPointFromBearing ( table )

local function su_sc()
    local _objects = ScenEdit_SelectedUnits()
    if is_empty(_objects.units) then
        error("No Units (Player units) was Selected",1)
    elseif is_empty(_objects.contacts) then
        error("No Contacts was Selected",1)
    end
    local units=_objects.units
    local contacts=_objects.contacts
    if #units~=1 or #contacts~=1 then
        error("Select ONLY 1 Unit and 1 Contact",1)
    end
    local _unit=ScenEdit_GetUnit({guid=units[1].guid})
    local _contact=VP_GetContact({guid=contacts[1].guid})
    local contact_latitude=_contact.latitude
    local contact_longitude=_contact.longitude
    printv("lat",contact_latitude)
    printv("long",contact_longitude)
    
    local _bearing = Tool_Bearing (_unit.guid,_contact.guid)
    printv("Move to bearing",_bearing)

    local range_m = Tool_Range (_unit.guid, _contact.guid)*1852
    printv("Range to target (in meters)",range_m)

    local way_point = {latitude=contact_latitude,longitude=contact_longitude, type="ManualPlottedCourseWaypoint"}
    ScenEdit_SetUnit({guid=_unit.guid, course={way_point}})
    
    local speed_mps = _unit.speed/1.94384
    printv("Speed (in mps)",speed_mps)

    local time_to_waypoint=range_m/speed_mps
    print("Seconds to waypoint: "..time_to_waypoint.."(~"..(time_to_waypoint/60).." minutes)")
    
    local contact_angle=(90-_contact.heading)%360
    printv("Contact Angle",contact_angle)

    local unit_angle=(90-_unit.heading)%360
    printv("Contact Angle",unit_angle)

    local contact_radians = math.rad(contact_angle)
    printv("Contact Radians",contact_radians)

    local unit_radians = math.rad(unit_angle)
    printv("Unit Radians",unit_radians)

    local contact_cos=math.cos(contact_radians)
    printv("Contact cos",contact_cos)
    local contact_sin=math.sin(contact_radians)
    printv("Contact sin",contact_sin)

    local unit_cos=math.cos(unit_radians)
    printv("Unit cos",unit_cos)
    local unit_sin=math.sin(unit_radians)
    printv("Unit sin",unit_sin)

    printv("Sum of Cos",contact_cos+unit_cos)
    printv("Sum of Sin",contact_sin+unit_sin)
end
su_sc()
print("-----DONE-----")
print("")Command_SaveScen(FullPath)