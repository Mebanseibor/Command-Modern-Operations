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
    
    -- Given angles of two vectors
    local contact_angle = (90 - _contact.heading) % 360
    local unit_angle = (90 - _unit.heading) % 360

    -- Convert angles to radians
    local contact_radians = math.rad(contact_angle)
    local unit_radians = math.rad(unit_angle)

    -- Calculate x and y components of each vector
    local contact_x = math.cos(contact_radians)
    local contact_y = math.sin(contact_radians)

    local unit_x = math.cos(unit_radians)
    local unit_y = math.sin(unit_radians)

    -- Sum the x and y components
    local resultant_x = contact_x + unit_x
    local resultant_y = contact_y + unit_y

    -- Calculate the magnitude of the resultant vector
    local magnitude = math.sqrt(resultant_x^2 + resultant_y^2)

    -- Calculate the angle of the resultant vector
    local resultant_angle = math.deg(math.atan2(resultant_y, resultant_x))

    -- Ensure angle is between 0 and 360 degrees
    if resultant_angle < 0 then
        resultant_angle = resultant_angle + 360
    end

    -- Print the resultant vector
    print("Resultant Vector:")
    printv("Magnitude:", magnitude)
    printv("Angle:", resultant_angle)
end
su_sc()
print("-----DONE-----")
print("")Command_SaveScen(FullPath)