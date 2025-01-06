package core

import "vendor:raylib"

MAX_COLUMNS :: 20

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera first person")
    defer CloseWindow()

    camera: Camera
    camera.position   = {0, 2, 4}
    camera.target     = {0, 2, 0}
    camera.up         = {0, 1, 0}
    camera.fovy       = 60
    camera.projection = .PERSPECTIVE

    cameraMode: CameraMode = .FIRST_PERSON

    heights:   [MAX_COLUMNS]f32
    positions: [MAX_COLUMNS]Vector3
    colors:    [MAX_COLUMNS]Color

    for i in 0..<MAX_COLUMNS {
        heights[i]   = f32(GetRandomValue(1, 12))
        positions[i] = {f32(GetRandomValue(-15, 15)), heights[i]/2, f32(GetRandomValue(-15, 15))}
        colors[i]    = {u8(GetRandomValue(20, 255)), u8(GetRandomValue(10, 55)), 30, 255}
    }

    DisableCursor()

    SetTargetFPS(60)

    for !WindowShouldClose() {
        if IsKeyPressed(.ONE) {
            cameraMode = .FREE
            camera.up  = {0, 1, 0}
        }
        if IsKeyPressed(.TWO) {
            cameraMode = .FIRST_PERSON
            camera.up  = {0, 1, 0}
        }
        if IsKeyPressed(.THREE) {
            cameraMode = .THIRD_PERSON
            camera.up  = {0, 1, 0}
        }
        if IsKeyPressed(.FOUR) {
            cameraMode = .ORBITAL
            camera.up  = {0, 1, 0}
        }

        if IsKeyPressed(.P) {
            if camera.projection == .PERSPECTIVE {
                cameraMode        = .THIRD_PERSON
                camera.position   = {0, 2, -100}
                camera.target     = {0, 2, 0}
                camera.up         = {0, 1, 0}
                camera.projection = .ORTHOGRAPHIC
                camera.fovy       = 20
                // TODO:
                //CameraYaw(&camera, -135 * DEG2RAD, true)
                //CameraPitch(&camera, -45 * DEG2RAD, true, true, false)
            } else if camera.projection == .ORTHOGRAPHIC {
                cameraMode = .THIRD_PERSON
                camera.position     = {0, 2, 10}
                camera.target       = {0, 2, 0}
                camera.up           = {0, 1, 0}
                camera.projection   = .PERSPECTIVE
                camera.fovy         = 60
            }
        }

        UpdateCamera(&camera, cameraMode)

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)

            {
                BeginMode3D(camera)
                defer EndMode3D()

                DrawPlane({0, 0, 0}, {32, 32}, LIGHTGRAY)
                DrawCube({-16, 2.5, 0}, 1, 5, 32, BLUE)
                DrawCube({16, 2.5, 0}, 1, 5, 32, LIME)
                DrawCube({0, 2.5, 16}, 32, 5, 1, GOLD)

                for i in 0..<MAX_COLUMNS {
                    DrawCube(positions[i], 2, heights[i], 2, colors[i])
                    DrawCubeWires(positions[i], 2, heights[i], 2, MAROON)
                }

                if cameraMode == .THIRD_PERSON {
                    DrawCube(camera.target, 0.5, 0.5, 0.5, PURPLE)
                    DrawCubeWires(camera.target, 0.5, 0.5, 0.5, DARKPURPLE)
                }
            }

            DrawRectangle(5, 5, 330, 100, Fade(SKYBLUE, 0.5))
            DrawRectangleLines(5, 5, 330, 100, BLUE)

            DrawText("Camera controls:", 15, 15, 10, BLACK)
            DrawText("- Move keys: W, A, S, D, Space, Left-Ctrl", 15, 30, 10, BLACK)
            DrawText("- Look around: arrow keys or mouse", 15, 45, 10, BLACK)
            DrawText("- Camera mode keys: 1, 2, 3, 4", 15, 60, 10, BLACK)
            DrawText("- Zoom keys: num-plus, num-minus or mouse scroll", 15, 75, 10, BLACK)
            DrawText("- Camera projection key: P", 15, 90, 10, BLACK)

            DrawRectangle(600, 5, 195, 100, Fade(SKYBLUE, 0.5))
            DrawRectangleLines(600, 5, 195, 100, BLUE)

            DrawText("Camera status:", 610, 15, 10, BLACK)
            DrawText(TextFormat("- Mode: %s", (cameraMode == .FREE)         ? "FREE" :
                                              (cameraMode == .FIRST_PERSON) ? "FIRST_PERSON" :
                                              (cameraMode == .THIRD_PERSON) ? "THIRD_PERSON" :
                                              (cameraMode == .ORBITAL)      ? "ORBITAL" : "CUSTOM"), 610, 30, 10, BLACK)
            DrawText(TextFormat("- Projection: %s", (camera.projection == .PERSPECTIVE) ? "PERSPECTIVE" :
                                                    (camera.projection == .ORTHOGRAPHIC) ? "ORTHOGRAPHIC" : "CUSTOM"), 610, 45, 10, BLACK)
            DrawText(TextFormat("- Position: (%06.3f, %06.3f, %06.3f)", camera.position.x, camera.position.y, camera.position.z), 610, 60, 10, BLACK)
            DrawText(TextFormat("- Target: (%06.3f, %06.3f, %06.3f)", camera.target.x, camera.target.y, camera.target.z), 610, 75, 10, BLACK)
            DrawText(TextFormat("- Up: (%06.3f, %06.3f, %06.3f)", camera.up.x, camera.up.y, camera.up.z), 610, 90, 10, BLACK)
        }
    }
}