package core

import "vendor:raylib"

main :: proc() {
    using raylib
    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - scissor test")
    defer CloseWindow()

    scissorArea: Rectangle = {0, 0, 300, 300}
    scissorMode := true

    SetTargetFPS(60)

    for !WindowShouldClose() {
        if IsKeyPressed(.S) do scissorMode = !scissorMode

        scissorArea.x = f32(GetMouseX()) - scissorArea.width/2
        scissorArea.y = f32(GetMouseY()) - scissorArea.height/2

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)

            if scissorMode {
                BeginScissorMode(i32(scissorArea.x), i32(scissorArea.y), i32(scissorArea.width), i32(scissorArea.height))
            }

            DrawRectangle(0, 0, GetScreenWidth(), GetScreenHeight(), RED)
            DrawText("Move the mouse around to reveal this text!", 190, 200, 20, BLACK)

            if scissorMode do EndScissorMode()

            DrawRectangleLinesEx(scissorArea, 1, BLACK)
            DrawText("Press S to toggle scissor text", 10, 10, 20, BLACK)
        }
    }
}