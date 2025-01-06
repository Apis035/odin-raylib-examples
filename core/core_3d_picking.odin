package core

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d picking")
    defer CloseWindow()

    camera: Camera
    camera.position   = {10, 10, 10}
    camera.target     = {0, 0, 0}
    camera.up         = {0, 1, 0}
    camera.fovy       = 45
    camera.projection = .PERSPECTIVE

    cubePosition: Vector3 = {0, 1, 0}
    cubeSize:     Vector3 = {2, 2, 2}

    ray: Ray
    collision: RayCollision

    SetTargetFPS(60)

    for !WindowShouldClose() {
        if IsCursorHidden() {
            UpdateCamera(&camera, .FIRST_PERSON)
        }

        if IsMouseButtonPressed(.RIGHT) {
            if IsCursorHidden() {
                EnableCursor()
            } else {
                DisableCursor()
            }
        }

        if IsMouseButtonPressed(.LEFT) {
            if !collision.hit {
                ray = GetScreenToWorldRay(GetMousePosition(), camera)

                collision = GetRayCollisionBox(ray, {
                    {cubePosition.x - cubeSize.x/2, cubePosition.y - cubeSize.y/2, cubePosition.z - cubeSize.z/2},
                    {cubePosition.x + cubeSize.x/2, cubePosition.y + cubeSize.y/2, cubePosition.z + cubeSize.z/2},
                })
            } else {
                collision.hit = false
            }
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)

            {
                BeginMode3D(camera)
                defer EndMode3D()

                if collision.hit {
                    DrawCube(cubePosition, cubeSize.x, cubeSize.y, cubeSize.z, RED)
                    DrawCubeWires(cubePosition, cubeSize.x, cubeSize.y, cubeSize.z, MAROON)
                    DrawCubeWires(cubePosition, cubeSize.x + 0.2, cubeSize.y + 0.2, cubeSize.z + 0.2, GREEN)
                } else {
                    DrawCube(cubePosition, cubeSize.x, cubeSize.y, cubeSize.z, GRAY)
                    DrawCubeWires(cubePosition, cubeSize.x, cubeSize.y, cubeSize.z, DARKGRAY)
                }

                DrawRay(ray, MAROON)
                DrawGrid(10, 1)
            }

            DrawText("Try clicking on the box with your mouse!", 240, 10, 20, DARKGRAY)

            if collision.hit {
                DrawText("BOX SELECTED", (screenWidth - MeasureText("BOX SELECTED", 30)) / 2, i32(screenHeight * 0.1), 30, GREEN)
            }

            DrawText("Right click mouse to toggle camera controls", 10, 430, 10, GRAY)

            DrawFPS(10, 10)
        }
    }
}