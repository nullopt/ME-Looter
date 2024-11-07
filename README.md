# ME-Looter

## Overview

The `ME-Looter` is a Lua script designed to interact with the Grand Exchange API to fetch item data and automate the looting process. It identifies items within a specified range and loots them based on their price.

## Features

- **Fetch Item Data**: Downloads and parses item data from the Grand Exchange API.
- **Identify Items in Range**: Scans for items within a specified distance.
- **Loot Based on Price**: Automatically loots items that meet a minimum price threshold.

## Classes

### GEData

A class representing the data structure for Grand Exchange items, including fields like `id`, `name`, `price`, and more.

### Looter

A class responsible for managing the looting process.

#### Methods

- `Looter:new(defaultItemPrice)`: Initializes a new instance of the Looter class.
- `Looter:loadItemData()`: Loads item data from the Grand Exchange API.
- `Looter:getUnnotedItemId(itemId)`: (TODO) Retrieves the unnoted version of an item.
- `Looter:getItemsInRange(maxDistance)`: Returns a list of items within a specified distance.
- `Looter:lootItemsBasedOnPrice(minimumPrice, maxDistance)`: Loots items that have a price greater than or equal to the specified minimum price.

## Usage

1. **Initialize the Looter**: Create an instance of the `Looter` class with a default item price incase the item is not found in the API.

   ```lua
   local looter = Looter:new(100) -- Example: default price 100
   ```

2. **Load Item Data**: Call the `loadItemData` method to fetch and parse item data from the Grand Exchange.

   ```lua
   looter:loadItemData()
   ```

3. **Loot Items**: Use the `lootItemsBasedOnPrice` method to loot items within a certain range and above a specified price.

   ```lua
   looter:lootItemsBasedOnPrice(500, 10) -- Example: minimum price 500, max distance 10
   ```

## Dependencies

- **API**: A module required for reading objects and performing actions.
- **JSON**: A module for decoding JSON data.

## Notes

- TODO: The `getUnnotedItemId` method is currently a placeholder and needs implementation.
- TODO: A check for full inventory is needed, as well as checking if the item is stackable and already in the inventory.

- Ensure that the necessary API and JSON modules are available in your environment.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.