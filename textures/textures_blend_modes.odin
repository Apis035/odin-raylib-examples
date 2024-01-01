package textures

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [textures] example - blend modes")
    defer CloseWindow()

    bgImage := LoadImage("resources/cyberpunk_street_background.png")
    bgTexture := LoadTextureFromImage(bgImage)
    defer UnloadTexture(bgTexture)
    UnloadImage(bgImage)

    fgImage := LoadImage("resources/cyberpunk_street_foreground.png")
    fgTexture := LoadTextureFromImage(fgImage)
    defer UnloadTexture(fgTexture)
    UnloadImage(fgImage)

    blendCountMax :: 4
    blendMode: BlendMode

    for !WindowShouldClose() {
        if IsKeyPressed(.SPACE) {
            if int(blendMode) >= blendCountMax - 1 {
                blendMode = BlendMode(0)
            } else {
                blendMode += BlendMode(1)
            }
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)

            DrawTexture(bgTexture, screenWidth/2 - bgTexture.width/2, screenHeight/2 - bgTexture.height/2, WHITE)

            BeginBlendMode(blendMode)
            DrawTexture(fgTexture, screenWidth/2 - fgTexture.width/2, screenHeight/2 - fgTexture.height/2, WHITE)
            EndBlendMode()

            DrawText("Press SPACE to change blend modes.", 310, 350, 10, GRAY)

            #partial switch blendMode {
            case .ALPHA:      DrawText("Current: BLEND_ALPHA", (screenWidth/2) - 60, 370, 10, GRAY)
            case .ADDITIVE:   DrawText("Current: BLEND_ADDITIVE", (screenWidth/2) - 60, 370, 10, GRAY)
            case .MULTIPLIED: DrawText("Current: BLEND_MULTIPLIED", (screenWidth/2) - 60, 370, 10, GRAY)
            case .ADD_COLORS: DrawText("Current: BLEND_ADD_COLORS", (screenWidth/2) - 60, 370, 10, GRAY)
            }

            DrawText("(c) Cyberpunk Street Environment by Luis Zuno (@ansimuz)", screenWidth - 330, screenHeight - 20, 10, GRAY)
        }
    }
}