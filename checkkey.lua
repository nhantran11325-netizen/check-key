local HttpService = game:GetService("HttpService")
local Player = game.Players.LocalPlayer
local WebAppUrl = "https://script.google.com/macros/s/AKfycbyyo2YpeUJ9UiP7ppaltYOLOB9fs73b827KE5D8SVIOIOIlZmoNYyJdYHJwbSjiXY9Z/exec"

local function VerifyDatabase()
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    local url = WebAppUrl .. "?key=" .. getgenv().Key .. "&hwid=" .. hwid
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        -- Chống lỗi "Can't parse JSON"
        local isJson, data = pcall(function() return HttpService:JSONDecode(result) end)
        
        if isJson then
            if data.success then
                print("==============================")
                print("XÁC THỰC THÀNH CÔNG!")
                print("Hạn dùng: " .. data.message)
                print("==============================")
                
                -- LOAD SCRIPT CHÍNH (Dùng link bạn gửi)
                local scriptUrl = "https://api.junkie-development.de/api/v1/luascripts/public/c052c97909dcfb35fd4be16f305031c3f19eaf127516dfc7f2da361939d1e4d4/download"
                loadstring(game:HttpGet(scriptUrl))()
            else
                Player:Kick("\n[Sigma Hub]\n" .. data.message)
            end
        else
            warn("Database đang bảo trì hoặc Link Web App sai định dạng!")
        end
    else
        Player:Kick("\n[Sigma Hub]\nLỗi kết nối mạng!")
    end
end

VerifyDatabase()
