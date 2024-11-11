--[[
    File: looter.lua
    Description: This file contains the Looter class which manages the looting of items based on their price.
    Author: nullopt
    Version: 1.1.0

    TODO:
    - Implement the getUnnotedItemId function
    - Implement delay between looting using TIMER so that it doesn't loot random items
    - Implement stack looting, that will bypass inventory full check
]]

local API = require("api")

---@class GEData
---@field examine? string
---@field id? number
---@field members? boolean
---@field lowalch? number
---@field limit? number
---@field value? number
---@field highalch? number
---@field icon? string
---@field name? string
---@field name_pt? string
---@field price? number
---@field last? number
---@field volume? number
local GEData = {}

---@class Looter
---@field itemData table<string, GEData>
---@field defaultItemPrice number
local Looter = {}
Looter.__index = Looter

---@param defaultItemPrice number default price if item is not found
function Looter:new(defaultItemPrice)
    local instance = setmetatable({}, Looter)

    ---@type table<string, GEData>
    instance.itemData = {}
    ---@type number
    instance.defaultItemPrice = defaultItemPrice

    instance:loadItemData()
    return instance
end

---@private
---@return nil
function Looter:loadItemData()
    -- uses the Grand Exchange API from the wiki:
    -- https://runescape.wiki/w/RuneScape:Grand_Exchange_Market_Watch/Usage_and_APIs#Bulk_data_API
    local url = "https://chisel.weirdgloop.org/gazproj/gazbot/rs_dump.json"
    print("Downloading item data from the Grand Exchange...")
    local handle = io.popen("curl -s " .. url)
    if not handle then
        print("Failed to open cURL handle")
        return
    end
    local response = handle:read("*a")
    handle:close()
    print("Download complete! - Parsing JSON...")

    ---@type table<string, GEData>
    local json_value = JsonDecode(response)

    local count = 0
    for _ in pairs(json_value) do
        count = count + 1
    end
    self.itemData = json_value
    print("JSON parsing complete! - " .. count .. " items loaded.")
end

---@private
---@param itemId number
---@return number
function Looter:getUnnotedItemId(itemId)
    -- TODO: implement
    return itemId
end

---@private
---@param maxDistance number
---@return AllObject[]
function Looter:getItemsInRange(maxDistance)
    ---@type AllObject[]
    local allGroundItems = API.ReadAllObjectsArray({ 3 }, { -1 }, {})

    ---@type AllObject[]
    local itemIdsInRange = {}
    for _, item in ipairs(allGroundItems) do
        if item.Distance <= maxDistance then
            table.insert(itemIdsInRange, item)
        end
    end
    return itemIdsInRange
end

---@param minimumPrice number
---@param maxDistance number
---@return nil
function Looter:lootItemsBasedOnPrice(minimumPrice, maxDistance)
    ---@type AllObject[]
    local itemIdsInRange = self:getItemsInRange(maxDistance)

    ---@type number[]
    local itemsToLoot = {}
    for _, item in ipairs(itemIdsInRange) do
        ---@type GEData
        local itemData = self.itemData[tostring(item.Id)]
        if not itemData or itemData.price == nil then
            itemData = {
                id = item.Id,
                name = tostring(item.Id),
                price = self.defaultItemPrice
            }
        end
        -- todo: fix for noted items
        if itemData.price ~= nil and itemData.price >= minimumPrice then
            print("Found an item that is worth looting: " .. itemData.name .. " Price: " .. itemData.price)
            table.insert(itemsToLoot, item.Id)
        end
    end

    if not API.InvFull_() then
        API.DoAction_Loot_w(itemsToLoot, maxDistance, API.PlayerCoordfloat(), maxDistance)
    end
end

---@param itemsToLoot number[]
---@param minimumPrice number
---@param maxDistance number
---@return nil
function Looter:lootSelectedItemsAndBasedOnPrice(itemsToLoot, minimumPrice, maxDistance)
    self:lootItemsBasedOnPrice(minimumPrice, maxDistance)

    if not API.InvFull_() then
        API.DoAction_Loot_w(itemsToLoot, maxDistance, API.PlayerCoordfloat(), maxDistance)
        return
    end
end

return Looter
