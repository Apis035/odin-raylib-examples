package audio

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [audio] example - music playing (streaming)")
    defer CloseWindow()

    InitAudioDevice()
    defer CloseAudioDevice()

    music := LoadMusicStream("resources/country.mp3")
    defer UnloadMusicStream(music)

    PlayMusicStream(music)

    timePlayed: f32 = 0
    pause := false

    SetTargetFPS(30)

    for !WindowShouldClose() {
        UpdateMusicStream(music)

        if IsKeyPressed(.SPACE) {
            StopMusicStream(music)
            PlayMusicStream(music)
        }

        if IsKeyPressed(.P) {
            pause = !pause

            if pause {
                PauseMusicStream(music)
            } else {
                ResumeMusicStream(music)
            }
        }

        timePlayed = GetMusicTimePlayed(music) / GetMusicTimeLength(music)

        if timePlayed > 1 {
            timePlayed = 1
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)

            DrawText("MUSIC SHOULD BE PLAYING!", 255, 150, 20, LIGHTGRAY)

            DrawRectangle(200, 200, 400, 12, LIGHTGRAY)
            DrawRectangle(200, 200, i32(timePlayed*400), 12, MAROON)
            DrawRectangleLines(200, 200, 400, 12, GRAY)

            DrawText("PRESS SPACE TO RESTART MUSIC", 215, 250, 20, LIGHTGRAY)
            DrawText("PRESS P TO PAUSE/RESUME MUSIC", 208, 280, 20, LIGHTGRAY)
        }
    }
}