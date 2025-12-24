endtime=load('return os.time{year=2026, month=12, day=1, hour=0,min=0, sec=0}')()
if(os.time()<endtime) then


isRunning = false
stopRequested = false
harvestCount = 0
currentCycle = 0
lastTreeCount = 0
magplantIndex = 1
foundMagplants = {}
currentStatus = "Idle"

local lastTreeCheck = 0
local treeCheckInterval = 5000
local randomInt = math.random(0x0, 0xff)

local function log(msg)
    LogToConsole("`w[`cGrandfuscator`w]  " .. msg)
end

moduleJSON = ([[
{
    "sub_name": "Grandfuscator PTHT",
    "icon": "Agriculture",
    "menu": [
        {
            "type": "labelapp",
            "icon": "Info",
            "text": "Grandfuscator PTHT v3.1"
        },
        {
            "type": "divider"
        },
        {
            "type": "labelapp",
            "icon": "Speed",
            "text": "SYSTEM STATUS"
        },
        {
            "type": "divider"
        },
        {
            "type": "labelapp",
            "icon": "PowerSettingsNew",
            "text": "Status: Idle"
        },
        {
            "type": "labelapp",
            "icon": "Cached",
            "text": "Current Cycle: 0"
        },
        {
            "type": "labelapp",
            "icon": "Park",
            "text": "Tree Count: 0"
        },
        {
            "type": "labelapp",
            "icon": "SettingsRemote",
            "text": "Magplants: Found 0"
        },
        {
            "type": "divider"
        },
        {
            "type": "toggle_button",
            "text": "Start PTHT",
            "alias": "config_ptht_toggle_start`id",
            "default": false
        },
        {
            "type": "button",
            "text": "Stop Script",
            "alias": "btn_stop_script`id"
        },
        {
            "type": "divider"
        },
        {
            "type": "dialog",
            "text": "Mode Configuration",
            "support_text": "PTHT Mode Settings",
            "fill": true,
            "menu": [
                {
                    "type": "labelapp",
                    "icon": "Tune",
                    "text": "DIRECTION MODE"
                },
                {
                    "type": "toggle_button",
                    "text": "Vertical",
                    "alias": "config_ptht_mode_direction`id",
                    "default": true
                },
                {
                    "type": "toggle_button",
                    "text": "Horizontal",
                    "alias": "config_ptht_mode_direction_h`id",
                    "default": false
                },
                {
                    "type": "divider"
                },
                {
                    "type": "labelapp",
                    "icon": "Navigation",
                    "text": "PLANTING DIRECTION"
                },
                {
                    "type": "toggle_button",
                    "text": "Bottom to Top",
                    "alias": "config_ptht_mode_planting_direction_bt`id",
                    "default": true
                },
                {
                    "type": "toggle_button",
                    "text": "Top to Bottom",
                    "alias": "config_ptht_mode_planting_direction_tb`id",
                    "default": false
                },
                {
                    "type": "divider"
                },
                {
                    "type": "labelapp",
                    "icon": "LocalFlorist",
                    "text": "PLANT TYPE"
                },
                {
                    "type": "toggle_button",
                    "text": "Platform",
                    "alias": "config_ptht_mode_plant_type_p`id",
                    "default": true
                },
                {
                    "type": "toggle_button",
                    "text": "Air",
                    "alias": "config_ptht_mode_plant_type_a`id",
                    "default": false
                },
                {
                    "type": "divider"
                },
                {
                    "type": "labelapp",
                    "icon": "Agriculture",
                    "text": "HARVEST TYPE"
                },
                {
                    "type": "toggle_button",
                    "text": "Type 1 (Fast)",
                    "alias": "config_ptht_mode_harvest_type_1`id",
                    "default": true
                },
                {
                    "type": "toggle_button",
                    "text": "Type 2 (Effective)",
                    "alias": "config_ptht_mode_harvest_type_2`id",
                    "default": false
                },
                {
                    "type": "divider"
                },
                {
                    "type": "labelapp",
                    "icon": "Sort",
                    "text": "ORDER MODE"
                },
                {
                    "type": "toggle_button",
                    "text": "PTHT",
                    "alias": "config_ptht_mode_order_mode_ptht`id",
                    "default": true
                },
                {
                    "type": "toggle_button",
                    "text": "HTPT",
                    "alias": "config_ptht_mode_order_mode_htpt`id",
                    "default": false
                },
                {
                    "type": "divider"
                },
                {
                    "type": "toggle",
                    "text": "Use UWS Spray",
                    "alias": "config_ptht_features_use_uws`id",
                    "default": true,
                    "icon": "WaterDrop"
                }
            ]
        },
        {
            "type": "dialog",
            "text": "Splice Configuration",
            "support_text": "Splice Mode Settings",
            "fill": true,
            "menu": [
                {
                    "type": "toggle",
                    "text": "Enable Splice Mode",
                    "alias": "config_ptht_features_use_splice`id",
                    "default": false,
                    "icon": "CallMerge"
                },
                {
                    "type": "divider"
                },
                {
                    "type": "toggle_button",
                    "text": "Normal Mode",
                    "alias": "config_ptht_splice_mode_normal`id",
                    "default": false
                },
                {
                    "type": "toggle_button",
                    "text": "Magplant Mode",
                    "alias": "config_ptht_splice_mode_magplant`id",
                    "default": true
                },
                {
                    "type": "input_int",
                    "text": "Seed 1 ID",
                    "alias": "config_ptht_splice_seed1`id",
                    "default": 1044,
                    "icon": "LocalFlorist"
                },
                {
                    "type": "input_int",
                    "text": "Seed 2 ID",
                    "alias": "config_ptht_splice_seed2`id",
                    "default": 1062,
                    "icon": "CallMerge"
                },
                {
                    "type": "input_int",
                    "text": "Magplant 1 ID",
                    "alias": "config_ptht_splice_magplant1`id",
                    "default": 9850,
                    "icon": "SettingsRemote"
                },
                {
                    "type": "input_int",
                    "text": "Magplant 2 ID",
                    "alias": "config_ptht_splice_magplant2`id",
                    "default": 9850,
                    "icon": "SettingsRemote"
                },
                {
                    "type": "divider"
                },
                {
                    "type": "button",
                    "text": "Test Find Seed1",
                    "alias": "btn_test_seed1`id"
                }
            ]
        },
        {
            "type": "dialog",
            "text": "World Configuration",
            "support_text": "World Settings",
            "fill": true,
            "menu": [
                {
                    "type": "input_text",
                    "text": "World Name",
                    "alias": "config_ptht_world_name`id",
                    "default": "ZONA",
                    "icon": "Public"
                },
                {
                    "type": "input_int",
                    "text": "Size X",
                    "alias": "config_ptht_world_size_x`id",
                    "default": 99,
                    "icon": "Width"
                },
                {
                    "type": "input_int",
                    "text": "Size Y",
                    "alias": "config_ptht_world_size_y`id",
                    "default": 114,
                    "icon": "Height"
                },
                {
                    "type": "toggle",
                    "text": "Pathfinding for Planting",
                    "alias": "config_ptht_world_pathfind_plant`id",
                    "default": true,
                    "icon": "Explore"
                },
                {
                    "type": "toggle",
                    "text": "Pathfinding for Harvesting",
                    "alias": "config_ptht_world_pathfind_harvest`id",
                    "default": true,
                    "icon": "Explore"
                }
            ]
        },
        {
            "type": "dialog",
            "text": "Delay Settings",
            "support_text": "Timing Configuration",
            "fill": true,
            "menu": [
                {
                    "type": "input_int",
                    "text": "Plant Delay (ms)",
                    "alias": "config_ptht_delay_plant`id",
                    "default": 10,
                    "icon": "Timer"
                },
                {
                    "type": "input_int",
                    "text": "Harvest Delay (ms)",
                    "alias": "config_ptht_delay_harvest`id",
                    "default": 10,
                    "icon": "Timer"
                },
                {
                    "type": "input_int",
                    "text": "Remote Delay (ms)",
                    "alias": "config_ptht_delay_remote`id",
                    "default": 5000,
                    "icon": "Timer"
                },
                {
                    "type": "input_int",
                    "text": "Reconnect Delay (ms)",
                    "alias": "config_ptht_delay_reconnect`id",
                    "default": 60000,
                    "icon": "Timer"
                }
            ]
        },
        {
            "type": "dialog",
            "text": "Item Settings",
            "support_text": "Item ID Configuration",
            "fill": true,
            "menu": [
                {
                    "type": "input_int",
                    "text": "Platform ID",
                    "alias": "config_ptht_item_platform`id",
                    "default": 0,
                    "icon": "GridOn"
                },
                {
                    "type": "input_int",
                    "text": "Plant ID",
                    "alias": "config_ptht_item_plant`id",
                    "default": 1044,
                    "icon": "LocalFlorist"
                },
                {
                    "type": "input_int",
                    "text": "Harvest ID",
                    "alias": "config_ptht_item_harvest`id",
                    "default": 1044,
                    "icon": "Agriculture"
                },
                {
                    "type": "input_int",
                    "text": "Magplant ID",
                    "alias": "config_ptht_item_magplant`id",
                    "default": 9850,
                    "icon": "SettingsRemote"
                },
                {
                    "type": "input_int",
                    "text": "Background ID",
                    "alias": "config_ptht_item_background`id",
                    "default": 14,
                    "icon": "Wallpaper"
                }
            ]
        },
        {
            "type": "dialog",
            "text": "Magplant Features",
            "support_text": "Magplant Auto Features",
            "fill": true,
            "menu": [
                {
                    "type": "toggle",
                    "text": "Auto Take Remote",
                    "alias": "config_ptht_features_auto_take_remote`id",
                    "default": true,
                    "icon": "Cable"
                },
                {
                    "type": "toggle",
                    "text": "Auto Take When Empty",
                    "alias": "config_ptht_features_auto_take_empty`id",
                    "default": true,
                    "icon": "Cable"
                }
            ]
        },
        {
            "type": "dialog",
            "text": "Counter Settings",
            "support_text": "Cycle Counter Configuration",
            "fill": true,
            "menu": [
                {
                    "type": "toggle",
                    "text": "Use Cycle Counter",
                    "alias": "config_ptht_features_use_counter`id",
                    "default": false,
                    "icon": "Numbers"
                },
                {
                    "type": "input_int",
                    "text": "Cycle Limit",
                    "alias": "config_ptht_counter_limit`id",
                    "default": 10,
                    "icon": "Flag"
                },
                {
                    "type": "toggle",
                    "text": "Auto Restart After Limit",
                    "alias": "config_ptht_features_auto_restart`id",
                    "default": true,
                    "icon": "RestartAlt"
                }
            ]
        },
        {
            "type": "dialog",
            "text": "Manual Control",
            "support_text": "Manual Operations",
            "fill": true,
            "menu": [
                {
                    "type": "button",
                    "text": "Plant Only",
                    "alias": "btn_plant_only`id"
                },
                {
                    "type": "button",
                    "text": "Harvest Only",
                    "alias": "btn_harvest_only`id"
                },
                {
                    "type": "button",
                    "text": "Splice Mode",
                    "alias": "btn_splice_only`id"
                },
                {
                    "type": "divider"
                },
                {
                    "type": "button",
                    "text": "Scan Magplants",
                    "alias": "btn_scan_magplants`id"
                },
                {
                    "type": "button",
                    "text": "Take Remote",
                    "alias": "btn_take_remote`id"
                },
                {
                    "type": "button",
                    "text": "UWS Spray",
                    "alias": "btn_uws_spray`id"
                },
                {
                    "type": "button",
                    "text": "Reconnect",
                    "alias": "btn_reconnect`id"
                }
            ]
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
]]):gsub("`id", "!"..randomInt)

function isInTargetWorld()
    local worldName = GetWorldName()
    if worldName then
        return worldName == Config.world.name
    end
    return false
end

function reconnect()
    log("Reconnecting to " .. Config.world.name)
    sendPacket(3, "action|join_request\nname|" .. Config.world.name .. "|\ninvitedWorld|0")
    
    local timeout = 10
    local startTime = os.time()
    
    while os.time() - startTime < timeout do
        if isInTargetWorld() then
            log("Successfully reconnected!")
            return true
        end
        
        if stopRequested or not isRunning then
            return false
        end
        
        local delayStart = os.time()
        while os.time() - delayStart < 0.5 do end
    end
    
    log("Reconnect timeout!")
    return false
end

function scanForMagplants()
    foundMagplants = {}
    for x = 0, Config.world.size_x do
        for y = Config.world.size_y, 0, -1 do
            if stopRequested then return 0 end
            local tile = getTile(x, y)
            if tile and tile.fg == Config.item.magplant then
                if tile.bg == Config.item.background then
                    table.insert(foundMagplants, {x = x, y = y, bg = tile.bg})
                end
            end
        end
    end
    log("Found " .. #foundMagplants .. " magplants")
    magplantIndex = 1
    return #foundMagplants
end

function takeMagplant()
    if #foundMagplants == 0 then
        log("No magplants found")
        return false
    end
    if magplantIndex > #foundMagplants then
        log("All magplants taken, resetting...")
        magplantIndex = 1
        return false
    end
    local mag = foundMagplants[magplantIndex]
    log("Taking magplant " .. magplantIndex .. " at " .. mag.x .. "," .. mag.y)
    local tile = getTile(mag.x, mag.y)
    if tile and tile.fg == Config.item.magplant then
        sendPacket(2, "action|dialog_return\ndialog_name|itemsucker_block\ntilex|" .. mag.x .. "|\ntiley|" .. mag.y .. "|\nbuttonClicked|getplantationdevice\n\nchk_enablesucking|1\n")
        local start = os.time()
        while os.time() - start < Config.delay.remote / 1000 do end
        return true
    else
        log("Magplant not found")
        magplantIndex = magplantIndex + 1
        local start = os.time()
        while os.time() - start < 1 do end
        return takeMagplant()
    end
end

function findPath(x, y)
    if stopRequested then return end
    local localPlayer = getLocal()
    if not localPlayer then return end
    local px = math.floor(localPlayer.posX / 32)
    local py = math.floor(localPlayer.posY / 32)
    local jarax = x - px
    local jaray = y - py
    if jaray > 6 then
        for i = 1, math.floor(jaray / 6) do
            if stopRequested then return end
            py = py + 6
            local start = os.time()
            while os.time() - start < 0.02 do end
            FindPath(px, py)
            local start = os.time()
            while os.time() - start < 0.02 do end
        end
    elseif jaray < -6 then
        for i = 1, math.floor(jaray / -6) do
            if stopRequested then return end
            py = py - 6
            local start = os.time()
            while os.time() - start < 0.02 do end
            FindPath(px, py)
            local start = os.time()
            while os.time() - start < 0.02 do end
        end
    end
    if jarax > 8 then
        for i = 1, math.floor(jarax / 6) do
            if stopRequested then return end
            px = px + 6
            local start = os.time()
            while os.time() - start < 0.02 do end
            FindPath(px, py)
            local start = os.time()
            while os.time() - start < 0.02 do end
        end
    elseif jarax < -6 then
        for i = 1, math.floor(jarax / -6) do
            if stopRequested then return end
            px = px - 6
            local start = os.time()
            while os.time() - start < 0.02 do end
            FindPath(px, py)
            local start = os.time()
            while os.time() - start < 0.02 do end
        end
    end
    if stopRequested then return end
    local start = os.time()
    while os.time() - start < 0.02 do end
    FindPath(x, y)
    local start = os.time()
    while os.time() - start < 0.02 do end
end

function rawPacket(type, value, x, y)
    local player = getLocal()
    if not player then return end
    
    local packet = {
        type = type,
        value = value,
        x = x * 32,
        y = y * 32,
        px = x,
        py = y,
        state = 32,
        netid = player.netID
    }
    sendPacketRaw(false, packet)
end

function plantTile(x, y, id)
    if stopRequested then return end
    rawPacket(0, 0, x, y)
    rawPacket(3, id, x, y)
end

function punch(x, y)
    if stopRequested then return end
    plantTile(x, y, 18)
end

function fullCountReadyTrees()
    if stopRequested then return 0 end
    local treeCount = 0
    local startY, endY, stepY
    if Config.mode.planting_direction == "BottomToTop" then
        startY = Config.world.size_y
        endY = 0
        stepY = -1
    else
        startY = 0
        endY = Config.world.size_y
        stepY = 1
    end
    for x = 0, Config.world.size_x do
        if stopRequested then break end
        for y = startY, endY, stepY do
            if stopRequested then break end
            local tile = getTile(x, y)
            if tile and tile.fg == Config.item.harvest then
                if tile.extra and tile.extra.progress and tile.extra.progress >= 1.0 then
                    treeCount = treeCount + 1
                end
            end
        end
    end
    lastTreeCount = treeCount
    return treeCount
end

function findPathOT(x, y)
    if not Config.world.pathfind_plant or stopRequested then return end
    FindPath(x, y)
end

function findPathHT(x, y)
    if not Config.world.pathfind_harvest or stopRequested then return end
    FindPath(x, y)
end

function findTilesWithSeed(seedID)
    local tiles = {}
    for x = 0, Config.world.size_x do
        for y = 0, Config.world.size_y do
            local tile = getTile(x, y)
            if tile and tile.fg == seedID then
                table.insert(tiles, {x = x, y = y})
            end
        end
    end
    return tiles
end

function plantSpliceWithMagplant()
    log("Taking magplant 1...")
    if not takeMagplant() then
        log("Failed to take magplant 1")
        return false
    end
    log("Planting with seed1...")
    if Config.mode.plant_type == "Plat" then
        plantOnPlatSplicemag()
    else
        plantInAirSplicemag()
    end
    log("Taking magplant 2...")
    if not takeMagplant() then
        log("Failed to take magplant 2")
        return false
    end
    local seed1Tiles = findTilesWithSeed(Config.splice.seed1)
    for _, tile in ipairs(seed1Tiles) do
        if stopRequested then break end
        local tile = getTile(tile.x, tile.y)
        if tile and tile.fg == Config.splice.seed1 then
            plantTile(tile.x, tile.y, Config.splice.seed2)
            findPathOT(tile.x, tile.y)
            local start = os.time()
            while os.time() - start < Config.delay.plant / 1000 do end
        end
    end
    return true
end

function plantSpliceNormal()
    log("Planting seed1...")
    if Config.mode.plant_type == "Plat" then
        plantOnPlatSplice()
    else
        plantInAirSplice()
    end
    local seed1Tiles = findTilesWithSeed(Config.splice.seed1)
    for _, tile in ipairs(seed1Tiles) do
        if stopRequested then break end
        local tile = getTile(tile.x, tile.y)
        if tile and tile.fg == Config.splice.seed1 then
            plantTile(tile.x, tile.y, Config.splice.seed2)
            findPathOT(tile.x, tile.y)
            local start = os.time()
            while os.time() - start < Config.delay.plant / 1000 do end
        end
    end
    return true
end

function plantOnPlat()
    local startY, endY, stepY
    if Config.mode.planting_direction == "BottomToTop" then
        startY = Config.world.size_y
        endY = 0
        stepY = -1
    else
        startY = 0
        endY = Config.world.size_y
        stepY = 1
    end
    if Config.mode.direction == "Vertical" then
        for x = 0, Config.world.size_x do
            if stopRequested then return end
            local start = os.time()
            while os.time() - start < 0.001 do end
            for y = startY, endY, stepY do
                if stopRequested then return end
                local tile = getTile(x, y)
                local tileAbove = getTile(x, y - 1)
                if tile and tile.fg == Config.item.platform and tileAbove and tileAbove.fg == 0 then
                    plantTile(x, y - 1, Config.item.plant)
                    findPathOT(x, y - 1)
                    local start = os.time()
                    while os.time() - start < Config.delay.plant / 1000 do end
                end
            end
        end
    else
        for y = startY, endY, stepY do
            if stopRequested then return end
            local start = os.time()
            while os.time() - start < 0.001 do end
            for x = 0, Config.world.size_x do
                if stopRequested then return end
                local tile = getTile(x, y)
                local tileAbove = getTile(x, y - 1)
                if tile and tile.fg == Config.item.platform and tileAbove and tileAbove.fg == 0 then
                    plantTile(x, y - 1, Config.item.plant)
                    findPathOT(x, y - 1)
                    local start = os.time()
                    while os.time() - start < Config.delay.plant / 1000 do end
                end
            end
        end
    end
end

function plantInAir()
    local startY, endY, stepY
    if Config.mode.planting_direction == "BottomToTop" then
        startY = Config.world.size_y
        endY = 0
        stepY = -1
    else
        startY = 0
        endY = Config.world.size_y
        stepY = 1
    end
    if Config.mode.direction == "Vertical" then
        for x = 0, Config.world.size_x do
            if stopRequested then return end
            local start = os.time()
            while os.time() - start < 0.001 do end
            for y = startY, endY, stepY do
                if stopRequested then return end
                local tile = getTile(x, y)
                local tileAbove = getTile(x, y - 1)
                if tile and tile.fg == 0 then
                    plantTile(x, y, Config.item.plant)
                    findPathOT(x, y)
                    local start = os.time()
                    while os.time() - start < Config.delay.plant / 1000 do end
                end
            end
        end
    else
        for y = startY, endY, stepY do
            if stopRequested then return end
            local start = os.time()
            while os.time() - start < 0.001 do end
            for x = 0, Config.world.size_x do
                if stopRequested then return end
                local tile = getTile(x, y)
                local tileAbove = getTile(x, y - 1)
                if tile and tile.fg == 0 then
                    plantTile(x, y, Config.item.plant)
                    findPathOT(x, y)
                    local start = os.time()
                    while os.time() - start < Config.delay.plant / 1000 do end
                end
            end
        end
    end
end

function plantOnPlatSplice()
    local startY, endY, stepY
    if Config.mode.planting_direction == "BottomToTop" then
        startY = Config.world.size_y
        endY = 0
        stepY = -1
    else
        startY = 0
        endY = Config.world.size_y
        stepY = 1
    end
    if Config.mode.direction == "Vertical" then
        for x = 0, Config.world.size_x do
            if stopRequested then return end
            local start = os.time()
            while os.time() - start < 0.001 do end
            for y = startY, endY, stepY do
                if stopRequested then return end
                local tile = getTile(x, y)
                local tileAbove = getTile(x, y - 1)
                if tile and tile.fg == Config.item.platform and tileAbove and tileAbove.fg == 0 then
                    plantTile(x, y - 1, Config.splice.seed1)
                    findPathOT(x, y - 1)
                    local start = os.time()
                    while os.time() - start < Config.delay.plant / 1000 do end
                end
            end
        end
    else
        for y = startY, endY, stepY do
            if stopRequested then return end
            local start = os.time()
            while os.time() - start < 0.001 do end
            for x = 0, Config.world.size_x do
                if stopRequested then return end
                local tile = getTile(x, y)
                local tileAbove = getTile(x, y - 1)
                if tile and tile.fg == Config.item.platform and tileAbove and tileAbove.fg == 0 then
                    plantTile(x, y - 1, Config.splice.seed1)
                    findPathOT(x, y - 1)
                    local start = os.time()
                    while os.time() - start < Config.delay.plant / 1000 do end
                end
            end
        end
    end
end

function plantInAirSplice()
    local startY, endY, stepY
    if Config.mode.planting_direction == "BottomToTop" then
        startY = Config.world.size_y
        endY = 0
        stepY = -1
    else
        startY = 0
        endY = Config.world.size_y
        stepY = 1
    end
    if Config.mode.direction == "Vertical" then
        for x = 0, Config.world.size_x do
            if stopRequested then return end
            local start = os.time()
            while os.time() - start < 0.001 do end
            for y = startY, endY, stepY do
                if stopRequested then return end
                local tile = getTile(x, y)
                local tileAbove = getTile(x, y - 1)
                if tile and tile.fg == 0 then
                    plantTile(x, y, Config.splice.seed1)
                    findPathOT(x, y)
                    local start = os.time()
                    while os.time() - start < Config.delay.plant / 1000 do end
                end
            end
        end
    else
        for y = startY, endY, stepY do
            if stopRequested then return end
            local start = os.time()
            while os.time() - start < 0.001 do end
            for x = 0, Config.world.size_x do
                if stopRequested then return end
                local tile = getTile(x, y)
                local tileAbove = getTile(x, y - 1)
                if tile and tile.fg == 0 then
                    plantTile(x, y, Config.splice.seed1)
                    findPathOT(x, y)
                    local start = os.time()
                    while os.time() - start < Config.delay.plant / 1000 do end
                end
            end
        end
    end
end

function plantOnPlatSplicemag()
    local startY, endY, stepY
    if Config.mode.planting_direction == "BottomToTop" then
        startY = Config.world.size_y
        endY = 0
        stepY = -1
    else
        startY = 0
        endY = Config.world.size_y
        stepY = 1
    end
    if Config.mode.direction == "Vertical" then
        for x = 0, Config.world.size_x do
            if stopRequested then return end
            local start = os.time()
            while os.time() - start < 0.001 do end
            for y = startY, endY, stepY do
                if stopRequested then return end
                local tile = getTile(x, y)
                local tileAbove = getTile(x, y - 1)
                if tile and tile.fg == Config.item.platform and tileAbove and tileAbove.fg == 0 then
                    plantTile(x, y - 1, 5640)
                    findPathOT(x, y - 1)
                    local start = os.time()
                    while os.time() - start < Config.delay.plant / 1000 do end
                end
            end
        end
    else
        for y = startY, endY, stepY do
            if stopRequested then return end
            local start = os.time()
            while os.time() - start < 0.001 do end
            for x = 0, Config.world.size_x do
                if stopRequested then return end
                local tile = getTile(x, y)
                local tileAbove = getTile(x, y - 1)
                if tile and tile.fg == Config.item.platform and tileAbove and tileAbove.fg == 0 then
                    plantTile(x, y - 1, 5640)
                    findPathOT(x, y - 1)
                    local start = os.time()
                    while os.time() - start < Config.delay.plant / 1000 do end
                end
            end
        end
    end
end

function plantInAirSplicemag()
    local startY, endY, stepY
    if Config.mode.planting_direction == "BottomToTop" then
        startY = Config.world.size_y
        endY = 0
        stepY = -1
    else
        startY = 0
        endY = Config.world.size_y
        stepY = 1
    end
    if Config.mode.direction == "Vertical" then
        for x = 0, Config.world.size_x do
            if stopRequested then return end
            local start = os.time()
            while os.time() - start < 0.001 do end
            for y = startY, endY, stepY do
                if stopRequested then return end
                local tile = getTile(x, y)
                local tileAbove = getTile(x, y - 1)
                if tile and tile.fg == 0 then
                    plantTile(x, y, 5640)
                    findPathOT(x, y)
                    local start = os.time()
                    while os.time() - start < Config.delay.plant / 1000 do end
                end
            end
        end
    else
        for y = startY, endY, stepY do
            if stopRequested then return end
            local start = os.time()
            while os.time() - start < 0.001 do end
            for x = 0, Config.world.size_x do
                if stopRequested then return end
                local tile = getTile(x, y)
                local tileAbove = getTile(x, y - 1)
                if tile and tile.fg == 0 then
                    plantTile(x, y, 5640)
                    findPathOT(x, y)
                    local start = os.time()
                    while os.time() - start < Config.delay.plant / 1000 do end
                end
            end
        end
    end
end

function harvestType1()
    local startY, endY, stepY
    if Config.mode.planting_direction == "BottomToTop" then
        startY = Config.world.size_y
        endY = 0
        stepY = -1
    else
        startY = 0
        endY = Config.world.size_y
        stepY = 1
    end
    local initialTreeCount = fullCountReadyTrees()
    if initialTreeCount == 0 then
        return
    end
    local harvested = 0
    local harvestAttempts = 0
    local maxAttempts = initialTreeCount * 3
    while harvested < initialTreeCount and harvestAttempts < maxAttempts do
        harvestAttempts = harvestAttempts + 1
        if Config.mode.direction == "Horizontal" then
            for x = 0, Config.world.size_x do
                if stopRequested then return end
                local start = os.time()
                while os.time() - start < 0.001 do end
                for y = startY, endY, stepY do
                    if stopRequested then return end
                    local tile = getTile(x, y)
                    if tile and tile.fg == Config.item.harvest and tile.extra and tile.extra.progress and tile.extra.progress >= 1.0 then
                        local start = os.time()
                        while os.time() - start < Config.delay.harvest / 1000 do end
                        punch(x, y)
                        findPathHT(x, y)
                        harvested = harvested + 1
                    end
                end
            end
        else
            for y = startY, endY, stepY do
                if stopRequested then return end
                local start = os.time()
                while os.time() - start < 0.001 do end
                for x = 0, Config.world.size_x do
                    if stopRequested then return end
                    local tile = getTile(x, y)
                    if tile and tile.fg == Config.item.harvest and tile.extra and tile.extra.progress and tile.extra.progress >= 1.0 then
                        local start = os.time()
                        while os.time() - start < Config.delay.harvest / 1000 do end
                        punch(x, y)
                        findPathHT(x, y)
                        harvested = harvested + 1
                    end
                end
            end
        end
        local remainingTrees = fullCountReadyTrees()
        if remainingTrees == 0 then
            break
        end
        if harvestAttempts >= maxAttempts then
            break
        end
    end
end

function harvestType2()
    local startY, endY, stepY
    if Config.mode.planting_direction == "BottomToTop" then
        startY = Config.world.size_y
        endY = 0
        stepY = -1
    else
        startY = 0
        endY = Config.world.size_y
        stepY = 1
    end
    local initialTreeCount = fullCountReadyTrees()
    if initialTreeCount <= 0 then return end
    local harvested = 0
    local harvestAttempts = 0
    local maxAttempts = initialTreeCount * 3
    while harvested < initialTreeCount and harvestAttempts < maxAttempts do
        harvestAttempts = harvestAttempts + 1
        for y = startY, endY, stepY do
            if stopRequested then return end
            local start = os.time()
            while os.time() - start < 0.001 do end
            for x = 0, Config.world.size_x do
                if stopRequested then return end
                local tile = getTile(x, y)
                if tile and tile.fg == Config.item.harvest and tile.extra and tile.extra.progress and tile.extra.progress >= 1.0 then
                    local lp = getLocal()
                    if not lp then
                        local start = os.time()
                        while os.time() - start < 0.5 do end
                        break
                    end
                    local localX = math.floor(lp.posX / 32)
                    local localY = math.floor(lp.posY / 32)
                    local dy = y - localY
                    if x < localX and (dy > 6 or dy < -6) then
                        findPath(x, y)
                        local start = os.time()
                        while os.time() - start < Config.delay.harvest / 1000 do end
                    end
                    local cur = getTile(x, y)
                    if cur and cur.fg ~= 0 and getLocal() then
                        findPath(x, y)
                        local start = os.time()
                        while os.time() - start < 0.06 do end
                        if getLocal() then
                            punch(x, y)
                            harvested = harvested + 1
                            local start = os.time()
                            while os.time() - start < Config.delay.harvest / 1000 do end
                        end
                    end
                end
            end
        end
        if fullCountReadyTrees() == 0 then
            break
        end
    end
end

function harvestCrops()
    if stopRequested then return end
    local treeCount = fullCountReadyTrees()
    if treeCount == 0 then
        return
    end
    if Config.mode.harvest_type == 1 then
        harvestType1()
    else
        harvestType2()
    end
end

function sprayWorld()
    if stopRequested then return end
    local localPlayer = getLocal()
    if not localPlayer then return end
    local packet = {
        type = 3,
        x = localPlayer.posX,
        y = localPlayer.posY,
        px = math.floor(localPlayer.posX / 32),
        py = math.floor(localPlayer.posY / 32),
        state = 0,
        value = 5926,
        netid = localPlayer.netID
    }
    sendPacketRaw(false, packet)
    sendPacket(2, "action|dialog_return\ndialog_name|world_spray")
    local start = os.time()
    while os.time() - start < Config.delay.plant / 1000 do end
    lastTreeCount = fullCountReadyTrees()
end

function plantOnly()
    if Config.mode.order_mode == "PTHT" then
        local treeCount = fullCountReadyTrees()
        if treeCount > 0 then
            if Config.mode.harvest_type == 1 then
                harvestType1()
            else
                harvestType2()
            end
        end
        log("Start Planting")
        currentStatus = "Planting"
        if Config.mode.plant_type == "Plat" then
            plantOnPlat()
        else
            plantInAir()
        end
        if stopRequested then return end
        if Config.features.use_uws then
            sprayWorld()
        end
    else
        if Config.features.use_uws then
            sprayWorld()
        end
        log("Start Planting")
        currentStatus = "Planting"
        if Config.mode.plant_type == "Plat" then
            plantOnPlat()
        else
            plantInAir()
        end
    end
end

function harvestOnly()
    if Config.mode.order_mode == "PTHT" then
        local treeCount = fullCountReadyTrees()
        if treeCount > 0 then
            log("Start Harvesting")
            currentStatus = "Harvesting"
            if Config.mode.harvest_type == 1 then
                harvestType1()
            else
                harvestType2()
            end
        else
            log("No ready trees to harvest")
        end
    else
        local treeCount = fullCountReadyTrees()
        if treeCount > 0 then
            log("Start Harvesting")
            currentStatus = "Harvesting"
            if Config.mode.harvest_type == 1 then
                harvestType1()
            else
                harvestType2()
            end
        else
            log("No ready trees to harvest")
        end
        if stopRequested then return end
        if Config.features.use_uws then
            sprayWorld()
        end
    end
end

function runSpliceMode()
    log("Starting Splice Mode...")
    currentStatus = "Splice Planting"
    if Config.splice.mode == "Magplant" then
        plantSpliceWithMagplant()
    else
        plantSpliceNormal()
    end
    if stopRequested then return end
    if Config.features.use_uws then
        sprayWorld()
    end
    log("Splice planting completed!")
end

function runNormalMode()
    if Config.features.use_splice then
        runSpliceMode()
        return
    end
    if Config.mode.order_mode == "PTHT" then
        local treeCount = fullCountReadyTrees()
        if treeCount > 0 then
            log("Harvesting ready trees before planting...")
            currentStatus = "Harvesting"
            if Config.mode.harvest_type == 1 then
                harvestType1()
            else
                harvestType2()
            end
        end
        log("Start Planting")
        currentStatus = "Planting"
        if Config.mode.plant_type == "Plat" then
            plantOnPlat()
        else
            plantInAir()
        end
        if stopRequested then return end
        if Config.features.use_uws then
            sprayWorld()
            if stopRequested then return end
        end
        treeCount = fullCountReadyTrees()
        if treeCount > 0 then
            log("Start Harvesting")
            currentStatus = "Harvesting"
            harvestCrops()
        end
    else
        local treeCount = fullCountReadyTrees()
        if treeCount > 0 then
            log("Start Harvesting")
            currentStatus = "Harvesting"
            harvestCrops()
            if stopRequested then return end
        else
            log("No ready trees to harvest")
        end
        log("Start Planting")
        currentStatus = "Planting"
        if Config.mode.plant_type == "Plat" then
            plantOnPlat()
        else
            plantInAir()
        end
        if stopRequested then return end
        if Config.features.use_uws then
            sprayWorld()
        end
    end
end

function runFarmLoop()
    currentCycle = 0
    harvestCount = 0
    stopRequested = false
    isRunning = true
    magplantIndex = 1
    foundMagplants = {}
    log("Starting PTHT...")
    while isRunning and not stopRequested do
        if not isInTargetWorld() then
            log("Not in target world, reconnecting...")
            if not reconnect() then
                log("Reconnect failed, stopping script")
                break
            end
            if Config.features.auto_take_remote then
                magplantIndex = 1
            end
        else
            if Config.features.auto_take_remote then
                local start = os.time()
                while os.time() - start < 3 do end
                if stopRequested then break end
                scanForMagplants()
                takeMagplant()
            end
            runNormalMode()
            currentCycle = currentCycle + 1
            if Config.features.use_counter and currentCycle >= Config.counter.limit then
                log("PTHT limit reached: " .. currentCycle)
                if Config.features.auto_restart then
                    log("Restarting...")
                    local start = os.time()
                    while os.time() - start < 5 do end
                    currentCycle = 0
                else
                    break
                end
            end
            log("PTHT Cycle " .. currentCycle .. " Finished")
        end
        local start = os.time()
        while os.time() - start < 2 do end
        if stopRequested then break end
    end
    isRunning = false
    stopRequested = false
    currentStatus = "Idle"
    log("Script stopped! Final count: "..harvestCount)
end

function startFarming()
    if isRunning then
        log("Already running!")
        return
    end
    isRunning = true
    stopRequested = false
    log("Starting PTHT...")
    runThread(function()
        runFarmLoop()
    end)
end

function stopFarming()
    stopRequested = true
    log("Stopping PTHT...")
end

function startPlantOnly()
    if isRunning then
        log("Already running!")
        return
    end
    isRunning = true
    stopRequested = false
    log("Starting Plant Only...")
    runThread(function()
        stopRequested = false
        while isRunning and not stopRequested do
            if not isInTargetWorld() then
                if not reconnect() then
                    break
                end
                if Config.features.auto_take_remote then
                    magplantIndex = 1
                end
            else
                if Config.features.auto_take_remote then
                    local start = os.time()
                    while os.time() - start < 3 do end
                    if stopRequested then break end
                    scanForMagplants()
                    takeMagplant()
                end
                plantOnly()
                log("Plant Only Finished")
                break
            end
            local start = os.time()
            while os.time() - start < 2 do end
            if stopRequested then break end
        end
        isRunning = false
        stopRequested = false
        currentStatus = "Idle"
    end)
end

function startHarvestOnly()
    if isRunning then
        log("Already running!")
        return
    end
    isRunning = true
    stopRequested = false
    log("Starting Harvest Only...")
    runThread(function()
        stopRequested = false
        while isRunning and not stopRequested do
            if not isInTargetWorld() then
                if not reconnect() then
                    break
                end
                if Config.features.auto_take_remote then
                    magplantIndex = 1
                end
            else
                if Config.features.auto_take_remote then
                    local start = os.time()
                    while os.time() - start < 3 do end
                    if stopRequested then break end
                    scanForMagplants()
                    takeMagplant()
                end
                harvestOnly()
                log("Harvest Only Finished")
                break
            end
            local start = os.time()
            while os.time() - start < 2 do end
            if stopRequested then break end
        end
        isRunning = false
        stopRequested = false
        currentStatus = "Idle"
    end)
end

function startSpliceOnly()
    if isRunning then
        log("Already running!")
        return
    end
    isRunning = true
    stopRequested = false
    log("Starting Splice Mode...")
    runThread(function()
        stopRequested = false
        while isRunning and not stopRequested do
            if not isInTargetWorld() then
                if not reconnect() then
                    break
                end
                if Config.features.auto_take_remote then
                    magplantIndex = 1
                end
            else
                if Config.features.auto_take_remote then
                    local start = os.time()
                    while os.time() - start < 3 do end
                    if stopRequested then break end
                    scanForMagplants()
                    takeMagplant()
                end
                runSpliceMode()
                log("Splice Mode Finished")
                break
            end
            local start = os.time()
            while os.time() - start < 2 do end
            if stopRequested then break end
        end
        isRunning = false
        stopRequested = false
        currentStatus = "Idle"
    end)
end


AddHook(function(var)
    if var.v1 == "OnTalkBubble" and var.v2:find("empty!") then
        log("Detected empty magplant")
        runThread(function()
            local start = os.time()
            while os.time() - start < 5 do end
            magplantIndex = magplantIndex + 1
            takeMagplant()
        end)
        return false
    end
    return false
end, "OnVariant")

addHook(function(vtype, name, value)
    local alias, menuId = name:match("(.+)!(%d+)")
    if menuId ~= tostring(randomInt) then return end
    
    if alias == "config_ptht_toggle_start" then
        if value == true then
            if not isRunning then
                startFarming()
            end
        else
            stopFarming()
        end
        Config.toggle.start = value
        return
    end
    
    if vtype == 3 then
        if alias == "btn_stop_script" then
            stopFarming()
            editValue("config_ptht_toggle_start!"..randomInt, false)
            return
        elseif alias == "btn_plant_only" then
            startPlantOnly()
            return
        elseif alias == "btn_harvest_only" then
            startHarvestOnly()
            return
        elseif alias == "btn_splice_only" then
            startSpliceOnly()
            return
        elseif alias == "btn_scan_magplants" then
            runThread(scanForMagplants)
            return
        elseif alias == "btn_take_remote" then
            runThread(takeMagplant)
            return
        elseif alias == "btn_uws_spray" then
            sprayWorld()
            return
        elseif alias == "btn_reconnect" then
            reconnect()
            return
        elseif alias == "btn_test_seed1" then
            runThread(function()
                local tiles = findTilesWithSeed(Config.splice.seed1)
                log("Found " .. #tiles .. " tiles with seed1")
            end)
            return
        end
    end
    
    local category, field = alias:match("config_ptht_(%w+)_(.+)")
    if category and field and Config[category] then
        Config[category][field] = value
        
        if category == "mode" then
            if field == "direction" and value == true then
                editValue("config_ptht_mode_direction_h!"..randomInt, false)
                Config.mode.direction = "Vertical"
            elseif field == "direction_h" and value == true then
                editValue("config_ptht_mode_direction!"..randomInt, false)
                Config.mode.direction = "Horizontal"
            elseif field == "planting_direction_bt" and value == true then
                editValue("config_ptht_mode_planting_direction_tb!"..randomInt, false)
                Config.mode.planting_direction = "BottomToTop"
            elseif field == "planting_direction_tb" and value == true then
                editValue("config_ptht_mode_planting_direction_bt!"..randomInt, false)
                Config.mode.planting_direction = "TopToBottom"
            elseif field == "plant_type_p" and value == true then
                editValue("config_ptht_mode_plant_type_a!"..randomInt, false)
                Config.mode.plant_type = "Plat"
            elseif field == "plant_type_a" and value == true then
                editValue("config_ptht_mode_plant_type_p!"..randomInt, false)
                Config.mode.plant_type = "Air"
            elseif field == "harvest_type_1" and value == true then
                editValue("config_ptht_mode_harvest_type_2!"..randomInt, false)
                Config.mode.harvest_type = 1
            elseif field == "harvest_type_2" and value == true then
                editValue("config_ptht_mode_harvest_type_1!"..randomInt, false)
                Config.mode.harvest_type = 2
            elseif field == "order_mode_ptht" and value == true then
                editValue("config_ptht_mode_order_mode_htpt!"..randomInt, false)
                Config.mode.order_mode = "PTHT"
            elseif field == "order_mode_htpt" and value == true then
                editValue("config_ptht_mode_order_mode_ptht!"..randomInt, false)
                Config.mode.order_mode = "HTPT"
            end
        elseif category == "splice" then
            if field == "mode_normal" and value == true then
                editValue("config_ptht_splice_mode_magplant!"..randomInt, false)
                Config.splice.mode = "Normal"
            elseif field == "mode_magplant" and value == true then
                editValue("config_ptht_splice_mode_normal!"..randomInt, false)
                Config.splice.mode = "Magplant"
            end
        end
    end
end, "onValue")

addIntoModule(moduleJSON)
log("Grandfuscator PTHT Module Loaded")

else
LogToConsole("`w[`cGrandfuscator`w] Premium Script has expired")
end
