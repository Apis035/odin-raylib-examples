package shapes

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - basic shapes drawing")
    defer CloseWindow()

    rotation: f32 = 0

    SetTargetFPS(60)

    for !WindowShouldClose() {
        rotation += 0.2

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)

            DrawText("some basic shapes available on raylib", 20, 20, 20, DARKGRAY)

            DrawCircle(screenWidth/5, 120, 35, DARKBLUE)
            DrawCircleGradient(screenWidth/5, 220, 60, GREEN, SKYBLUE)
            DrawCircleLines(screenWidth/5, 340, 80, DARKBLUE)

            DrawRectangle(screenWidth/4*2 - 60, 100, 120, 60, RED)
            DrawRectangleGradientH(screenWidth/4*2 - 90, 170, 180, 130, MAROON, GOLD)
            DrawRectangleLines(screenWidth/4*2 - 40, 320, 80, 60, ORANGE)

            fw := f32(screenWidth)

            DrawTriangle(
                {fw/4 * 3, 80},
                {fw/4 * 3 - 60, 150},
                {fw/4 * 3 + 60, 150}, VIOLET,
            )
            DrawTriangleLines(
                {fw/4 * 3, 160},
                {fw/4 * 3 - 60, 150},
                {fw/4 * 3 + 60, 150}, DARKBLUE,
            )

            DrawPoly({fw/4 * 3, 330}, 6, 80, rotation, BROWN)
            DrawPolyLines({fw/4 * 3, 330}, 6, 90, rotation, BROWN)
            DrawPolyLinesEx({fw/4 * 3, 330}, 6, 85, rotation, 6, BEIGE)

            DrawLine(18, 42, screenWidth -18, 42, BLACK)
        }
    }
}