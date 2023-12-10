package core

import "vendor:raylib"
import "core:math/linalg"

main :: proc() {
    using raylib

    windowWidth  :: 800
    windowHeight :: 450

    SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
    InitWindow(windowWidth, windowHeight, "raylib [core] example - window scale letterbox")
    defer CloseWindow()
    SetWindowMinSize(320, 240)

    gameScreenWidth:  i32 = 640
    gameScreenHeight: i32 = 480

    target := LoadRenderTexture(gameScreenWidth, gameScreenHeight)
    defer UnloadRenderTexture(target)
    SetTextureFilter(target.texture, .BILINEAR)

    colors: [10]Color
    for i := 0; i < 10; i += 1 {
        colors[i] = {u8(GetRandomValue(100, 250)), u8(GetRandomValue(50, 150)), u8(GetRandomValue(10, 100)), 255}
    }

    SetTargetFPS(60)

    for !WindowShouldClose() {
        scale: f32 = min(f32(GetScreenWidth())/f32(gameScreenWidth), f32(GetScreenHeight())/f32(gameScreenHeight))

        if IsKeyPressed(.SPACE) {
            for i := 0; i < 10; i += 1 {
                colors[i] = {u8(GetRandomValue(100, 250)), u8(GetRandomValue(50, 150)), u8(GetRandomValue(10, 100)), 255}
            }
        }

        mouse := GetMousePosition()
        virtualMouse: Vector2
        virtualMouse.x = (mouse.x - (f32(GetScreenWidth())  - (f32(gameScreenWidth)  * scale)) * 0.5) / scale
        virtualMouse.y = (mouse.y - (f32(GetScreenHeight()) - (f32(gameScreenHeight) * scale)) * 0.5) / scale
        virtualMouse = linalg.clamp(virtualMouse, Vector2{0, 0}, Vector2{f32(gameScreenWidth), f32(gameScreenHeight)})

        {
            BeginTextureMode(target)
            defer EndTextureMode()

            ClearBackground(RAYWHITE)

            for i := 0; i < 10; i += 1 {
                DrawRectangle(0, (gameScreenHeight/10) * i32(i), gameScreenWidth, gameScreenHeight/10, colors[i])
            }

            DrawText("If executed inside a window,\nyou can resize the window,\nand see the screen scaling!", 10, 25, 20, WHITE)
            DrawText(TextFormat("Default Mouse: [%i, %i]", i32(mouse.x), i32(mouse.y)), 350, 25, 20, GREEN)
            DrawText(TextFormat("Virtual Mouse: [%i, %i]", i32(virtualMouse.x), i32(virtualMouse.y)), 350, 55, 20, YELLOW)
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(BLACK)
            DrawTexturePro(
                target.texture,
                {0, 0, f32(target.texture.width), -f32(target.texture.height)},
                {
                    (f32(GetScreenWidth())  - f32(gameScreenWidth)  * scale) * 0.5,
                    (f32(GetScreenHeight()) - f32(gameScreenHeight) * scale) * 0.5,
                    f32(gameScreenWidth)  * scale,
                    f32(gameScreenHeight) * scale,
                },
                {0, 0}, 0, WHITE,
            )
        }
    }
}