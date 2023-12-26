package audio

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [audio] example - sound loading and playing")
    defer CloseWindow()

    InitAudioDevice()
    defer CloseAudioDevice()

    fxWav := LoadSound("resources/sound.wav")
    defer UnloadSound(fxWav)
    fxOgg := LoadSound("resources/target.ogg")
    defer UnloadSound(fxOgg)

    SetTargetFPS(60)

    for !WindowShouldClose() {
        if IsKeyPressed(.SPACE) do PlaySound(fxWav)
        if IsKeyPressed(.ENTER) do PlaySound(fxOgg)

        BeginDrawing()
        defer EndDrawing()

        ClearBackground(RAYWHITE)

        DrawText("Press SPACE to PLAY the WAV sound!", 200, 180, 20, LIGHTGRAY)
        DrawText("Press ENTER to PLAY the OGG sound!", 200, 220, 20, LIGHTGRAY)
    }
}