local family_tier = {
    cave = 1,
    smoothbrick = 2,
    brick = 2,
    ice = 2,
    ganon = 6,
    house = 10,
}

local family_music = {
    brick = {
        'dungeon_dark',
        'dungeon_light',
    },
    smoothbrick = {
        'dungeon_castle',
        'dungeon_dark',
        'dungeon_light',
    },
    cave = {
        'dungeon_cave',
        'dungeon_dark',
        'dungeon_light',
    },
    ice = {
        'dungeon_castle',
        'dungeon_dark',
        'dungeon_light',
    },
    house = {
        'dungeon_castle',
        'dungeon_village',
    },
    ganon = {
        'dungeon_castle',
        'dungeon_dark',
    },
}

local family_destructibles = {
    smoothbrick = {
        vase = 'vase',
        glove1 = 'stone_white',
        glove2 = 'stone_black',
    },
    house = {
        vase = 'vase',
        glove1 = 'stone_white',
        glove2 = 'stone_black',
    },
    brick = {
        vase = 'vase_skull',
        glove1 = 'stone_white_skull',
        glove2 = 'stone_black_skull',
    },
    cave = {
        vase = 'vase_skull',
        glove1 = 'stone_white_skull',
        glove2 = 'stone_black_skull',
    },
    ganon = {
        vase = 'vase_skull',
        glove1 = 'stone_white_skull',
        glove2 = 'stone_black_skull',
    },
    ice = {
        vase = 'vase_skull',
        glove1 = 'stone_white_skull',
        glove2 = 'stone_black_skull',
    },
}

local enemy_tier = {
    tentacle = 1,
    simple_green_soldier = 1,
    ropa = 2,
    green_knight_soldier = 2,
    blue_knight_soldier = 3,
    red_knight_soldier = 4,
    red_hardhat_beetle = 4,
    red_hemlasaur = 5,
    bubble = 6,
    gibdo = 6,
}

local function choose_family(current_tier, rng)
    local mode = 'past'
    local families = {}
    for f, tier in pairs(family_tier) do
        if tier == current_tier then
            if mode == 'past' then
                families = {}
                mode = 'current'
            end
            table.insert(families, f)
        elseif tier <= current_tier and mode == 'past' then
            table.insert(families, f)
        end
    end
    local i, family = rng:ichoose(families)
    return family
end

local function get_enemies(current_tier)
    local enemies = {}
    for enemy, tier in pairs(enemy_tier) do
        if tier <= current_tier then
            table.insert(enemies, enemy)
        end
    end
    return enemies
end

local mappings = {}

function mappings.choose(current_tier, rng)
    local family = choose_family(current_tier, rng:refine('family'))
    local _, music = rng:refine('music'):ichoose(family_music[family])
    local _, destructibles = rng:refine('music'):ichoose(family_destructibles[family])
    local enemies = get_enemies(current_tier)
    return {
        family=family,
        music=music,
        destructibles=destructibles,
        enemies=enemies,
    }
end

return mappings
