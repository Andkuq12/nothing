Config = {
    mode = "HTPT",  -- "HTPT" atau "PTHT"
    type = "Plat",    -- "Air" atau "Plat" 
    direction = "Vertical", -- "Horizontal" atau "Vertical"
    
    ID = {
        idpt = 5640,      -- ID seed for planting
        idht = 341,      -- ID seed for harvest  
        idplat = 998     -- ID platform block
    },
    
    Delay = {
        delayPT = 10,    -- Delay planting (ms)
        delayHT = 350,    -- Delay harvest (ms)
        delayUWS = 500   -- Delay UWS (ms)
    },
    
    SizeWorld = {
        SizeX = 99,      -- size world X
        SizeY = 113       -- size world Y
    },
    
    Other = {
        PathFind = true,  -- Enable pathfinding
        AutoUWS = true,   -- Auto ultra world spray
        funcUWS = "default" -- "default" atau "custom"
    },
    
    -- NEW CONFIG ADDITIONS:
    World = {
        Name = "ZONA",    -- Your World
        ReconnectDelay = 60000 -- Delay reconnect (ms)
    },
    
    Magplant = {
        BackgroundID = 14,   -- Background ID magplant
        MagplantID = 9850, -- Magplant ID
        Take = "right",      -- "left" atau "right"
        Enabled = true      -- Auto get magplant
    },
    
    Loop = {
        Type = "UNLIMITED", -- "UNLIMITED" atau "LIMITED"
        Count = 10          -- Jumlah loop jika LIMITED
    }
}

-- Script utama tetap sama seperti sebelumnya...

moduleJSON = [[
{
    "sub_name": "Grandfuscator PTHT",
    "icon": "Agriculture",
    "menu": [
        {
            "type": "labelapp",
            "icon": "Settings",
            "text": "Main Settings"
        },
        {
            "type": "divider"
        },
        {
            "type": "dialog",
            "text": "Mode",
            "support_text": "Select farming operation mode",
            "fill": true,
            "menu": [
                {
                    "type": "toggle_button",
                    "text": "HTPT Mode",
                    "alias": "config_mode_htpt",
                    "default": ]]..tostring(Config.mode == "HTPT")..[[
                },
                {
                    "type": "toggle_button",
                    "text": "PTHT Mode", 
                    "alias": "config_mode_ptht",
                    "default": ]]..tostring(Config.mode == "PTHT")..[[
                }
            ]
        },
        {
            "type": "dialog",
            "text": "Type",
            "support_text": "Select planting type",
            "fill": true,
            "menu": [
                {
                    "type": "toggle_button",
                    "text": "Air Method",
                    "alias": "config_type_air",
                    "default": ]]..tostring(Config.type == "Air")..[[
                },
                {
                    "type": "toggle_button",
                    "text": "Platform Method",
                    "alias": "config_type_plat",
                    "default": ]]..tostring(Config.type == "Plat")..[[
                }
            ]
        },
        {
            "type": "dialog",
            "text": "Direction PTHT",
            "support_text": "Select PTHT Direction",
            "fill": true,
            "menu": [
                {
                    "type": "toggle_button",
                    "text": "Horizontal",
                    "alias": "config_type_horizontal",
                    "default": ]]..tostring(Config.direction == "Horizontal")..[[
                },
                {
                    "type": "toggle_button",
                    "text": "Vertical",
                    "alias": "config_type_vertical",
                    "default": ]]..tostring(Config.direction == "Vertical")..[[
                }
            ]
        },
        {
            "type": "divider"
        },
        {
            "type": "toggle",
            "text": "Path Find",
            "alias": "config_pathfind",
            "default": ]]..tostring(Config.Other.PathFind)..[[,
            "icon": "Explore"
        },
        {
            "type": "toggle",
            "text": "Auto UWS",
            "alias": "config_autouws",
            "default": ]]..tostring(Config.Other.AutoUWS)..[[,
            "icon": "AutoFixHigh"
        },
        {
            "type": "toggle",
            "text": "Auto Magplant",
            "alias": "config_auto_magplant",
            "default": ]]..tostring(Config.Magplant.Enabled)..[[,
            "icon": "TakeoutDining"
        },
        {
            "type": "divider"
        },
        {
            "type": "dialog",
            "text": "World Settings",
            "support_text": "Configure world settings",
            "fill": true,
            "menu": [
                {
                    "type": "input_string",
                    "text": "World Name",
                    "alias": "config_world_name",
                    "default": "]]..Config.World.Name..[[",
                    "icon": "Public"
                },
                {
                    "type": "input_int",
                    "text": "Reconnect Delay",
                    "alias": "config_reconnect_delay",
                    "default": ]]..Config.World.ReconnectDelay..[[,
                    "icon": "Timer"
                }
            ]
        },
        {
            "type": "dialog",
            "text": "Magplant Settings",
            "support_text": "Configure magplant",
            "fill": true,
            "menu": [
                {
                    "type": "input_int",
                    "text": "Background ID",
                    "alias": "config_magplant_bg",
                    "default": ]]..Config.Magplant.BackgroundID..[[,
                    "icon": "GridOn"
                },
                {
                    "type": "input_int",
                    "text": "Magplant ID",
                    "alias": "config_magplant_id",
                    "default": ]]..Config.Magplant.MagplantID..[[,
                    "icon": "GridOn"
                },
                {
                    "type": "toggle_button",
                    "text": "Take Left",
                    "alias": "config_magplant_left",
                    "default": ]]..tostring(Config.Magplant.Take == "left")..[[,
                    "icon": "ArrowLeft"
                },
                {
                    "type": "toggle_button",
                    "text": "Take Right",
                    "alias": "config_magplant_right",
                    "default": ]]..tostring(Config.Magplant.Take == "right")..[[,
                    "icon": "ArrowRight"
                }
            ]
        },
        {
            "type": "dialog",
            "text": "Loop Settings",
            "support_text": "Configure loop",
            "fill": true,
            "menu": [
                {
                    "type": "toggle_button",
                    "text": "Unlimited Loop",
                    "alias": "config_loop_unlimited",
                    "default": ]]..tostring(Config.Loop.Type == "UNLIMITED")..[[,
                    "icon": "Loop"
                },
                {
                    "type": "toggle_button",
                    "text": "Limited Loop",
                    "alias": "config_loop_limited",
                    "default": ]]..tostring(Config.Loop.Type ~= "UNLIMITED")..[[,
                    "icon": "Numbers"
                },
                {
                    "type": "input_int",
                    "text": "Loop Count",
                    "alias": "config_loop_count",
                    "default": ]]..(type(Config.Loop.Count) == "number" and Config.Loop.Count or 1)..[[,
                    "icon": "Flag"
                }
            ]
        },
        {
            "type": "divider"
        },
        {
            "type": "dialog",
            "text": "Item Settings",
            "support_text": "Configure item IDs",
            "fill": true,
            "menu": [
                {
                    "type": "labelapp",
                    "icon": "LocalFlorist",
                    "text": "Item ID Configuration"
                },
                {
                    "type": "input_int",
                    "text": "Plant Seed ID",
                    "alias": "config_item_pt",
                    "default": ]]..Config.ID.idpt..[[,
                    "icon": "LocalFlorist"
                },
                {
                    "type": "input_int",
                    "text": "Harvest Seed ID",
                    "alias": "config_item_ht",
                    "default": ]]..Config.ID.idht..[[,
                    "icon": "Agriculture"
                },
                {
                    "type": "input_int",
                    "text": "Platform Block ID",
                    "alias": "config_item_plat",
                    "default": ]]..Config.ID.idplat..[[,
                    "icon": "GridOn"
                }
            ]
        },
        {
            "type": "dialog",
            "text": "Delay Settings",
            "support_text": "Configure delays",
            "fill": true, 
            "menu": [
                {
                    "type": "input_int",
                    "text": "Plant Delay",
                    "alias": "config_delay_pt",
                    "default": ]]..Config.Delay.delayPT..[[,
                    "icon": "Timer"
                },
                {
                    "type": "input_int",
                    "text": "Harvest Delay",
                    "alias": "config_delay_ht",
                    "default": ]]..Config.Delay.delayHT..[[,
                    "icon": "Timer"
                },
                {
                    "type": "input_int",
                    "text": "UWS Delay",
                    "alias": "config_delay_uws",
                    "default": ]]..Config.Delay.delayUWS..[[,
                    "icon": "WaterDrop"
                }
            ]
        },
        {
            "type": "dialog",
            "text": "World Size Settings",
            "support_text": "Configure size world",
            "fill": true,
            "menu": [
                {
                    "type": "input_int",
                    "text": "World Size X",
                    "alias": "config_size_x",
                    "default": ]]..Config.SizeWorld.SizeX..[[,
                    "icon": "Width"
                },
                {
                    "type": "input_int",
                    "text": "World Size Y",
                    "alias": "config_size_y",
                    "default": ]]..Config.SizeWorld.SizeY..[[,
                    "icon": "Height"
                }
            ]
        },
        {
            "type": "dialog",
            "text": "UWS Settings",
            "support_text": "Configure UWS function",
            "fill": true,
            "menu": [
                {
                    "type": "toggle_button",
                    "text": "UWS Default",
                    "alias": "config_func_uws_default",
                    "default": ]]..tostring(Config.Other.funcUWS == "default")..[[,
                    "icon": "Settings"
                },
                {
                    "type": "toggle_button",
                    "text": "UWS Custom",
                    "alias": "config_func_uws_custom",
                    "default": ]]..tostring(Config.Other.funcUWS == "custom")..[[,
                    "icon": "Build"
                }
            ]
        },
        {
            "type": "divider"
        },
        {
            "type": "toggle_button",
            "text": "Start/Stop Script",
            "alias": "config_toggle_script",
            "default": false,
            "icon": "PlayArrow"
        },
        {
            "type": "divider"
        },
        {
            "type": "labelapp",
            "icon": "Code",
            "text": "Script By Grandfuscator"
        }
    ]
}
]]

addIntoModule(moduleJSON)

isRunning = false
lastToggleState = false
currentLoop = 0
magplantTaken = false

function Grandfuscator(message)
    LogToConsole("`w[`cGrandfuscator`w] " .. message)
    growtopia.notify("`w[`cGrandfuscator`w] ".. message)
end

function sendRaw(v, w, x, y, z)
    SendPacketRaw(false, {type = v, state = w, value = x, px = y, py = z, x = y * 32, y = z * 32, xspeed = 700, yspeed = -700})
end

function plat(x, y, platid)
    SendPacketRaw(false, {type = 3, value = platid, px = x, py = y, x = x * 32, y = y * 32})
end

function path(x, y)
    if Config.Other.PathFind then findPath(x, y, false) end
end

function h2(x, y, id)
    SendPacketRaw(false, {state = state, px = x, py = y, x = x*32,  y = y*32})
end

-- Fungsi Auto Reconnect
function checkWorld()
    return GetWorldName() == Config.World.Name
end

function reconnect()
    Grandfuscator("Reconnecting to world: " .. Config.World.Name)
    SendPacket(3, "action|join_request\nname|" .. Config.World.Name .. "|\ninvitedWorld|0")
    Sleep(Config.World.ReconnectDelay)
end

-- Fungsi Auto Get Magplant
function getMagplant()
    local magplants = {}
    
    -- Gunakan world size dari config, jangan hardcode 199
    local maxX = Config.SizeWorld.SizeX
    local maxY = Config.SizeWorld.SizeY
    
    
    
    for x = (Config.Magplant.Take:lower() == "left" and 0 or maxX), 
            (Config.Magplant.Take:lower() == "left" and maxX or 0), 
            (Config.Magplant.Take:lower() == "left" and 1 or -1) do
        
        for y = maxY, 0, -1 do
            if not isRunning then break end
            
           
            local tile = GetTile(x, y)
            if tile and tile.fg == Config.Magplant.MagplantID and tile.bg == Config.Magplant.BackgroundID then
                debugTrace("Found magplant at: "..x..","..y)
                table.insert(magplants, {x, y})
            end
        end
    end
    
    if #magplants > 0 then
        local magplant = magplants[1]
        debugTrace("Taking magplant at: "..magplant[1]..","..magplant[2])
        return takeRemote(magplant[1], magplant[2])
    else
        Grandfuscator("No magplant found!")
        return false
    end
end

function takeRemote(x, y)
    -- Validasi koordinat sebelum eksekusi
    if x < 0 or x > Config.SizeWorld.SizeX or y < 0 or y > Config.SizeWorld.SizeY then
        Grandfuscator("Invalid coordinates for magplant: "..x..","..y)
        return false
    end
    
    -- Cek tile sekali lagi sebelum mengambil
    local tile = GetTile(x, y)
    if not tile or tile.fg ~= Config.Magplant.MagplantID then
        Grandfuscator("Magplant not found at coordinates: "..x..","..y)
        return false
    end
    
    debugTrace("Taking remote")
    
    sendRaw(0, 32, 0, x, y)
    Sleep(500)
    sendRaw(3, 0, 32, x, y)
    Sleep(500)
    
    local status, err = pcall(function()
        SendPacket(2, "action|dialog_return\ndialog_name|itemsucker_block\ntilex|" .. x .. "|\ntiley|" .. y .. "|\nbuttonClicked|getplantationdevice\n\nchk_enablesucking|1\n\n")
    end)
    
    if not status then
        
        return false
    end
    
    Sleep(5000)
    Grandfuscator("Magplant remote taken!")
    return true
end

function resolveToggleConflict(toggled_alias, other_alias, toggled_name, other_name)
    local toggled_val = getValue(0, toggled_alias)
    local other_val = getValue(0, other_alias)
    if toggled_val and other_val then
        editToggle(other_alias, false)
        
    end
end

function checkAllConflicts()
    if getValue(0, "config_mode_htpt") and getValue(0, "config_mode_ptht") then
        editToggle("config_mode_ptht", false)
    end
    if getValue(0, "config_type_air") and getValue(0, "config_type_plat") then
        editToggle("config_type_plat", false)
    end
    if getValue(0, "config_type_horizontal") and getValue(0, "config_type_vertical") then
        editToggle("config_type_vertical", false)
    end
    if getValue(0, "config_func_uws_default") and getValue(0, "config_func_uws_custom") then
        editToggle("config_func_uws_default", false)
    end
    if getValue(0, "config_magplant_left") and getValue(0, "config_magplant_right") then
        editToggle("config_magplant_right", false)
    end
    if getValue(0, "config_loop_unlimited") and getValue(0, "config_loop_limited") then
        editToggle("config_loop_limited", false)
    end
end

function pt_air()
    if Config.direction == "Vertical" then
        for x = 0, Config.SizeWorld.SizeX do
            if not isRunning then break end
            Sleep(1)
            for y = Config.SizeWorld.SizeY, 0, -1 do
                if not isRunning then break end
                local tile = GetTile(x, y)
                if tile and tile.fg == 0 then
                    path(x, y)
                    h2(x, y, Config.ID.idpt)
                    Sleep(Config.Delay.delayPT)
                end
            end
        end
    elseif Config.direction == "Horizontal" then
        for y = Config.SizeWorld.SizeY, 0, -1 do
            if not isRunning then break end
            Sleep(1)
            for x = 0, Config.SizeWorld.SizeX do
                if not isRunning then break end
                local tile = GetTile(x, y)
                if tile and tile.fg == 0 then
                    path(x, y)
                    h2(x, y, Config.ID.idpt)
                    Sleep(Config.Delay.delayPT)
                end
            end
        end
    end
end

function pt_plat()
    if Config.direction == "Vertical" then
        for x = 0, Config.SizeWorld.SizeX do
            if not isRunning then break end
            Sleep(1)
            for y = Config.SizeWorld.SizeY, 0, -1 do
                if not isRunning then break end
                local tile = GetTile(x, y)
                if tile and tile.fg == Config.ID.idplat then
                    path(x, y - 1)
                    plat(x, y - 1, Config.ID.idpt)
                    h2(x, y - 1, Config.ID.idpt)
                    Sleep(Config.Delay.delayPT)
                end
            end
        end
    elseif Config.direction == "Horizontal" then
        for y = Config.SizeWorld.SizeY, 0, -1 do
            if not isRunning then break end
            Sleep(1)
            for x = 0, Config.SizeWorld.SizeX do
                if not isRunning then break end
                local tile = GetTile(x, y)
                if tile and tile.fg == Config.ID.idplat then
                    path(x, y - 1)
                    plat(x, y - 1, Config.ID.idpt)
                    h2(x, y - 1, Config.ID.idpt)
                    Sleep(Config.Delay.delayPT)
                end
            end
        end
    end
end

function ht2()
    
    if Config.direction == "Vertical" then
        for x = 0, Config.SizeWorld.SizeX do
            if not isRunning then break end
            Sleep(1)
            for y = 0, Config.SizeWorld.SizeY do
                if not isRunning then break end
                local tile = GetTile(x, y)
                if tile and tile.fg == Config.ID.idht and tile.readyharvest then
                    Sleep(Config.Delay.delayHT)
                    h2(x, y, 18)
                    path(x, y)
                    
                end
            end
            for y = Config.SizeWorld.SizeY, 0, -1 do
                if not isRunning then break end
                local tile = GetTile(x, y)
                if tile and tile.fg == Config.ID.idht and tile.readyharvest then
                    Sleep(Config.Delay.delayHT)
                    sendRaw(0, 0, 0, x, y)
                    h2(x, y, 18)
                    path(x, y)
                    
                end
            end
        end
    elseif Config.direction == "Horizontal" then
        for y = 0, Config.SizeWorld.SizeY do
            if not isRunning then break end
            Sleep(1)
            for x = 0, Config.SizeWorld.SizeX do
                if not isRunning then break end
                local tile = GetTile(x, y)
                if tile and tile.fg == Config.ID.idht and tile.readyharvest then
                    Sleep(Config.Delay.delayHT)
                    h2(x, y, 18)
                    path(x, y)
                    
                end
            end
            for x = Config.SizeWorld.SizeX, 0, -1 do
                if not isRunning then break end
                local tile = GetTile(x, y)
                if tile and tile.fg == Config.ID.idht and tile.readyharvest then
                    Sleep(Config.Delay.delayHT)
                    sendRaw(0, 0, 0, x, y)
                    h2(x, y, 18)
                    path(x, y)
                    
                end
            end
        end
    end
end

function uws()
    if Config.Other.AutoUWS then
        if Config.Other.funcUWS == "default" then
            SendPacket(2, "action|dialog_return\ndialog_name|world_spray\n")
        elseif Config.Other.funcUWS == "custom" then
            uwscustom()
        end
        Sleep(Config.Delay.delayUWS)
    end
end

-- Fungsi Loop Utama
function mainScript()
    Grandfuscator("Script started!")
    updateConfig()
    checkAllConflicts()
    
    currentLoop = 0
    magplantTaken = false
    
    while isRunning do
        if not checkWorld() then
            reconnect()
            magplantTaken = false
        end
        
     
        if Config.Magplant.Enabled and not magplantTaken then
            if getMagplant() then
                magplantTaken = true
            else
                Grandfuscator("Failed to get magplant, retrying...")
                Sleep(5000)
            end
        end
        
        updateConfig()
        
        if Config.Other.AutoUWS then uws() end
        
        if Config.mode == "HTPT" then
            Grandfuscator("Start Harvest - Loop: " .. currentLoop)
            
            if isRunning then
                Grandfuscator("Start Plant - Loop: " .. currentLoop)
                if Config.type == "Air" then pt_air() elseif Config.type == "Plat" then pt_plat() end
            end
        elseif Config.mode == "PTHT" then
            Grandfuscator("Start Plant - Loop: " .. currentLoop)
            if Config.type == "Air" then pt_air() elseif Config.type == "Plat" then pt_plat() end
            if isRunning then
                Grandfuscator("Start Harvest - Loop: " .. currentLoop)
                ht2()
            end
        end
        
        -- Update loop count
        currentLoop = currentLoop + 1
        
        -- Cek batas loop
        if Config.Loop.Type ~= "LIMITED" and currentLoop >= Config.Loop.Count then
            Grandfuscator("Target loop reached! Stopping script.")
            isRunning = false
            editToggle("config_toggle_script", false)
            break
        end
        
        if not isRunning then break end
        Sleep(1000)
    end
    Grandfuscator("Script stopped! Total loops: " .. currentLoop)
end

function updateConfig()
    if getValue(0, "config_mode_htpt") then Config.mode = "HTPT"
    elseif getValue(0, "config_mode_ptht") then Config.mode = "PTHT" end
    
    if getValue(0, "config_type_air") then Config.type = "Air"
    elseif getValue(0, "config_type_plat") then Config.type = "Plat" end
    
    if getValue(0, "config_type_horizontal") then Config.direction = "Horizontal"
    elseif getValue(0, "config_type_vertical") then Config.direction = "Vertical" end
    
    local v = getValue(0, "config_pathfind")
    if v ~= nil then Config.Other.PathFind = v end
    
    local au = getValue(0, "config_autouws")
    if au ~= nil then Config.Other.AutoUWS = au end
    
    local am = getValue(0, "config_auto_magplant")
    if am ~= nil then Config.Magplant.Enabled = am end
    
    -- World settings
    local worldName = getValue(2, "config_world_name")
    if worldName then Config.World.Name = worldName end
    
    local reconnectDelay = tonumber(getValue(1, "config_reconnect_delay"))
    if reconnectDelay then Config.World.ReconnectDelay = reconnectDelay end
    
    -- Magplant settings
    Config.Magplant.BackgroundID = tonumber(getValue(1, "config_magplant_bg")) or Config.Magplant.BackgroundID
    
    Config.Magplant.MagplantID = tonumber(getValue(1, "config_magplant_id")) or Config.Magplant.MagplantID
    
    if getValue(0, "config_magplant_left") then Config.Magplant.Take = "left" end
    if getValue(0, "config_magplant_right") then Config.Magplant.Take = "right" end
    
    -- Loop settings
    if getValue(0, "config_loop_unlimited") then Config.Loop.Type = "UNLIMITED" end
    if getValue(0, "config_loop_limited") then Config.Loop.Type = "LIMITED" end
    
    local loopCount = tonumber(getValue(1, "config_loop_count"))
    if loopCount then Config.Loop.Count = loopCount end
    
    Config.ID.idpt = tonumber(getValue(1, "config_item_pt")) or Config.ID.idpt
    Config.ID.idht = tonumber(getValue(1, "config_item_ht")) or Config.ID.idht
    Config.ID.idplat = tonumber(getValue(1, "config_item_plat")) or Config.ID.idplat
    
    Config.Delay.delayPT = tonumber(getValue(1, "config_delay_pt")) or Config.Delay.delayPT
    Config.Delay.delayHT = tonumber(getValue(1, "config_delay_ht")) or Config.Delay.delayHT
    Config.Delay.delayUWS = tonumber(getValue(1, "config_delay_uws")) or Config.Delay.delayUWS
    
    Config.SizeWorld.SizeX = math.max(0, tonumber(getValue(1, "config_size_x")) or Config.SizeWorld.SizeX)
    Config.SizeWorld.SizeY = math.max(0, tonumber(getValue(1, "config_size_y")) or Config.SizeWorld.SizeY)

    if getValue(0, "config_func_uws_default") then Config.Other.funcUWS = "default"
    elseif getValue(0, "config_func_uws_custom") then Config.Other.funcUWS = "custom" end
    
    checkAllConflicts()
end

addHook(function(vtype, name, value)
    if vtype == 0 then
        if name == "config_toggle_script" then
            if value == true and not lastToggleState then
                if not isRunning then
                    updateConfig()
                    checkAllConflicts()
                    isRunning = true
                    runThread(mainScript)
                    Grandfuscator("Script started!")
                end
            elseif value == false and lastToggleState then
                isRunning = false
                Grandfuscator("Script stopping!")
            end
            lastToggleState = value
            return
        end
        
        if name == "config_mode_htpt" and value == true then
            resolveToggleConflict("config_mode_htpt", "config_mode_ptht", "HTPT Mode", "PTHT Mode")
            Config.mode = "HTPT"
            return
        end
        
        if name == "config_mode_ptht" and value == true then
            resolveToggleConflict("config_mode_ptht", "config_mode_htpt", "PTHT Mode", "HTPT Mode")
            Config.mode = "PTHT"
            return
        end
        
        if name == "config_type_air" and value == true then
            resolveToggleConflict("config_type_air", "config_type_plat", "Air Planting", "Platform Planting")
            Config.type = "Air"
            return
        end
        
        if name == "config_type_plat" and value == true then
            resolveToggleConflict("config_type_plat", "config_type_air", "Platform Planting", "Air Planting")
            Config.type = "Plat"
            return
        end
        
        if name == "config_type_horizontal" and value == true then
            resolveToggleConflict("config_type_horizontal", "config_type_vertical", "Horizontal", "Vertical")
            Config.direction = "Horizontal"
            return
        end
        
        if name == "config_type_vertical" and value == true then
            resolveToggleConflict("config_type_vertical", "config_type_horizontal", "Vertical", "Horizontal")
            Config.direction = "Vertical"
            return
        end
        
        if name == "config_pathfind" then
            Config.Other.PathFind = value
            return
        end
        
        if name == "config_autouws" then
            Config.Other.AutoUWS = value
            return
        end
        
        if name == "config_auto_magplant" then
            Config.Magplant.Enabled = value
            return
        end
        
        if name == "config_magplant_left" and value == true then
            resolveToggleConflict("config_magplant_left", "config_magplant_right", "Take Left", "Take Right")
            Config.Magplant.Take = "left"
            return
        end
        
        if name == "config_magplant_right" and value == true then
            resolveToggleConflict("config_magplant_right", "config_magplant_left", "Take Right", "Take Left")
            Config.Magplant.Take = "right"
            return
        end
        
        if name == "config_loop_unlimited" and value == true then
            resolveToggleConflict("config_loop_unlimited", "config_loop_limited", "Unlimited Loop", "Limited Loop")
            Config.Loop.Type = "UNLIMITED"
            return
        end
        
        if name == "config_loop_limited" and value == true then
            resolveToggleConflict("config_loop_limited", "config_loop_unlimited", "Limited Loop", "Unlimited Loop")
            Config.Loop.Type = "LIMITED"
            return
        end
        
        if name == "config_func_uws_default" and value == true then
            resolveToggleConflict("config_func_uws_default", "config_func_uws_custom", "UWS Default", "UWS Custom")
            Config.Other.funcUWS = "default"
            return
        end
        
        if name == "config_func_uws_custom" and value == true then
            resolveToggleConflict("config_func_uws_custom", "config_func_uws_default", "UWS Custom", "UWS Default")
            Config.Other.funcUWS = "custom"
            return
        end
    elseif vtype == 1 then
        updateConfig()
    end
end, "onValue")

function initializeValues()
    local saved_idpt = getValue(1, "config_item_pt")
    if saved_idpt then Config.ID.idpt = saved_idpt end
    
    local saved_idht = getValue(1, "config_item_ht")
    if saved_idht then Config.ID.idht = saved_idht end
    
    local saved_idplat = getValue(1, "config_item_plat")
    if saved_idplat then Config.ID.idplat = saved_idplat end
    
    local saved_delayPT = getValue(1, "config_delay_pt")
    if saved_delayPT then Config.Delay.delayPT = saved_delayPT end
    
    local saved_delayHT = getValue(1, "config_delay_ht")
    if saved_delayHT then Config.Delay.delayHT = saved_delayHT end
    
    local saved_delayUWS = getValue(1, "config_delay_uws")
    if saved_delayUWS then Config.Delay.delayUWS = saved_delayUWS end
    
    local saved_sizeX = getValue(1, "config_size_x")
    if saved_sizeX then Config.SizeWorld.SizeX = saved_sizeX end
    
    local saved_sizeY = getValue(1, "config_size_y")
    if saved_sizeY then Config.SizeWorld.SizeY = saved_sizeY end
    
    -- New settings initialization
    local saved_world_name = getValue(2, "config_world_name")
    if saved_world_name then Config.World.Name = saved_world_name end
    
    local saved_reconnect_delay = getValue(1, "config_reconnect_delay")
    if saved_reconnect_delay then Config.World.ReconnectDelay = saved_reconnect_delay end
    
    local saved_magplant_bg = getValue(1, "config_magplant_bg")
    if saved_magplant_bg then Config.Magplant.BackgroundID = saved_magplant_bg end
    
    local saved_magplant_id = getValue(1, "config_magplant_id")
    if saved_magplant_id then Config.Magplant.MagplantID = saved_magplant_id end
    
    local saved_magplant_left = getValue(0, "config_magplant_left")
    if saved_magplant_left ~= nil then
        if saved_magplant_left then Config.Magplant.Take = "left" end
    end
    
    local saved_magplant_right = getValue(0, "config_magplant_right")
    if saved_magplant_right ~= nil then
        if saved_magplant_right then Config.Magplant.Take = "right" end
    end
    
    local saved_auto_magplant = getValue(0, "config_auto_magplant")
    if saved_auto_magplant ~= nil then Config.Magplant.Enabled = saved_auto_magplant end
    
    local saved_loop_unlimited = getValue(0, "config_loop_unlimited")
    if saved_loop_unlimited ~= nil then
        if saved_loop_unlimited then Config.Loop.Type = "UNLIMITED" end
    end
    
    local saved_loop_limited = getValue(0, "config_loop_limited")
    if saved_loop_limited ~= nil then
        if saved_loop_limited then Config.Loop.Type = "LIMITED" end
    end
    
    local saved_loop_count = getValue(1, "config_loop_count")
    if saved_loop_count then Config.Loop.Count = saved_loop_count end
end

initializeValues()
checkAllConflicts()
