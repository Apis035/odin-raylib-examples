package core

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - window should close")
    defer CloseWindow()

    SetExitKey(.KEY_NULL)

    exitWindow, exitWindowRequested := false, false

    SetTargetFPS(60)

    for !exitWindow {
        if (WindowShouldClose() || IsKeyPressed(.ESCAPE)) {
            exitWindowRequested = true
        }

        if exitWindowRequested {
            if IsKeyPressed(.Y) {
                exitWindow = true
            } else if IsKeyPressed(.N) {
                exitWindowRequested = false
            }
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)

            if exitWindowRequested {
                DrawRectangle(0, 100, screenWidth, 200, BLACK)
                DrawText("Are you sure you want to exit program? [Y/N]", 40, 180, 30, WHITE)
            } else {
                DrawText("Try to close the window to get confirmation message!", 120, 200, 20, LIGHTGRAY)
            }
        }
    }
}