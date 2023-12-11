package text

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [text] example - text writing anim")
    defer CloseWindow()

    message: cstring = "This sample illustrates a text writing\nanimation effect! Check it out! ;)"

    framesCounter: i32 = 0

    SetTargetFPS(60)

    for !WindowShouldClose() {
        if IsKeyDown(.SPACE) {
            framesCounter += 8
        } else {
            framesCounter += 1
        }

        if IsKeyPressed(.ENTER) {
            framesCounter = 0
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)

            DrawText(TextSubtext(message, 0, framesCounter/10), 210, 160, 20, MAROON)

            DrawText("PRESS [ENTER] to RESTART!", 240, 260, 20, LIGHTGRAY)
            DrawText("PRESS [SPACE] to SPEED UP!", 239, 300, 20, LIGHTGRAY)
        }
    }
}