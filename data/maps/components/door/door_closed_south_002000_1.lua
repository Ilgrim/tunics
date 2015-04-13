local map, data = ...

local zentropy = require 'lib/zentropy'

local door = zentropy.inject_door(map:get_entity('doorway'), {
    savegame_variable = data.name,
    direction = 3,
    sprite = "entities/door_normal",
})
data.door_names.south = door:get_userdata():get_name()
