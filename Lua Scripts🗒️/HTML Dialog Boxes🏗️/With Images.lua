msg = [[
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Image with Absolute Path</title>
</head>
<body>
    <h1>Image with Absolute Path</h1>
    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREToJiMEaIJeA1rkWfpJHLA68hNNoJAbQlca_5LDSVhw&s" alt="Radar Image">
</body>
</html>

]]
local a = UI_CallAdvancedHTMLDialog("Logistics", msg, {"Submit","Cancel"})
print(TOSTRING(a))
