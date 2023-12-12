package core

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera split screen")
    defer CloseWindow()

    cameraPlayer1: Camera
    cameraPlayer1.fovy       = 45
    cameraPlayer1.up.y       = 1
    cameraPlayer1.target.y   = 1
    cameraPlayer1.position.z = -3
    cameraPlayer1.position.y = 1

    screenPlayer1 := LoadRenderTexture(screenWidth/2, screenHeight)
    defer UnloadRenderTexture(screenPlayer1)
    
    cameraPlayer2: Camera
    cameraPlayer2.fovy       = 45
    cameraPlayer2.up.y       = 1
    cameraPlayer2.target.y   = 3
    cameraPlayer2.position.x = -3
    cameraPlayer2.position.y = 3
    
    screenPlayer2 := LoadRenderTexture(screenWidth/2, screenHeight)
    defer UnloadRenderTexture(screenPlayer2)

    splitScreenRect: Rectangle = {0, 0, f32(screenPlayer1.texture.width), -f32(screenPlayer1.texture.height)}

    count:   i32 = 5
    spacing: f32 = 4

    SetTargetFPS(60)

    for !WindowShouldClose() {
        offsetThisFrame := 10 * GetFrameTime()

        if IsKeyDown(.W) {
            cameraPlayer1.position.z += offsetThisFrame
            cameraPlayer1.target.z += offsetThisFrame
        }
        if IsKeyDown(.S) {
            cameraPlayer1.position.z -= offsetThisFrame
            cameraPlayer1.target.z -= offsetThisFrame
        }

        if IsKeyDown(.UP) {
            cameraPlayer2.position.x += offsetThisFrame
            cameraPlayer2.target.x += offsetThisFrame
        }
        if IsKeyDown(.DOWN) {
            cameraPlayer2.position.x -= offsetThisFrame
            cameraPlayer2.target.x -= offsetThisFrame
        }

        {
            BeginTextureMode(screenPlayer1)
            defer EndTextureMode()

            ClearBackground(SKYBLUE)

            {
                BeginMode3D(cameraPlayer1)
                defer EndMode3D()

                DrawPlane({0, 0, 0}, {50, 50}, BEIGE)

                for x := -f32(count)*spacing; x <= f32(count)*spacing; x += spacing {
                    for z := -f32(count)*spacing; z <= f32(count)*spacing; z += spacing {
                        DrawCube({x, 1.5, z}, 1, 1, 1, LIME)
                        DrawCube({x, 0.5, z}, 0.25, 1, 0.25, BROWN)
                    }
                }

                DrawCube(cameraPlayer1.position, 1, 1, 1, RED)
                DrawCube(cameraPlayer2.position, 1, 1, 1, BLUE)
            }

            DrawRectangle(0, 0, GetScreenWidth()/2, 40, Fade(RAYWHITE, 0.8))
            DrawText("PLAYER 1: W/S to move", 10, 10, 20, MAROON)
        }

        {
            BeginTextureMode(screenPlayer2)
            defer EndTextureMode()

            ClearBackground(SKYBLUE)

            {
                BeginMode3D(cameraPlayer2)
                defer EndMode3D()

                DrawPlane({0, 0, 0}, {50, 50}, BEIGE)

                for x := -f32(count)*spacing; x <= f32(count)*spacing; x += spacing {
                    for z := -f32(count)*spacing; z <= f32(count)*spacing; z += spacing {
                        DrawCube({x, 1.5, z}, 1, 1, 1, LIME)
                        DrawCube({x, 0.5, z}, 0.25, 1, 0.25, BROWN)
                    }
                }

                DrawCube(cameraPlayer1.position, 1, 1, 1, RED)
                DrawCube(cameraPlayer2.position, 1, 1, 1, BLUE)
            }

            DrawRectangle(0, 0, GetScreenWidth()/2, 40, Fade(RAYWHITE, 0.8))
            DrawText("PLAYER 2: UP/DOWN to move", 10, 10, 20, DARKBLUE)
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(BLACK)

            DrawTextureRec(screenPlayer1.texture, splitScreenRect, {0, 0}, WHITE)
            DrawTextureRec(screenPlayer2.texture, splitScreenRect, {f32(screenWidth)/2, 0}, WHITE)

            DrawRectangle(GetScreenWidth()/2 - 2, 0, 4, GetScreenHeight(), LIGHTGRAY)
        }
    }
}