return {
    {
        name = 'bobby',
        hp = 10,
        cast_speed = 0.5,
        move_speed = 1,
        power = 10,
        resistance = 10,
        overworld_anims = {
            {
                name = 'idle',
                sprite = 'ow_characters',
                quads = 'ow_characters',
                fps = 8,
                frames = {1, 2, 3},
                default = true,
                config = {
                    yoyo = true,
                    ox = 0.5,
                    oy = 1,
                    width = 48,
                    height = 48,
                }
            }
        },
        anims = {
            {
                name = 'idle',
                sprite = 'characters',
                quads = 'characters',
                fps = 8,
                frames = {1, 2, 3},
                default = true,
                config = {
                    yoyo = true,
                    ox = 0.5,
                    oy = 1,
                    width = 45,
                    height = 60,
                }
            },
            {
                name = 'move',
                sprite = 'characters',
                quads = 'characters',
                fps = 8,
                frames = {2, 3, 4},
                config = {
                    yoyo = true,
                    ox = 0.5,
                    oy = 1,
                    width = 45,
                    height = 60,
                }
            },
            {
                name = 'cast',
                sprite = 'characters',
                quads = 'characters',
                fps = 8,
                width = 45,
                height = 60,
                frames = {5, 6, 7, 8},
                config = {
                    ox = 0.5,
                    oy = 1,
                    width = 45,
                    height = 60
                }
            }
        }
    }
}