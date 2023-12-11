package shapes

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    SetConfigFlags({.MSAA_4X_HINT})
    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - bouncing ball")
    defer CloseWindow()

    ballPosition: Vector2 = {f32(GetScreenWidth())/2, f32(GetScreenHeight())/2}
    ballSpeed:    Vector2 = {5, 4}
    ballRadius:           = 20

    pause         := false
    framesCounter := 0

    SetTargetFPS(60)

    for !WindowShouldClose() {
        if IsKeyPressed(.SPACE) do pause = !pause

        if !pause {
            ballPosition += ballSpeed
            if ballPosition.x >= f32(GetScreenWidth())  - f32(ballRadius) || ballPosition.x <= f32(ballRadius) do ballSpeed.x *= -1
            if ballPosition.y >= f32(GetScreenHeight()) - f32(ballRadius) || ballPosition.y <= f32(ballRadius) do ballSpeed.y *= -1
        } else {
            framesCounter += 1
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)
            DrawCircleV(ballPosition, f32(ballRadius), MAROON)

            if pause && (framesCounter/30 % 2) == 0 {
                DrawText("PAUSED", 350, 200, 30, GRAY)
            }

            DrawFPS(10, 10)
        }
    }
}