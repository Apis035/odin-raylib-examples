package core

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - keyboard input")
    defer CloseWindow()

    ballPosition: Vector2 = {f32(screenWidth)/2, f32(screenHeight)/2}

    SetTargetFPS(60)

    for !WindowShouldClose() {
        if IsKeyDown(.RIGHT) { ballPosition.x += 2 }
        if IsKeyDown(.LEFT)  { ballPosition.x -= 2 }
        if IsKeyDown(.UP)    { ballPosition.y -= 2 }
        if IsKeyDown(.DOWN)  { ballPosition.y += 2 }

        {
            BeginDrawing()
            defer EndDrawing()
            ClearBackground(RAYWHITE)
            DrawText("move the ball with arrow keys", 10, 10, 20, DARKGRAY)
            DrawCircleV(ballPosition, 50, MAROON)
        }
    }
}