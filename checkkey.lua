repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

getgenv().Key = "dsaaaa" -- Nhập Key của bạn

local HttpService = game:GetService("HttpService")
local WebAppUrl = "https://script.google.com/macros/s/AKfycbwTgu-dBNuzNFYOoZHwFJcJ6U9NlnBUogOI3GsyCZ_9yqd_7tH9OOGjTx9gZg3uFvGe/exec"

local function Verify()
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    local url = WebAppUrl .. "?key=" .. getgenv().Key .. "&hwid=" .. hwid
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        -- Kiểm tra xem kết quả có phải JSON không để tránh lỗi Parse
        local isJson, data = pcall(function() return HttpService:JSONDecode(result) end)
        
        if isJson then
            if data.success then
                print("XÁC THỰC THÀNH CÔNG! Hạn: " .. data.message)
                
                -- Tải script chính
                local scriptUrl = "https://api.junkie-development.de/api/v1/luascripts/public/c052c97909dcfb35fd4be16f305031c3f19eaf127516dfc7f2da361939d1e4d4/download"
                loadstring(game:HttpGet(scriptUrl))()
            else
                game.Players.LocalPlayer:Kick("\n[Sigma Hub]\n" .. data.message)
            end
        else
            warn("Lỗi Database: Google trả về HTML thay vì JSON. Hãy kiểm tra lại hàm doGet!")
        end
    else
        game.Players.LocalPlayer:Kick("\n[Sigma Hub]\nLỗi kết nối mạng!")
    end
end

Verify()
