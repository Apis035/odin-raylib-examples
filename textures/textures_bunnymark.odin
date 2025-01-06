package textures

import "vendor:raylib"

MAX_BUNNIES :: 50000

MAX_BATCH_ELEMENTS :: 8192

Bunny :: struct {
    position: raylib.Vector2,
    speed: raylib.Vector2,
    color: raylib.Color,
}

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [textures] example - bunnymark")
    defer CloseWindow()

    texBunny := LoadTexture("resources/wabbit_alpha.png")
    defer UnloadTexture(texBunny)

    bunnies := new([MAX_BUNNIES]Bunny)
    defer free(bunnies)

    bunniesCount := 0

    SetTargetFPS(60)

    for !WindowShouldClose() {
        if IsMouseButtonDown(.LEFT) {
            for _ in 0..<100 {
                if bunniesCount < MAX_BUNNIES {
                    bunnies[bunniesCount].position = GetMousePosition()
                    bunnies[bunniesCount].speed.x  = f32(GetRandomValue(-250, 250))/60
                    bunnies[bunniesCount].speed.y  = f32(GetRandomValue(-250, 250))/60
                    bunnies[bunniesCount].color    = {
                        u8(GetRandomValue(50, 240)),
                        u8(GetRandomValue(80, 240)),
                        u8(GetRandomValue(100, 240)), 255,
                    }
                    bunniesCount += 1
                }
            }
        }

        for i in 0..<bunniesCount {
            bunnies[i].position += bunnies[i].speed

            if (i32(bunnies[i].position.x) + texBunny.width/2 > GetScreenWidth()) ||
               (i32(bunnies[i].position.x) + texBunny.width/2 < 0) {
                bunnies[i].speed.x *= -1
            }
            if (i32(bunnies[i].position.y) + texBunny.height/2 > GetScreenHeight()) ||
               (i32(bunnies[i].position.y) + texBunny.height/2 - 40 < 0) {
                bunnies[i].speed.y *= -1
            }
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)

            for i in 0..<bunniesCount {
                DrawTexture(texBunny, i32(bunnies[i].position.x), i32(bunnies[i].position.y), bunnies[i].color)
            }

            DrawRectangle(0, 0, screenWidth, 40, BLACK)
            DrawText(TextFormat("bunnies: %i", bunniesCount), 120, 10, 20, GREEN)
            DrawText(TextFormat("batched draw calls: %i", 1 + bunniesCount/MAX_BATCH_ELEMENTS), 320, 10, 20, MAROON)

            DrawFPS(10, 10)
        }
    }
}