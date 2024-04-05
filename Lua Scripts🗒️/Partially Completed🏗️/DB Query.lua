local function a()
    for k,v in pairs(ScenEdit_QueryDB( 'sensor', 1398 ).fields) do
        print(k.."\t"..v)
    end
    print(ScenEdit_QueryDB( 'sensor', 1398 ).name)
end