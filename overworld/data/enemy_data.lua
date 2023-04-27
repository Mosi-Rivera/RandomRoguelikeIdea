return {
    {
        name = 'blob',
        cast_speed = 0.5,
        move_speed = 1,
        power = 10,
        resistance = 10,
        overworld_anims = {
            {
                name = 'idle',
                sprite = 'ow_enemies',
                quads = 'ow_enemies',
                fps = 8,
                frames = {1},
                default = true,
                config = {
                    yoyo = true,
                    ox = 0.5,
                    oy = 1,
                    width = 32,
                    height = 32
                }
            }
        },
        anims = {
            {
                name = 'idle',
                sprite = 'enemies',
                quads = 'enemies',
                fps = 8,
                frames = {1, 2},
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
                sprite = 'enemies',
                quads = 'enemies',
                fps = 8,
                frames = {1, 2, 3},
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
                sprite = 'enemies',
                quads = 'enemies',
                fps = 8,
                width = 45,
                height = 60,
                frames = {2, 3, 4},
                config = {
                    ox = 0.5,
                    oy = 1,
                    width = 45,
                    height = 60
                }
            }
        }
    },
    {
        name = 'lizardmen',
        cast_speed = 0.5,
        move_speed = 1,
        power = 10,
        resistance = 10,
        overworld_anims = {
            {
                name = 'idle',
                sprite = 'ow_enemies',
                quads = 'ow_enemies',
                fps = 8,
                frames = {2},
                default = true,
                config = {
                    yoyo = true,
                    ox = 0.5,
                    oy = 1,
                    width = 32,
                    height = 32
                }
            }
        },
        anims = {
            {
                name = 'idle',
                sprite = 'enemies',
                quads = 'enemies',
                fps = 8,
                frames = {1, 2},
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
                sprite = 'enemies',
                quads = 'enemies',
                fps = 8,
                frames = {1, 2, 3},
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
                sprite = 'enemies',
                quads = 'enemies',
                fps = 8,
                width = 45,
                height = 60,
                frames = {2, 3, 4},
                config = {
                    ox = 0.5,
                    oy = 1,
                    width = 45,
                    height = 60
                }
            }
        }
    },
    {
        name = 'lich',
        cast_speed = 0.5,
        move_speed = 1,
        power = 10,
        resistance = 10,
        overworld_anims = {
            {
                name = 'idle',
                sprite = 'ow_enemies',
                quads = 'ow_enemies',
                fps = 8,
                frames = {3},
                default = true,
                config = {
                    yoyo = true,
                    ox = 0.5,
                    oy = 1,
                    width = 32,
                    height = 32
                }
            }
        },
        anims = {
            {
                name = 'idle',
                sprite = 'enemies',
                quads = 'enemies',
                fps = 8,
                frames = {1, 2},
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
                sprite = 'enemies',
                quads = 'enemies',
                fps = 8,
                frames = {1, 2, 3},
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
                sprite = 'enemies',
                quads = 'enemies',
                fps = 8,
                width = 45,
                height = 60,
                frames = {2, 3, 4},
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