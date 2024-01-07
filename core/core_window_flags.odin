package core

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - window flags")
    defer CloseWindow()

    ballPosition: Vector2 = { f32(GetScreenWidth()) / 2, f32(GetScreenHeight()) / 2 }
    ballSpeed:    Vector2 = { 5, 4 }
    ballRadius:   f32     = 20

    framesCounter := 0

    for !WindowShouldClose() {
        if IsKeyPressed(.F) {
            ToggleFullscreen()
        }

        if IsKeyPressed(.R) {
            if IsWindowState({.WINDOW_RESIZABLE}) {
                ClearWindowState({.WINDOW_RESIZABLE})
            } else {
                SetWindowState({.WINDOW_RESIZABLE})
            }
        }

        if IsKeyPressed(.D) {
            if IsWindowState({.WINDOW_UNDECORATED}) {
                ClearWindowState({.WINDOW_UNDECORATED})
            } else {
                SetWindowState({.WINDOW_UNDECORATED})
            }
        }

        if IsKeyPressed(.H) {
            if !IsWindowState({.WINDOW_HIDDEN}) {
                SetWindowState({.WINDOW_HIDDEN})
            }
            framesCounter = 0
        }

        if IsWindowState({.WINDOW_HIDDEN}) {
            framesCounter += 1
            if framesCounter >= 240 {
                ClearWindowState({.WINDOW_HIDDEN})
            }
        }

        if IsKeyPressed(.N) {
            if !IsWindowState({.WINDOW_MINIMIZED}) {
                MinimizeWindow()
            }
            framesCounter = 0
        }

        if IsWindowState({.WINDOW_MINIMIZED}) {
            framesCounter += 1
            if framesCounter >= 240 {
                RestoreWindow()
            }
        }

        if IsKeyPressed(.M) {
            if IsWindowState({.WINDOW_MAXIMIZED}) {
                RestoreWindow()
            } else {
                MaximizeWindow()
            }
        }

        if IsKeyPressed(.U) {
            if IsWindowState({.WINDOW_UNFOCUSED}) {
                ClearWindowState({.WINDOW_UNFOCUSED})
            } else {
                SetWindowState({.WINDOW_UNFOCUSED})
            }
        }

        if IsKeyPressed(.T) {
            if IsWindowState({.WINDOW_TOPMOST}) {
                ClearWindowState({.WINDOW_TOPMOST})
            } else {
                SetWindowState({.WINDOW_TOPMOST})
            }
        }

        if IsKeyPressed(.A) {
            if IsWindowState({.WINDOW_ALWAYS_RUN}) {
                ClearWindowState({.WINDOW_ALWAYS_RUN})
            } else {
                SetWindowState({.WINDOW_ALWAYS_RUN})
            }
        }

        if IsKeyPressed(.V) {
            if IsWindowState({.VSYNC_HINT}) {
                ClearWindowState({.VSYNC_HINT})
            } else {
                SetWindowState({.VSYNC_HINT})
            }
        }

        ballPosition += ballSpeed
        if ballPosition.x >= (f32(GetScreenWidth())  - ballRadius) || ballPosition.x <= ballRadius {
            ballSpeed.x *= -1
        }
        if ballPosition.y >= (f32(GetScreenHeight()) - ballRadius) || ballPosition.y <= ballRadius {
            ballSpeed.y *= -1
        }

        {
            BeginDrawing()
            defer EndDrawing()

            if IsWindowState({.WINDOW_TRANSPARENT}) {
                ClearBackground(BLANK)
            } else {
                ClearBackground(RAYWHITE)
            }

            DrawCircleV(ballPosition, ballRadius, MAROON)
            DrawRectangleLinesEx({0, 0, f32(GetScreenWidth()), f32(GetScreenHeight())}, 4, RAYWHITE)

            DrawCircleV(GetMousePosition(), 10, DARKBLUE)

            DrawFPS(10, 10)

            DrawText(TextFormat("Screen Size: [%i, %i]", GetScreenWidth(), GetScreenHeight()), 10, 40, 10, GREEN)

            DrawText("Following flags can be set after window creation:", 10, 60, 10, GRAY);
            if IsWindowState({.FULLSCREEN_MODE}) {
                DrawText("[F] FLAG_FULLSCREEN_MODE: on", 10, 80, 10, LIME)
            } else {
                DrawText("[F] FLAG_FULLSCREEN_MODE: off", 10, 80, 10, MAROON)
            }
            if IsWindowState({.WINDOW_RESIZABLE}) {
                DrawText("[R] FLAG_WINDOW_RESIZABLE: on", 10, 100, 10, LIME)
            } else {
                DrawText("[R] FLAG_WINDOW_RESIZABLE: off", 10, 100, 10, MAROON)
            }
            if IsWindowState({.WINDOW_UNDECORATED}) {
                DrawText("[D] FLAG_WINDOW_UNDECORATED: on", 10, 120, 10, LIME)
            } else {
                DrawText("[D] FLAG_WINDOW_UNDECORATED: off", 10, 120, 10, MAROON)
            }
            if IsWindowState({.WINDOW_HIDDEN}) {
                DrawText("[H] FLAG_WINDOW_HIDDEN: on", 10, 140, 10, LIME)
            } else {
                DrawText("[H] FLAG_WINDOW_HIDDEN: off", 10, 140, 10, MAROON)
            }
            if IsWindowState({.WINDOW_MINIMIZED}) {
                DrawText("[N] FLAG_WINDOW_MINIMIZED: on", 10, 160, 10, LIME)
            } else {
                DrawText("[N] FLAG_WINDOW_MINIMIZED: off", 10, 160, 10, MAROON)
            }
            if IsWindowState({.WINDOW_MAXIMIZED}) {
                DrawText("[M] FLAG_WINDOW_MAXIMIZED: on", 10, 180, 10, LIME)
            } else {
                DrawText("[M] FLAG_WINDOW_MAXIMIZED: off", 10, 180, 10, MAROON)
            }
            if IsWindowState({.WINDOW_UNFOCUSED}) {
                DrawText("[G] FLAG_WINDOW_UNFOCUSED: on", 10, 200, 10, LIME)
            } else {
                DrawText("[U] FLAG_WINDOW_UNFOCUSED: off", 10, 200, 10, MAROON)
            }
            if IsWindowState({.WINDOW_TOPMOST}) {
                DrawText("[T] FLAG_WINDOW_TOPMOST: on", 10, 220, 10, LIME)
            } else {
                DrawText("[T] FLAG_WINDOW_TOPMOST: off", 10, 220, 10, MAROON)
            }
            if IsWindowState({.WINDOW_ALWAYS_RUN}) {
                DrawText("[A] FLAG_WINDOW_ALWAYS_RUN: on", 10, 240, 10, LIME)
            } else {
                DrawText("[A] FLAG_WINDOW_ALWAYS_RUN: off", 10, 240, 10, MAROON)
            }
            if IsWindowState({.VSYNC_HINT}) {
                DrawText("[V] FLAG_VSYNC_HINT: on", 10, 260, 10, LIME)
            } else {
                DrawText("[V] FLAG_VSYNC_HINT: off", 10, 260, 10, MAROON)
            }
    
            DrawText("Following flags can only be set before window creation:", 10, 300, 10, GRAY)
            if IsWindowState({.WINDOW_HIGHDPI}) {
                DrawText("FLAG_WINDOW_HIGHDPI: on", 10, 320, 10, LIME)
            } else {
                DrawText("FLAG_WINDOW_HIGHDPI: off", 10, 320, 10, MAROON)
            }
            if IsWindowState({.WINDOW_TRANSPARENT}) {
                DrawText("FLAG_WINDOW_TRANSPARENT: on", 10, 340, 10, LIME)
            } else {
                DrawText("FLAG_WINDOW_TRANSPARENT: off", 10, 340, 10, MAROON)
            }
            if IsWindowState({.MSAA_4X_HINT}) {
                DrawText("FLAG_MSAA_4X_HINT: on", 10, 360, 10, LIME)
            } else {
                DrawText("FLAG_MSAA_4X_HINT: off", 10, 360, 10, MAROON)
            }
        }
    }
}