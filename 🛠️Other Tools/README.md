<h2>Tools for Command: Modern Operations</h2>
<ol type="1">
    <li>Command Modern Operations AHK⌨️</li>
    <h4>Purpose:</h4>
    &Tab; It is an Autohotkey Script, that enables players with small keyboards or with no Numpad to press the hard-to-reach key combinations.
    <br>
    <br>
    <h4>Instructions:</h4>
    <ol name="AHK Instructions" type="1">
        <li>Install <a href="https://www.autohotkey.com/" name="Proceed to autohotkey.com Homepage" target="_blank">Autohotkey</a></li>
        <li>Run the script (Note: if the key mapped key combination does not work, run the script in Administrator mode)</li>
    </ol>
    <h4>Keys Mapped:</h4>
    <table>
        <tr>
            <th>Key Combination</th>
            <th>Action</th>
        </tr>
        <tr>
            <td>space+d</td>
            <td>Doctrine window</td>
        </tr>
        <tr>
            <td>space+s</td>
            <td>Sensor window</td>
        </tr>
        <tr>
            <td>space+w</td>
            <td>Mission window</td>
        </tr>
        <tr>
            <td>space+a</td>
            <td>Manual attack</td>
        </tr>
        <tr>
            <td>space+q</td>
            <td>Switch sides</td>
        </tr>
    </table>
        <br>
        <br>
    <p>
    <code>-----Base Modifier Key-----<br>
    if(GetKeyState(space) == "D")<br>
        space::space<br>
        return<br>
    -------------------------------</code><br>
    </p>
    <br>
    <h4>Note:</h4>
        <p>&Tab;The chosen base modifier key 'space', won't be able to send continuos signals to the device until the script is terminated<br>
        </p>
