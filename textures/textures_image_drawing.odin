package textures

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [textures] example - image drawing")
    defer CloseWindow()

    cat := LoadImage("resources/cat.png")
    ImageCrop(&cat, {100, 10, 280, 380})
    ImageFlipHorizontal(&cat)
    ImageResize(&cat, 150, 200)

    parrots := LoadImage("resources/parrots.png")
    ImageDraw(&parrots, cat, {0, 0, f32(cat.width), f32(cat.height)}, {30, 40, f32(cat.width)*1.5, f32(cat.height)*1.5}, WHITE)
    ImageCrop(&parrots, {0, 50, f32(parrots.width), f32(parrots.height) - 100})

    ImageDrawPixel(&parrots, 10, 10, RAYWHITE)
    ImageDrawCircleLines(&parrots, 10, 10, 5, RAYWHITE)
    ImageDrawRectangle(&parrots, 5, 20, 10, 10, RAYWHITE)

    UnloadImage(cat)

    font := LoadFont("resources/custom_jupiter_crash.png")

    ImageDrawTextEx(&parrots, font, "PARROTS & CAT", {300, 230}, f32(font.baseSize), -2, WHITE)

    UnloadFont(font)

    texture := LoadTextureFromImage(parrots)
    defer UnloadTexture(texture)
    UnloadImage(parrots)

    SetTargetFPS(60)

    for !WindowShouldClose() {
        BeginDrawing()
        defer EndDrawing()

        ClearBackground(RAYWHITE)

        DrawTexture(texture, screenWidth/2 - texture.width/2, screenHeight/2 - texture.height/2 - 40, WHITE)
        DrawRectangleLines(screenWidth/2 - texture.width/2, screenHeight/2 - texture.height/2 - 40, texture.width, texture.height, DARKGRAY)

        DrawText("We are drawing only one texture from various images composed!", 240, 350, 10, DARKGRAY)
        DrawText("Source images have been cropped, scaled, flipped and copied one over the other.", 190, 370, 10, DARKGRAY)
    }
}