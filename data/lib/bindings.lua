local bindings = {}

local commands = {
    escape =    { buttons={1}, keys={'escape'} },
    map =       { buttons={2}, keys={'tab'} },
    pause = { buttons={3}, keys={'w'} },
    attack =    { buttons={4}, keys={'s'} },
    item_1 =    { buttons={5}, keys={'a'} },
    item_2 =    { buttons={6}, keys={'d'} },
    action =    { buttons={7}, keys={'space', 'return', 'kp return'} },
    up =        { keys={'up'} },
    down =      { keys={'down'} },
    left =      { keys={'left'} },
    right =     { keys={'right'} },
}

local axis_commands = {
    [0] = {
        [-1] = 'left',
        [1] = 'right',
    },
    [1] = {
        [-1] = 'up',
        [1] = 'down',
    },
}

function bindings.mixin(o)
    local keys = {}
    local buttons = {}
    for command, bindings in pairs(commands) do
        for _, key in ipairs(bindings.keys) do
            keys[key] = command
        end
        for _, button in ipairs(bindings.buttons or {}) do
            buttons[button] = command
        end
    end
    local axis_state = {}

    function o:on_key_pressed(key, modifiers)
        if keys[key] then
            if self.on_command_pressed then
                return self:on_command_pressed(keys[key])
            end
        else
            return true
        end
    end

    function o:on_key_released(key, modifiers)
        if keys[key] then
            if self.on_command_released then
                return self:on_command_released(keys[key])
            end
        else
            return true
        end
    end

    function o:on_joypad_button_pressed(button, modifiers)
        if buttons[button] and self.on_command_pressed then
            return self:on_command_pressed(buttons[button])
        end
    end

    function o:on_joypad_button_released(button, modifiers)
        if buttons[button] and self.on_command_released then
            return self:on_command_released(buttons[button])
        end
    end

    function o:on_joypad_axis_moved(axis, state)
        local old_state = axis_state[axis] or 0
        axis_state[axis] = state
        if state ~= 0 then
            if self.on_command_released then
                self:on_command_released(axis_commands[old_state])
            end
            if self.on_command_pressed then
                return self:on_command_pressed(axis_commands[state])
            end
        elseif old_state ~= 0 then
            if self.on_command_released then
                return self:on_command_released(axis_commands[old_state])
            end
        end
    end

end

return bindings
