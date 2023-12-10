package core

import "vendor:raylib"

GameScreen :: enum { LOGO, TITLE, GAMEPLAY, ENDING }

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - basic screen manager")
    defer CloseWindow()

    currentScreen: GameScreen = .LOGO

    framesCounter := 0

    SetTargetFPS(60)

    for !WindowShouldClose() {
        switch currentScreen {
        case .LOGO:
            framesCounter += 1
            if framesCounter > 120 {
                currentScreen = .TITLE
            }

        case .TITLE:
            if IsKeyPressed(.ENTER) { // || IsGestureDetected(.TAP)
                currentScreen = .GAMEPLAY
            }

        case .GAMEPLAY:
            if IsKeyPressed(.ENTER) { // || IsGestureDetected(.TAP)
                currentScreen = .ENDING
            }

        case .ENDING:
            if IsKeyPressed(.ENTER) { // || IsGestureDetected(.TAP)
                currentScreen = .TITLE
            }
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)

            switch currentScreen {
            case .LOGO:
                DrawText("LOGO SCREEN", 20, 20, 40, LIGHTGRAY)
                DrawText("WAIT for 2 SECONDS...", 290, 220, 20, GRAY)

            case .TITLE:
                DrawRectangle(0, 0, screenWidth, screenHeight, GREEN)
                DrawText("TITLE SCREEN", 20, 20, 40, DARKGREEN)
                DrawText("PRESS ENTER or TAP to JUMP to GAMEPLAY SCREEN", 120, 220, 20, DARKGREEN)

            case .GAMEPLAY:
                DrawRectangle(0, 0, screenWidth, screenHeight, PURPLE)
                DrawText("GAMEPLAY SCREEN", 20, 20, 40, MAROON)
                DrawText("PRESS ENTER or TAP to JUMP to ENDING SCREEN", 130, 220, 20, MAROON)

            case .ENDING:
                DrawRectangle(0, 0, screenWidth, screenHeight, BLUE);
                DrawText("ENDING SCREEN", 20, 20, 40, DARKBLUE);
                DrawText("PRESS ENTER or TAP to RETURN to TITLE SCREEN", 120, 220, 20, DARKBLUE);
            }
        }
    }
}