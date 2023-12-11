package core

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera free")
    defer CloseWindow()

    camera: Camera3D
    camera.position   = {10, 10, 10}
    camera.target     = {0, 0, 0}
    camera.up         = {0, 1, 0}
    camera.fovy       = 45
    camera.projection = .PERSPECTIVE

    cubePosition: Vector3 = {0, 0, 0}

    DisableCursor()

    SetTargetFPS(60)

    for !WindowShouldClose() {
        UpdateCamera(&camera, .FREE) // FIXME: weird camera behaviour

        if IsKeyPressed(.Z) {
            camera.target = {0, 0, 0}
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)

            {
                BeginMode3D(camera)
                defer EndMode3D()

                DrawCube(cubePosition, 2, 2, 2, RED)
                DrawCubeWires(cubePosition, 2, 2, 2, MAROON)

                DrawGrid(10, 1)
            }

            DrawRectangle(10, 10, 320, 93, Fade(SKYBLUE, 0.5))
            DrawRectangleLines(10, 10, 320, 93, BLUE)

            DrawText("Free camera default controls:", 20, 20, 10, BLACK)
            DrawText("- Mouse Wheel to Zoom in-out", 40, 40, 10, DARKGRAY)
            DrawText("- Mouse Wheel Pressed to Pan", 40, 60, 10, DARKGRAY)
            DrawText("- Z to zoom to (0, 0, 0)", 40, 80, 10, DARKGRAY)
        }
    }
}