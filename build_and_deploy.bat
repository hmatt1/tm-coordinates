"C:\Program Files\7-Zip\7z.exe" a -tzip "Coordinates.op" "*"
del "C:\Users\matth\OpenplanetNext\Plugins\Coordinates.op"
move "Coordinates.op" "C:\Users\matth\OpenplanetNext\Plugins\Coordinates.op"

:: Get-Content -Path "C:\Users\matth\OpenplanetNext\Openplanet.log" -Wait