# Command-Modern-Operations
Command: Modern Operations Resources


Command Modern Operations AHK⌨️
    It is an Autohotkey Script, that maps enables players with small keyboards or with no Numpad to press the hard-to-reach key combinations.
    Instructions:
        -Install Autohotkey (https://www.autohotkey.com/)
        -Run the script (Note: if the key mapped key combination does not work, run the script in Administrator mode)
    -Keys Mapped:
        space+d     doctrine window
        space+s     sensor window
        space+w     mission window
        space+a     manual attack
        space+q     switch sides
    -----Base Modifier Key-----
    if(GetKeyState(space) == "D")
        space::space
        return
    ----------------------------
    Note:
        -The chosen base modifier key 'space', won't be able to send continuos signals to the device until the script is terminated
