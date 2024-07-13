# Tools for Command: Modern Operations

## Command Modern Operations AHK⌨️
- ### Purpose:
&emsp; It is an Autohotkey Script, that enables players with small keyboards or with no Numpad to press the hard-to-reach key combinations.

- ### Instructions:
    1. Install [Autohotkey][weblink-autohotkey-homepage] <!--Proceed to autohotkey.com Homepage-->
    2. Run the script (Note: if the key mapped key combination does not work, run the script in Administrator mode)


    
- ### Keys Mapped:
    | Key Combination       | Action            |
    | --------------------- | ----------------- |
    | `space` + `d`         | Doctrine window   |
    | `space` + `s`         | Sensor window     |
    | `space` + `w`         | Mission window    |
    | `space` + `a`         | Manual Attack     |
    | `space` + `q`         | Switch sides      |
    
    
    -----Base Modifier Key-----
    ```Autohotkey
    if(GetKeyState(space) == "D")
        space::space
        return
    ```
    \---------------------------
    Note:
        &emsp;The chosen base modifier key 'space', won't be able to send continuos signals to the device until the script is terminated

[weblink-autohotkey-homepage]: https://www.autohotkey.com/