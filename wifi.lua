
hostname="NODEMCU"
depurar=true
wifi.setmode(wifi.STATION)
function imprime(cadprint)
    if depurar then 
        print(cadprint)
    end
end
imprime("Iniciando WIFI.lua")

    dofile("configuracion.lua")  

recupera()
imprime("recuperando datos.")
convierte()
imprime("convirtiendo datos")
configuracion={}
configuracion.ssid=ssidsta
configuracion.pwd=paswsta
configuracion.save= true
confip={}
confip.ip=ipsta
confip.netmask=netmasksta
confip.gateway=gatewaysta
wifi.sta.setip(confip)
wifi.sta.config(configuracion)
wifi.sta.sethostname(hostname..node.random(999))

 wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
 imprime("\n\tSTA - CONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
 T.BSSID.."\n\tChannel: "..T.channel)
 end)

 wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T)
 imprime("\n\tSTA - DISCONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
 T.BSSID.."\n\treason: "..T.reason)
 end)

 wifi.eventmon.register(wifi.eventmon.STA_AUTHMODE_CHANGE, function(T)
 imprime("\n\tSTA - AUTHMODE CHANGE".."\n\told_auth_mode: "..
 T.old_auth_mode.."\n\tnew_auth_mode: "..T.new_auth_mode)
 end)

 wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
 srvip=T.IP
 imprime("\n\tSTA - GOT IP".."\n\tStation IP: "..T.IP.."\n\tSubnet mask: "..
 T.netmask.."\n\tGateway IP: "..T.gateway)
 dofile("IRC.lua")

  end)
    
 
 wifi.eventmon.register(wifi.eventmon.STA_DHCP_TIMEOUT, function()
 imprime("\n\tSTA - DHCP TIMEOUT")
 end)

 wifi.eventmon.register(wifi.eventmon.AP_STACONNECTED, function(T)
 imprime("\n\tAP - STATION CONNECTED".."\n\tMAC: "..T.MAC.."\n\tAID: "..T.AID)
 end)

 wifi.eventmon.register(wifi.eventmon.AP_STADISCONNECTED, function(T)
 imprime("\n\tAP - STATION DISCONNECTED".."\n\tMAC: "..T.MAC.."\n\tAID: "..T.AID)
 end)

 wifi.eventmon.register(wifi.eventmon.AP_PROBEREQRECVED, function(T)
 imprime("\n\tAP - PROBE REQUEST RECEIVED".."\n\tMAC: ".. T.MAC.."\n\tRSSI: "..T.RSSI)
 end)

 wifi.eventmon.register(wifi.eventmon.WIFI_MODE_CHANGED, function(T)
 imprime("\n\tSTA - WIFI MODE CHANGED".."\n\told_mode: "..
 T.old_mode.."\n\tnew_mode: "..T.new_mode)
 end)


