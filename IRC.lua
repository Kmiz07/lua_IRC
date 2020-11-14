    bufer={}
    conectados={}
    procesando= false
    cliente=net.createConnection (net.TCP,0) 
    print("Socket conectado: "..tostring(cliente))   
    
function conectado(cliente)
    NICK="MCUIRC"..node.random(999)
    print("conectado "..tostring(cliente)) 
    cliente:send("NICK "..NICK.."\n")
    cliente:send("USER uno dos tres : cuatro\n")
end

function inPRIVMSG(org,msg)
    x,y,orgNICK,orgNOMBRE,orgIP=string.find(org,"(%w+)!~(%w+)@(.+)")
    x,y,msgDEST,msgMSG=string.find(msg,"(#?%w+)%s:([À-ÿ%Ñ%ñ.%a%c%s%d%l%p%w]+)")
    print(orgNICK.." >> "..msgDEST.." >> "..msgMSG)
end

function desglosa()
    while procesando==false and #bufer>0 do
        a,b,origen,comando,resto=string.find(table.remove(bufer,1),"([%w%p]+)%s([%w%p]+)%s([À-ÿ%Ñ%ñ.%a%c%s%d%l%p%w]+)")
        print("Origen: ",origen) 
        print("Comando: ",comando)
        print("Resto: ",resto)
        print("\n")
        if comando=="376" then --termino el arranque y inicio canal
            cliente:send("JOIN "..canal.."\n")
        end
        if comando=="366" then  --pongo pass al canal
            cliente:send("MODE "..canal.." +k "..passcanal.."\n") 
        end
        --Comando=PRIVMSG mensaje de texto de entrada ya sea por privado o por canal dependiendo del origen
        if comando=="PRIVMSG" then inPRIVMSG(origen,resto) end
        --Comando=JOIN. nuevo user en canal. Tambien en el momento de entrar yo. Actualizo lista de users
        if comando=="JOIN" then table.insert(conectados,string.match(origen,":(%w+)!")) end
        --Comando=PART. User sale del canal, tambien si salgo yo. Actualizo lista de users
        if comando=="PART" or comando=="QUIT"then
            for x=1,#conectados-1 do
                if conectados[x]==string.match(origen,":(%w+)!") then table.remove(conectados,x) end
            end
        end   
        --comando=353. lista de users en canal, si es diferente de solo mi nick es que el canal ya estaba ocupado. habria que salir y cambiar de canal
        if comando=="353" then
            conectados={}
            listaconectados=string.match(resto,":([%s*@*%w]+)")
            --if listaconectados then
                for k in string.gmatch(listaconectados,"(%w+)") do
                    table.insert(conectados,k)
                end
            --end
        end
        
        --Comando=MODE confirma un estado de canal o usuario
        --comando 475 password erroneo entrando en canal. Normalmente el canal esta ocupado
    end
end

function procesa(cadena)
    procesando=true
    --caso PING
    pos=string.find(cadena,"PING ")
    if pos==1 then
        cadenaS=(string.gsub(cadena,"PING","PONG"))
        print(cadenaS)
        cliente:send(cadenaS.."\n")
    else
        --rellena bufer con la entrada separada por lineas
        for str in string.gmatch(cadena, "([^".."\n".."]+)") do
                table.insert(bufer, str)
        end
    end
    procesando=false
    desglosa()
end
function recibido(cliente,data)
    --print(data)
    
    procesa(data)
end

function desconectado(cliente,e)
    print("desconectado por "..tostring(e))
end
function encripta(str,pas)
pwdch=string.sub(crypto.toHex(crypto.hash("sha1",pas)),1,16)
return encoder.toHex(crypto.encrypt("AES-CBC",pwdch,str))
end
function desencripta(str,pas)
pwdch=string.sub(crypto.toHex(crypto.hash("sha1",pas)),1,16)
return crypto.decrypt("AES-CBC",pwdch,encoder.fromHex(str))
end

    cliente:on("receive",recibido)
    cliente:on("connection",conectado)
    cliente:on("disconnection",desconectado)
    cliente:connect(ircport,ircserver)
