package textures

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [textures] example - texture loading and drawing")
    defer CloseWindow()

    texture := LoadTexture("resources/raylib_logo.png")
    defer UnloadTexture(texture)

    for !WindowShouldClose() {
        BeginDrawing()
        defer EndDrawing()

        ClearBackground(RAYWHITE)

        DrawTexture(texture, screenWidth/2 - texture.width/2, screenHeight/2 - texture.height/2, WHITE)

        DrawText("this IS a texture!", 360, 370, 10, GRAY)
    }
}