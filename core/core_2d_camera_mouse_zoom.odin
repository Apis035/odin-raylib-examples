package core

import "vendor:raylib"
import "vendor:raylib/rlgl"
import "core:math/linalg"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera mouse zoom")
    defer CloseWindow()

    camera: Camera2D
    camera.zoom = 1

    SetTargetFPS(60)

    for !WindowShouldClose() {
        if IsMouseButtonDown(.RIGHT) {
            delta := GetMouseDelta()
            delta *= -1 / camera.zoom

            camera.target += delta
        }

        wheel := GetMouseWheelMove()
        if wheel != 0 {
            mouseWorldPos := GetScreenToWorld2D(GetMousePosition(), camera)

            camera.offset = GetMousePosition()
            camera.target = mouseWorldPos

            zoomIncrement: f32 = 0.125

            camera.zoom += wheel * zoomIncrement
            camera.zoom = clamp(camera.zoom, zoomIncrement, 32)
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(BLACK)

            {
                BeginMode2D(camera)
                defer EndMode2D()

                rlgl.PushMatrix()
                    rlgl.Translatef(0, 25*50, 0)
                    rlgl.Rotatef(90, 1, 0, 0)
                    DrawGrid(100, 50)
                rlgl.PopMatrix()

                DrawCircle(100, 100, 50, YELLOW)
            }

            DrawText("Mouse right button drag to move, mouse wheel to zoom", 10, 10, 20, WHITE)
        }
    }
}