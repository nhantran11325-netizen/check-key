-- [[ CHECKKEY.LUA - HỆ THỐNG XÁC THỰC CỦA Neon HUB ]]

local HttpService = game:GetService("HttpService")
local Player = game.Players.LocalPlayer
-- LINK WEB APP CỦA BẠN (Dùng link Apps Script mới nhất đã Deploy)
local WebAppUrl = "https://script.google.com/macros/s/AKfycbywblsMG_dj9XsRtdC-E9BPzZk6NgIO7avGOTWFINm70dBVj6CioSgvQQDj1R9VBkkJ/exec"
-- LINK SCRIPT CHÍNH (Neon.txt)
local ScriptUrl = "https://api.junkie-development.de/api/v1/luascripts/public/c052c97909dcfb35fd4be16f305031c3f19eaf127516dfc7f2da361939d1e4d4/download"

local function Verify()
    -- 1. Kiểm tra xem Loader đã truyền Key vào chưa
    local inputKey = getgenv().Key
    if not inputKey or inputKey == "" then
        Player:Kick("\n[Neon Hub]\nLỖI: Thiếu Key! Vui lòng nhập Key vào Loader.")
        return
    end

    -- 2. Lấy HWID
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    local checkUrl = WebAppUrl .. "?key=" .. tostring(inputKey) .. "&hwid=" .. tostring(hwid)

    print("[Neon Hub] Đang kiểm tra Key...")

    -- 3. Gửi yêu cầu xác thực
    local success, result = pcall(function()
        return game:HttpGet(checkUrl)
    end)

    if success then
        -- Chống lỗi Parse JSON nếu Google trả về HTML
        local isJson, data = pcall(function() return HttpService:JSONDecode(result) end)
        
        if isJson then
            if data.success then
                -- [ THÀNH CÔNG ]
                print("========================================")
                print("XÁC THỰC THÀNH CÔNG!")
                print("Hạn dùng: " .. tostring(data.message))
                print("========================================")

                -- Kiểm tra xem Config đã có chưa, nếu chưa thì tạo bảng rỗng để tránh lỗi script chính
                if not getgenv().Configs then
                    getgenv().Configs = {}
                    warn("[Neon Hub] Không tìm thấy Config từ Loader, sử dụng mặc định.")
                end

                -- 4. Tải script chính (Neon.txt)
                local loadSuccess, scriptContent = pcall(function()
                    return game:HttpGet(ScriptUrl)
                end)

                if loadSuccess then
                    print("[Neon Hub] Đang khởi tạo script chính...")
                    loadstring(scriptContent)()
                else
                    Player:Kick("\n[Neon Hub Error]\nKhông thể tải script chính từ Server!")
                end
            else
                -- [ THẤT BẠI: Sai Key/Hết hạn/HWID ]
                Player:Kick("\n[Neon Hub Error]\n" .. tostring(data.message))
            end
        else
            warn("[Neon Hub] Phản hồi từ Server không hợp lệ (JSON Error).")
            print("Response: " .. tostring(result))
        end
    else
        Player:Kick("\n[Neon Hub Error]\nKhông thể kết nối tới Database!")
    end
end

-- Chạy hàm xác thực
Verify()
