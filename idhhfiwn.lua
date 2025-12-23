endtime=load('return os.time{year=2025, month=12, day=1, hour=0,min=0, sec=0}')()
if(os.time()<endtime) then

Config = {
    mode = {
        direction = "Vertical",
        planting_direction = "BottomToTop",
        plant_type = "Plat",
        harvest_type = 1,
        order_mode = "PTHT"
    },
    world = {
        name = "ZONA",
        size_x = 99,
        size_y = 114,
        pathfind_plant = true,
        pathfind_harvest = true
    },
    delay = {
        plant = 10,
        harvest = 10,
        remote = 5000,
        reconnect = 60000
    },
    item = {
        plant = 1044,
        harvest = 1044,
        platform = 0,
        magplant = 9850,
        background = 14
    },
    features = {
        use_uws = true,
        auto_take_remote = true,
        auto_take_empty = true,
        use_counter = false,
        auto_restart = true,
        use_splice = false
    },
    splice = {
        mode = "Magplant",
        seed1 = 1044,
        seed2 = 1062,
        magplant1 = 9850,
        magplant2 = 9850
    },
    counter = {
        limit = 10
    },
    toggle = {
        start = false
    }
}

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

addHook(function(vtype, name, value)
    local alias, menuId = name:match("(.+)!(%d+)")
    if menuId ~= tostring(randomInt) then return end
    
    if vtype == 3 then
        if alias == "btn_stop_script" then
            stopRequested = true
            editValue("config_ptht_toggle_start!"..randomInt, false)
            log("Script stopped by user")
            return
        elseif alias == "btn_plant_only" then
            RunThread(function()
                startPlantOnly()
            end)
            log("Plant Only Started!")
            return
        elseif alias == "btn_harvest_only" then
            RunThread(function()
                startHarvestOnly()
            end)
            log("Harvest Only Started!")
            return
        elseif alias == "btn_splice_only" then
            RunThread(function()
                startSpliceOnly()
            end)
            log("Splice Mode Started!")
            return
        elseif alias == "btn_scan_magplants" then
            RunThread(function()
                scanForMagplants()
            end)
            log("Scanning magplants...")
            return
        elseif alias == "btn_take_remote" then
            RunThread(function()
                takeMagplant()
            end)
            log("Taking magplant...")
            return
        elseif alias == "btn_uws_spray" then
            RunThread(function()
                sprayWorld()
            end)
            log("UWS Spray activated!")
            return
        elseif alias == "btn_reconnect" then
            RunThread(function()
                reconnect()
            end)
            log("Reconnecting...")
            return
        elseif alias == "btn_test_seed1" then
            RunThread(function()
                local tiles = findTilesWithSeed(Config.splice.seed1)
                log("Found " .. #tiles .. " tiles with seed1 (ID: " .. Config.splice.seed1 .. ")")
            end)
            return
        end
    end
    
    if alias == "config_ptht_toggle_start" then
        if value == true then
            if not isRunning then
                isRunning = true
                stopRequested = false
                RunThread(function()
                    runFarmLoop()
                end)
                log("PTHT Started!")
            end
        else
            if isRunning then
                stopRequested = true
                log("Stopping PTHT...")
            end
        end
        Config.toggle.start = value
        return
    end
    
    local category, field = alias:match("config_ptht_(%w+)_(.+)")
    if category and field and Config[category] then
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
            else
                Config[category][field] = value
            end
        else
            Config[category][field] = value
        end
    end
end, "onValue")

function updateStatus()
    currentStatus = isRunning and "Running" or "Idle"
    if stopRequested and isRunning then
        currentStatus = "Stopping"
    end
    log("Status: " .. currentStatus .. " | Cycle: " .. currentCycle .. " | Trees: " .. lastTreeCount)
end

addIntoModule(moduleJSON)

log("Grandfuscator PTHT Module Loaded")
log("Version 3.1")

ChangeValue("ModFly", true)

else
LogToConsole("`w[`cGrandfuscator`w] Premium Script has expired")
end
