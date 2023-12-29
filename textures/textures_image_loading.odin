package textures

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [textures] example - image loading")
    defer CloseWindow()

    image := LoadImage("resources/raylib_logo.png")
    texture := LoadTextureFromImage(image)
    defer UnloadTexture(texture)
    UnloadImage(image)

    SetTargetFPS(60)

    for !WindowShouldClose() {
        BeginDrawing()
        defer EndDrawing()

        ClearBackground(RAYWHITE)

        DrawTexture(texture, screenWidth/2 - texture.width/2, screenHeight/2 - texture.height/2, WHITE)

        DrawText("this IS a texture loaded from an image!", 300, 370, 10, GRAY)
    }
}