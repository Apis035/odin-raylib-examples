package core

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera mode")
    defer CloseWindow()

    camera: Camera
    camera.position   = {0, 10, 10}
    camera.target     = {0, 0, 0}
    camera.up         = {0, 1, 0}
    camera.fovy       = 45
    camera.projection = .PERSPECTIVE

    cubePosition: Vector3 = {0, 0, 0}

    SetTargetFPS(60)

    for !WindowShouldClose() {
        BeginDrawing()
        defer EndDrawing()

        ClearBackground(RAYWHITE)

        BeginMode3D(camera)
        DrawCube(cubePosition, 2, 2, 2, RED)
        DrawCubeWires(cubePosition, 2, 2, 2, MAROON)
        DrawGrid(10, 1)
        EndMode3D()

        DrawText("Welcome to the third dimension!", 10, 40, 20, DARKGRAY)

        DrawFPS(10, 10)
    }
}