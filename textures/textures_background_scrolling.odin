package textures

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [textures] example -background scrolling")
    defer CloseWindow()

    background := LoadTexture("resources/cyberpunk_street_background.png")
    midground  := LoadTexture("resources/cyberpunk_street_midground.png")
    foreground := LoadTexture("resources/cyberpunk_street_foreground.png")
    defer {
        UnloadTexture(background)
        UnloadTexture(midground)
        UnloadTexture(foreground)
    }

    scrollingBack: f32
    scrollingMid:  f32
    scrollingFore: f32

    SetTargetFPS(60)

    for !WindowShouldClose() {
        scrollingBack -= 0.1
        scrollingMid  -= 0.5
        scrollingFore -= 1.0

        if i32(scrollingBack) <= -background.width*2 { scrollingBack = 0 }
        if i32(scrollingMid)  <= - midground.width*2 { scrollingMid  = 0 }
        if i32(scrollingFore) <= -foreground.width*2 { scrollingFore = 0 }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(GetColor(0x052c46ff))

            DrawTextureEx(background, {scrollingBack, 20}, 0, 2, WHITE)
            DrawTextureEx(background, {f32(background.width)*2 + scrollingBack, 20}, 0, 2, WHITE)

            DrawTextureEx(midground, {scrollingMid, 20}, 0, 2, WHITE)
            DrawTextureEx(midground, {f32(midground.width)*2 + scrollingMid, 20}, 0, 2, WHITE)

            // Draw foreground image twice
            DrawTextureEx(foreground, {scrollingFore, 70}, 0, 2, WHITE)
            DrawTextureEx(foreground, {f32(foreground.width)*2 + scrollingFore, 70}, 0, 2, WHITE)

            DrawText("BACKGROUND SCROLLING & PARALLAX", 10, 10, 20, RED)
            DrawText("(c) Cyberpunk Street Environment by Luis Zuno (@ansimuz)", screenWidth - 330, screenHeight - 20, 10, RAYWHITE)

        }
    }
}