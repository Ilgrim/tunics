local Class = require 'lib/class'
local MWC = require 'lib/mwc_rng'

local Prng = Class:new()

function Prng.from_seed(seed)
    return Prng:new{seed=seed}
end

function Prng:random(a, b)
    if not self.mode then
        self.mode = 'number'
        self.mwc = MWC.MakeGenerator(self.seed, self.seed)
    elseif self.mode ~= 'number' then
        error('cannot call random from state ' .. self.mode)
    end

    local bits = self.mwc()
    if a then
        if not b then
            a, b = 1, a
        end

        return a + bits % (b - a + 1)
    else
        return bits * 2.328306e-10
    end
end

function Prng:create()
    if not self.mode then
        self.mode = 'factory'
        self.mwc = MWC.MakeGenerator(self.seed, self.seed)
    elseif self.mode ~= 'factory' then
        error('cannot call create from state ' .. self.mode)
    end
    local bits = self.mwc()
    return Prng.from_seed(bits)
end

function Prng:biased(bias)
    if not self.mode then
        self.mode = 'biased'
    elseif self.mode ~= 'biased' then
        error('cannot call biased from state ' .. self.mode)
    end
    return Prng.from_seed(self.seed + bias)
end

return Prng
