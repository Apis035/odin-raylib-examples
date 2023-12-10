package core

import "vendor:raylib"
import "core:math"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    virtualScreenWidth  :: 160
    virtualScreenHeight :: 90

    virtualRatio :: f32(screenWidth) / f32(virtualScreenWidth)

    InitWindow(screenWidth, screenHeight, "raylib [core] example - smooth pixel-perfect camera")
    defer CloseWindow()

    worldSpaceCamera: Camera2D
    worldSpaceCamera.zoom = 1

    screenSpaceCamera: Camera2D
    screenSpaceCamera.zoom = 1

    target := LoadRenderTexture(virtualScreenWidth, virtualScreenHeight)
    defer UnloadRenderTexture(target)

    rec01: Rectangle = {70, 35, 20, 20}
    rec02: Rectangle = {90, 55, 30, 10}
    rec03: Rectangle = {80, 65, 15, 25}

    sourceRec: Rectangle = {0, 0, f32(target.texture.width), -f32(target.texture.height)}
    destRec:   Rectangle = {-virtualRatio, -virtualRatio, screenWidth + (virtualRatio*2), screenHeight + (virtualRatio*2)}

    origin: Vector2 = {0, 0}

    rotation: f32 = 0

    cameraX: f32 = 0
    cameraY: f32 = 0

    SetTargetFPS(60)

    for !WindowShouldClose() {
        rotation += 60 * GetFrameTime()

        cameraX = (f32(math.sin(GetTime())) * 50) - 10
        cameraY = (f32(math.cos(GetTime())) * 30)

        screenSpaceCamera.target = {cameraX, cameraY}

        worldSpaceCamera.target.x   = cast(f32)i32(screenSpaceCamera.target.x)
        screenSpaceCamera.target.x -= worldSpaceCamera.target.x
        screenSpaceCamera.target.x *= virtualRatio

        worldSpaceCamera.target.y   = cast(f32)i32(screenSpaceCamera.target.y)
        screenSpaceCamera.target.y -= worldSpaceCamera.target.y
        screenSpaceCamera.target.y *= virtualRatio

        {
            BeginTextureMode(target)
            defer EndTextureMode()

            ClearBackground(RAYWHITE)

            {
                BeginMode2D(worldSpaceCamera)
                defer EndMode2D()

                DrawRectanglePro(rec01, origin, rotation, BLACK)
                DrawRectanglePro(rec02, origin, -rotation, RED)
                DrawRectanglePro(rec03, origin, rotation + 45, BLUE)
            }
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RED)

            BeginMode2D(screenSpaceCamera)
            DrawTexturePro(target.texture, sourceRec, destRec, origin, 0, WHITE)
            EndMode2D()

            DrawText(TextFormat("Screen resolution: %ix%i", screenWidth, screenHeight), 10, 10, 20, DARKBLUE)
            DrawText(TextFormat("World resolution: %ix%i", virtualScreenWidth, virtualScreenHeight), 10, 40, 20, DARKGREEN)
            DrawFPS(GetScreenWidth() - 95, 10)
        }
    }
}