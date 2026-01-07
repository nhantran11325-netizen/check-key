-- Chờ game load hoàn tất
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

-- =========================================================
-- [ HỆ THỐNG XÁC THỰC GOOGLE SHEETS ]
-- =========================================================
local HttpService = game:GetService("HttpService")
local Player = game.Players.LocalPlayer
-- Link Web App của bạn
local WebAppUrl = "https://script.google.com/macros/s/AKfycbyX07n5wVsWKgaYKVhyHT8dncgud4htt8dTEm1r6VUoKKtOpVOYHcVAgedKXaFOgzzX/exec"

local function GetHWID()
    return game:GetService("RbxAnalyticsService"):GetClientId()
end

local function VerifyDatabase()
    local inputKey = getgenv().Key
    
    -- 1. Nếu không có Key -> CÚT
    if inputKey == "" or inputKey == nil then
        Player:Kick("\n[Sigma Hub]\nLỖI: Bạn chưa nhập Key!")
        return
    end

    -- Tạo URL kiểm tra kèm Key và HWID
    local checkUrl = WebAppUrl .. "?key=" .. inputKey .. "&hwid=" .. GetHWID()
    
    -- 2. Gửi yêu cầu kiểm tra tới Google Sheets
    local success, result = pcall(function()
        return game:HttpGet(checkUrl)
    end)

    if success then
        local data = HttpService:JSONDecode(result)
        
        -- 3. Kiểm tra phản hồi từ Database
        if data.success then
            -- [ ĐÚNG THÌ BẮT ĐẦU CHẠY SCRIPT ]
            print("==============================")
            print("XÁC THỰC THÀNH CÔNG!")
            print("Hạn dùng: " .. data.message)
            print("==============================")
            
            -- Link Script mới bạn cung cấp
            local scriptUrl = "https://api.junkie-development.de/api/v1/luascripts/public/c052c97909dcfb35fd4be16f305031c3f19eaf127516dfc7f2da361939d1e4d4/download"
            
            local loadSuccess, scriptContent = pcall(function()
                return game:HttpGet(scriptUrl)
            end)

            if loadSuccess then
                -- Thực thi script chính
                local runSuccess, errorMsg = pcall(function()
                    loadstring(scriptContent)()
                end)
                if not runSuccess then
                    warn("Lỗi thực thi script chính: " .. tostring(errorMsg))
                end
            else
                -- Không tải được nội dung script -> CÚT
                Player:Kick("\n[Sigma Hub Error]\nKhông thể tải nội dung script từ máy chủ!")
            end
        else
            -- [ SAI KEY / HẾT HẠN / SAI HWID -> CÚT ]
            Player:Kick("\n[Sigma Hub Error]\n" .. (data.message or "Xác thực thất bại!"))
        end
    else
        -- Lỗi kết nối API -> CÚT
        Player:Kick("\n[Sigma Hub Error]\nKhông thể kết nối Database Google Sheets!")
    end
end

-- Bắt đầu tiến trình xác thực
VerifyDatabase()
