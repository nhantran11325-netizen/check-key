local HttpService = game:GetService("HttpService")
local Player = game.Players.LocalPlayer
local WebAppUrl = "https://script.google.com/macros/s/AKfycbxBvMfAzYBzZUOR_3dtUQLc0SKu_6nICwSK0gYV96ZvCXqUtJGGTOk9TJJrx6LTYrbR/exec"

local function GetHWID()
    return game:GetService("RbxAnalyticsService"):GetClientId()
end

local function VerifyDatabase()
    local inputKey = getgenv().Key
    if inputKey == "" or inputKey == nil then
        Player:Kick("\n[Sigma Hub]\nLỖI: Bạn chưa nhập Key!")
        return
    end

    -- Gửi yêu cầu qua GET để ổn định trên Mobile
    local checkUrl = WebAppUrl .. "?key=" .. inputKey .. "&hwid=" .. GetHWID()
    
    local success, result = pcall(function()
        return game:HttpGet(checkUrl)
    end)

    if success then
        local data = HttpService:JSONDecode(result)
        
        if data.success then
            print("==============================")
            print("XÁC THỰC THÀNH CÔNG!")
            print("Hạn dùng: " .. data.message)
            print("==============================")
            
            -- [ 3. TẢI SCRIPT CHÍNH ]
            -- Link Raw sạch (Đã xóa token để tránh lỗi 404)
            local scriptUrl = "https://api.junkie-development.de/api/v1/luascripts/public/c052c97909dcfb35fd4be16f305031c3f19eaf127516dfc7f2da361939d1e4d4/download"
            
            local loadSuccess, scriptContent = pcall(function()
                return game:HttpGet(scriptUrl)
            end)

            if loadSuccess then
                local runSuccess, errorMsg = pcall(function()
                    loadstring(scriptContent)()
                end)
                if not runSuccess then
                    warn("Lỗi thực thi script chính: " .. tostring(errorMsg))
                end
            else
                Player:Kick("\n[Sigma Hub Error]\nKhông thể tải script chính từ GitHub!\nHãy kiểm tra lại link hoặc Repo Public.")
            end
        else
            -- Kick nếu key sai, hwid mismatch hoặc hết hạn
            Player:Kick("\n[Sigma Hub Error]\n" .. (data.message or "Xác thực thất bại!"))
        end
    else
        Player:Kick("\n[Sigma Hub Error]\nKhông thể kết nối Database Google Sheets!")
    end
end

-- Chạy hệ thống
VerifyDatabase()
