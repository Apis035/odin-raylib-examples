package core

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - core world screen")
    defer CloseWindow()

    camera: Camera
    camera.position   = {10, 10, 10}
    camera.target     = {0, 0, 0}
    camera.up         = {0, 1, 0}
    camera.fovy       = 45
    camera.projection = .PERSPECTIVE

    cubePosition:       Vector3 = {0, 0, 0}
    cubeScreenPosition: Vector2 = {0, 0}

    DisableCursor()

    SetTargetFPS(60)

    for !WindowShouldClose() {
        UpdateCamera(&camera, .THIRD_PERSON)

        cubeScreenPosition = GetWorldToScreen({cubePosition.x, cubePosition.y + 2.5, cubePosition.z}, camera)

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

            text: cstring = "Enemy: 100 / 100"
            DrawText(text, i32(cubeScreenPosition.x) - MeasureText(text, 20)/2, i32(cubeScreenPosition.y), 20, BLACK)

            DrawText(TextFormat("Cube position in screen space coordinates: [%i, %i]", i32(cubeScreenPosition.x), i32(cubeScreenPosition.y)), 10, 10, 20, LIME)
            DrawText("Text 2d should be always on top of the cube", 10, 40, 20, GRAY)
        }
    }
}