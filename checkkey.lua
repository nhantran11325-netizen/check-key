-- Chờ game load hoàn tất
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

-- =========================================================
-- [ 1. CONFIGURATION ]
-- =========================================================
getgenv().Key = getgenv().Key or "" -- Ưu tiên key đã nhập hoặc để trống
local WebAppUrl = "https://script.google.com/macros/s/AKfycbywblsMG_dj9XsRtdC-E9BPzZk6NgIO7avGOTWFINm70dBVj6CioSgvQQDj1R9VBkkJ/execc"
local ScriptUrl = "https://api.junkie-development.de/api/v1/luascripts/public/c052c97909dcfb35fd4be16f305031c3f19eaf127516dfc7f2da361939d1e4d4/download"

local HttpService = game:GetService("HttpService")
local Player = game.Players.LocalPlayer

-- =========================================================
-- [ 2. VERIFICATION FUNCTION ]
-- =========================================================
local function VerifyDatabase()
    -- Kiểm tra nếu người dùng quên nhập Key
    if not getgenv().Key or getgenv().Key == "" then
        Player:Kick("\n[Sigma Hub]\nLỗi: Bạn chưa nhập Key!")
        return
    end

    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    local checkUrl = WebAppUrl .. "?key=" .. tostring(getgenv().Key) .. "&hwid=" .. tostring(hwid)
    
    print("[Sigma Hub] Đang xác thực với Database...")

    local success, result = pcall(function()
        return game:HttpGet(checkUrl)
    end)

    if success then
        -- Chống lỗi "Can't parse JSON" khi Google Apps Script lỗi 500 hoặc bảo trì
        local isJson, data = pcall(function() return HttpService:JSONDecode(result) end)
        
        if isJson then
            if data.success then
                -- [ TRƯỜNG HỢP: ĐÚNG KEY ]
                print("========================================")
                print("XÁC THỰC THÀNH CÔNG!")
                print("Hạn dùng: " .. tostring(data.message))
                print("========================================")
                
                -- Tải script chính sau khi xác thực xong
                local loadSuccess, scriptContent = pcall(function()
                    return game:HttpGet(ScriptUrl)
                end)

                if loadSuccess then
                    loadstring(scriptContent)()
                else
                    Player:Kick("\n[Sigma Hub Error]\nXác thực thành công nhưng không thể tải nội dung Script chính!")
                end
            else
                -- [ TRƯỜNG HỢP: SAI KEY / HẾT HẠN / SAI HWID -> CÚT ]
                Player:Kick("\n[Sigma Hub Error]\n" .. tostring(data.message))
            end
        else
            -- Trường hợp Web App trả về HTML (Lỗi Script hoặc quá tải)
            warn("[Sigma Hub] Phản hồi từ Server không hợp lệ. Vui lòng kiểm tra lại link Web App!")
            print("Server Response: " .. tostring(result))
        end
    else
        -- Lỗi kết nối mạng hoặc Link WebApp bị lỗi
        Player:Kick("\n[Sigma Hub Error]\nKhông thể kết nối tới máy chủ xác thực!")
    end
end

-- =========================================================
-- [ 3. EXECUTION ]
-- =========================================================
VerifyDatabase()
