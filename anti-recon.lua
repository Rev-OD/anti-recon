local sampev = require 'lib.samp.events'
local vkeys = require 'vkeys'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local isActive = true
local myNick = nil
local KEYWORD = nil

function main()
    while not isSampAvailable() do wait(100) end
    

    myNick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
    KEYWORD = "����� ������� �� "..myNick:gsub("([%%%[%]%^%$%*%+%-%?%.])", "%%%1")
    
    sampRegisterChatCommand("antirec", function()
        isActive = not isActive
        sampAddChatMessage(isActive and "����-�� {00FF00}�����������" or "����-�� {FF0000}�������������", -1)
    end)
end

function sampev.onServerMessage(color, text)
    if not isActive or not KEYWORD then return end 

    if text:lower():find(KEYWORD:lower(), 1, true) then
        lua_thread.create(function()
            local myID = select(2, sampGetPlayerIdByCharHandle(playerPed))

            if myID then
                sampAddChatMessage("{FFFFFF}[Sectret] {00FF00} � ���! �� ���� ����� � �����. ������� Alt+6", -1)
                local responseReceived = false
                local timeout = os.clock() + 10
                
                while not responseReceived and os.clock() < timeout do
                    wait(0)
                    
                    if isKeyDown(vkeys.VK_6) and isKeyDown(vkeys.VK_MENU) then
                        sampSendChat("/toggleinvise")
                        wait(5000)
                        sampSendChat("/toggleinvise")
                    end
                    
                    if isKeyDown(vkeys.VK_7) and isKeyDown(vkeys.VK_MENU) then
                        sampAddChatMessage("{FFFFFF}[�����] {FFFF00}��������", -1)
                        responseReceived = true
                    end
                end
                
                if not responseReceived then
                    sampAddChatMessage("{FFFFFF}[�����] {FF0000}����� �������", -1)
                end
            else
                sampAddChatMessage("{FFFFFF}[�����] {FF0000}������: �� ������� �������� ��� ID", -1)
            end
        end)
    end
end

lua_thread.create(main)