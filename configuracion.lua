--Manejo de cadenas JSON (necesita sjson)
print("iniciando configuracion.lua")
configjson={}
function inserta(nombre,valor)--crea un nuevo par key-valor
configjson[nombre] = valor
guarda()
end
function guarda()--guarda datos en datos.dat
datos=file.open("datos.dat","w+")
datos:write(sjson.encode(configjson))
datos:close()
end
function recupera()--recupera datos de datos.dat
datos=file.open("datos.dat","r")
configjson=sjson.decode(datos:read())
datos:close()
end
function elimina(nombre)--elimina par key-valor
configjson[nombre]=nil
guarda()
end
function muestra()--muestra todas las variables
for k,v in pairs(configjson) do 
print(k.." = '"..v.."'")

end
end
function convierte()--convierte a variables todos los pares key-valor
for k,v in pairs(configjson) do 
assert(loadstring(k.." = '"..v.."'"))()

end
end
