package textures

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [texture] example - image text drawing")
    defer CloseWindow()

    parrots := LoadImage("resources/parrots.png")

    font := LoadFontEx("resources/KAISG.ttf", 64, nil, 0)
    defer UnloadFont(font)

    ImageDrawTextEx(&parrots, font, "[Parrots font drawing]", {20, 20}, f32(font.baseSize), 0, RED)

    texture := LoadTextureFromImage(parrots)
    defer UnloadTexture(texture)
    UnloadImage(parrots)

    position: Vector2 = {f32(screenWidth/2 - texture.width/2), f32(screenHeight/2 - texture.height/2 - 20)}

    showFont := false

    SetTargetFPS(60)

    for !WindowShouldClose() {
        if IsKeyDown(.SPACE) {
            showFont = true
        } else {
            showFont = false
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)

            if !showFont {
                DrawTextureV(texture, position, WHITE)
                DrawTextEx(font, "[Parrots font drawing]", {position.x + 20, position.y + 20 + 280}, f32(font.baseSize), 0, WHITE)
            } else {
                DrawTexture(font.texture, screenWidth/2 - font.texture.width/2, 50, BLACK)
            }

            DrawText("PRESS SPACE to SHOW FONT ATLAS USED", 290, 420, 10, DARKGRAY)
        }
    }
}