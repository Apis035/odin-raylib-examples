package core

import "vendor:raylib"

PLAYER_SIZE :: 40

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 440

    InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera split screen")
    defer CloseWindow()

    player1: Rectangle = {200, 200, f32(PLAYER_SIZE), f32(PLAYER_SIZE)}
    player2: Rectangle = {250, 200, f32(PLAYER_SIZE), f32(PLAYER_SIZE)}

    camera1: Camera2D
    camera1.target = {player1.x, player1.y}
    camera1.offset = {200, 200}
    camera1.rotation = 0
    camera1.zoom = 1

    camera2: Camera2D
    camera2.target = {player2.x, player2.y}
    camera2.offset = {200, 200}
    camera2.rotation = 0
    camera2.zoom = 1

    screenCamera1 := LoadRenderTexture(screenWidth/2, screenHeight)
    screenCamera2 := LoadRenderTexture(screenWidth/2, screenHeight)
    defer UnloadRenderTexture(screenCamera1)
    defer UnloadRenderTexture(screenCamera2)

    splitScreenRect: Rectangle = {0, 0, f32(screenCamera1.texture.width), -f32(screenCamera1.texture.height)}

    SetTargetFPS(60)

    for !WindowShouldClose() {
        if IsKeyDown(.S) do player1.y += 3
        if IsKeyDown(.W) do player1.y -= 3
        if IsKeyDown(.D) do player1.x += 3
        if IsKeyDown(.A) do player1.x -= 3

        if IsKeyDown(.DOWN)  do player2.y += 3
        if IsKeyDown(.UP)    do player2.y -= 3
        if IsKeyDown(.RIGHT) do player2.x += 3
        if IsKeyDown(.LEFT)  do player2.x -= 3

        camera1.target = {player1.x, player1.y}
        camera2.target = {player2.x, player2.y}

        {
            BeginTextureMode(screenCamera1)
            defer EndTextureMode()

            ClearBackground(RAYWHITE)

            {
                BeginMode2D(camera1)
                defer EndMode2D()

                for i in 0..<screenWidth/PLAYER_SIZE + 1 {
                    DrawLineV({f32(PLAYER_SIZE*i), 0}, {f32(PLAYER_SIZE*i), f32(screenHeight)}, LIGHTGRAY)
                }

                for i in 0..<screenHeight/PLAYER_SIZE + 1 {
                    DrawLineV({0, f32(PLAYER_SIZE*i)}, {f32(screenWidth), f32(PLAYER_SIZE*i)}, LIGHTGRAY)
                }

                for i in 0..<screenWidth/PLAYER_SIZE {
                    for j in 0..<screenHeight/PLAYER_SIZE {
                        DrawText(TextFormat("[%i,%i]", i, j), i32(10 + PLAYER_SIZE*i), i32(15 + PLAYER_SIZE*j), 10, LIGHTGRAY)
                    }
                }

                DrawRectangleRec(player1, RED)
                DrawRectangleRec(player2, BLUE)
            }

            DrawRectangle(0, 0, GetScreenWidth()/2, 30, Fade(RAYWHITE, 0.6))
            DrawText("PLAYER1: W/S/A/D to move", 10, 10, 10, MAROON)
        }

        {
            BeginTextureMode(screenCamera2)
            defer EndTextureMode()

            ClearBackground(RAYWHITE)

            {
                BeginMode2D(camera2)
                defer EndMode2D()

                for i in 0..<screenWidth/PLAYER_SIZE + 1 {
                    DrawLineV({f32(PLAYER_SIZE*i), 0}, {f32(PLAYER_SIZE*i), f32(screenHeight)}, LIGHTGRAY)
                }

                for i in 0..<screenHeight/PLAYER_SIZE + 1 {
                    DrawLineV({0, f32(PLAYER_SIZE*i)}, {f32(screenWidth), f32(PLAYER_SIZE*i)}, LIGHTGRAY)
                }

                for i in 0..<screenWidth/PLAYER_SIZE {
                    for j in 0..<screenHeight/PLAYER_SIZE {
                        DrawText(TextFormat("[%i,%i]", i, j), i32(10 + PLAYER_SIZE*i), i32(15 + PLAYER_SIZE*j), 10, LIGHTGRAY)
                    }
                }

                DrawRectangleRec(player1, RED)
                DrawRectangleRec(player2, BLUE)
            }

            DrawRectangle(0, 0, GetScreenWidth()/2, 30, Fade(RAYWHITE, 0.6))
            DrawText("PLAYER2: UP/DOWN/LEFT/RIGHT to move", 10, 10, 10, DARKBLUE)
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(BLACK)

            DrawTextureRec(screenCamera1.texture, splitScreenRect, {0, 0}, WHITE)
            DrawTextureRec(screenCamera2.texture, splitScreenRect, {f32(screenWidth/2), 0}, WHITE)

            DrawRectangle(GetScreenWidth()/2 - 2, 0, 4, GetScreenHeight(), LIGHTGRAY)
        }
    }
}