local HttpService = game:GetService("HttpService")local Player = game.Players.LocalPlayerlocal WebAppUrl = "https://script.google.com/macros/s/AKfycbxRp045AjiWfZqkDRHnqFpsgRkYOIqUtkxGGXSL4ILN9vS5LtqdXDlyVVnt4MnEpI2E/exec"-- Hàm lấy HWID của máylocal function GetHWID()

    return game:GetService("RbxAnalyticsService"):GetClientId()end-- Hàm thực hiện Check Keylocal function VerifyDatabase()

    local inputKey = getgenv().Key

    local currentHWID = GetHWID()



    -- BƯỚC 1: Chặn ngay nếu không nhập key

    if inputKey == "" or inputKey == nil then

        Player:Kick("\n[Sigma Hub]\nLỖI: Bạn chưa nhập Key vào dòng getgenv().Key!")

        return

    end



    -- BƯỚC 2: Gửi dữ liệu lên Google Sheets để kiểm tra

    -- Hỗ trợ tất cả các Executor (Synapse, Delta, Arceus, Fluxus,...)

    local requestFunc = (syn and syn.request) or (http and http.request) or request or http_request

    

    local success, response = pcall(function()

        return requestFunc({

            Url = WebAppUrl,

            Method = "POST",

            Headers = {["Content-Type"] = "application/json"},

            Body = HttpService:JSONEncode({

                key = inputKey,

                hwid = currentHWID

            })

        })

    end)



    -- BƯỚC 3: Xử lý kết quả trả về từ Google Sheets

    if success and response.StatusCode == 200 then

        local data = HttpService:JSONDecode(response.Body)

        

        if data.success then

            print("Xác thực thành công! HWID: " .. currentHWID)

            

            -- CHỈ KHI DATABASE TRẢ VỀ SUCCESS MỚI LOAD SCRIPT

            loadstring(game:HttpGet("https://raw.githubusercontent.com/nhantran11325-netizen/test-kaitun/refs/heads/main/Neon.txt"))()

        else

            -- Kick nếu Key sai hoặc HWID không khớp

            Player:Kick("\n[Sigma Hub Error]\n" .. (data.message or "Xác thực thất bại!"))

        end

    else

        -- Lỗi kết nối đến Google App Script

        Player:Kick("\n[Sigma Hub Error]\nKhông thể kết nối đến Database. Vui lòng thử lại sau!")

    endend-- Khởi chạy tiến trình kiểm tra

VerifyDatabase()
