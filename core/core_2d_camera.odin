package core

import "vendor:raylib"

MAX_BUILDINGS :: 100

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera")
    defer CloseWindow()

    player:      Rectangle = {400, 280, 40, 40}
    buildings:   [MAX_BUILDINGS]Rectangle
    buildColors: [MAX_BUILDINGS]Color

    spacing: i32

    for i := 0; i < MAX_BUILDINGS; i += 1 {
        buildings[i].width  = f32(GetRandomValue(50, 200))
        buildings[i].height = f32(GetRandomValue(100, 800))
        buildings[i].y      = f32(screenHeight) - 130 - buildings[i].height
        buildings[i].x      = -6000 + f32(spacing)

        spacing += i32(buildings[i].width)

        buildColors[i] = {u8(GetRandomValue(200, 240)), u8(GetRandomValue(200, 240)), u8(GetRandomValue(200,250)), 255}
    }

    camera: Camera2D
    camera.target = {player.x + 20, player.y + 20}
    camera.offset = {screenWidth/2, screenHeight/2}
    camera.rotation = 0
    camera.zoom = 1

    SetTargetFPS(60)

    for !WindowShouldClose() {
        if IsKeyDown(.RIGHT) {
            player.x += 2
        } else if IsKeyDown(.LEFT) {
            player.x -= 2
        }

        camera.target = {player.x + 20, player.y + 20}

        if IsKeyDown(.A) {
            camera.rotation -= 1
        } else if IsKeyDown(.S) {
            camera.rotation += 1
        }
        camera.rotation = clamp(camera.rotation, -40, 40)

        camera.zoom += GetMouseWheelMove() * 0.05
        camera.zoom = clamp(camera.zoom, 0.1, 3)

        if IsKeyPressed(.R) {
            camera.zoom = 1
            camera.rotation = 0
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)

            {
                BeginMode2D(camera)
                defer EndMode2D()

                DrawRectangle(-6000, 320, 13000, 8000, DARKGRAY)

                for i := 0; i < MAX_BUILDINGS; i += 1 {
                    DrawRectangleRec(buildings[i], buildColors[i])
                }

                DrawRectangleRec(player, RED)

                DrawLine(i32(camera.target.x), -screenHeight * 10, i32(camera.target.x), screenHeight * 10, GREEN)
                DrawLine(-screenWidth * 10, i32(camera.target.y), screenWidth * 10, i32(camera.target.y), GREEN)
            }

            DrawText("SCREEN AREA", 640, 10, 20, RED)

            DrawRectangle(0, 0, screenWidth, 5, RED)
            DrawRectangle(0, 5, 5, screenHeight - 10, RED)
            DrawRectangle(screenWidth - 5, 5, 5, screenHeight - 10, RED)
            DrawRectangle(0, screenHeight - 5, screenWidth, 5, RED)

            DrawRectangle(10, 10, 250, 113, Fade(SKYBLUE, 0.5))
            DrawRectangleLines(10, 10, 250, 113, BLUE)

            DrawText("Free 2d camera controls:", 20, 20, 10, BLACK)
            DrawText("- Right/Left to move Offset", 40, 40, 10, DARKGRAY)
            DrawText("- Mouse Wheel to Zoom in-out", 40, 60, 10, DARKGRAY)
            DrawText("- A / S to Rotate", 40, 80, 10, DARKGRAY)
            DrawText(" R to reset Zoom and Rotation", 40, 100, 10, DARKGRAY)
        }
    }
}