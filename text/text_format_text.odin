package text

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [text] example - text formatting")
    defer CloseWindow()

    score:   i32 = 100020
    hiscore: i32 = 200450
    lives:   i32 = 5

    SetTargetFPS(60)

    for !WindowShouldClose() {
        BeginDrawing()
        ClearBackground(RAYWHITE)
        DrawText(TextFormat("Score: %08i", score), 200, 80, 20, RED)
        DrawText(TextFormat("HiScore: %08i", hiscore), 200, 120, 20, GREEN)
        DrawText(TextFormat("Lives: %02i", lives), 200, 160, 40, BLUE)
        DrawText(TextFormat("Elapsed Time: %02.02f ms", GetFrameTime() * 1000), 200, 220, 20, BLACK)
        EndDrawing()
    }
}