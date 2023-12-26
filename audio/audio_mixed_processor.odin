package audio

import "vendor:raylib"
import "core:math"
import c "core:c/libc"

exponent: f32 = 1
averageVolume: [400]f32

ProcessAudio :: proc "c" (buffer: rawptr, frames: c.uint) {
    samples := cast([^]f32)buffer
    average: f32

    for frame in 0..<frames {
        left  := &samples[frame * 2 + 0]
        right := &samples[frame * 2 + 1]

        left^  = math.pow(math.abs(left^),  exponent) * (left^  < 0 ? -1 : 1)
        right^ = math.pow(math.abs(right^), exponent) * (right^ < 0 ? -1 : 1)

        average += math.abs(left^)  / f32(frames)
        average += math.abs(right^) / f32(frames)
    }

    for i in 0..<399 {
        averageVolume[i] = averageVolume[i + 1]
    }

    averageVolume[399] = average
}

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [audio] example - processing mixed output")
    defer CloseWindow()

    InitAudioDevice()
    defer CloseAudioDevice()

    AttachAudioMixedProcessor(ProcessAudio)
    defer DetachAudioMixedProcessor(ProcessAudio)

    music := LoadMusicStream("resources/country.mp3")
    defer UnloadMusicStream(music)
    sound := LoadSound("resources/coin.wav")
    defer UnloadSound(sound)

    PlayMusicStream(music)

    SetTargetFPS(60)

    for !WindowShouldClose() {
        UpdateMusicStream(music)

        if IsKeyPressed(.LEFT)  do exponent -= 0.05
        if IsKeyPressed(.RIGHT) do exponent += 0.05

        exponent = clamp(exponent, 0.5, 3)

        if IsKeyPressed(.SPACE) do PlaySound(sound)

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)

            DrawText("MUSIC SHOULD BE PLAYING!", 255, 150, 20, LIGHTGRAY)

            DrawText(TextFormat("EXPONENT = %.2f", exponent), 215, 180, 20, LIGHTGRAY)

            DrawRectangle(199, 199, 402, 34, LIGHTGRAY)
            for i in i32(0)..<400 {
                DrawLine(201 + i, 232 - i32(averageVolume[i] * 32), 201 + i, 232, MAROON)
            }

            DrawRectangleLines(199, 199, 402, 34, GRAY)

            DrawText("PRESS SPACE TO PLAY OTHER SOUND", 200, 250, 20, LIGHTGRAY)
            DrawText("USE LEFT AND RIGHT ARROWS TO ALTER DISTORTION", 140, 280, 20, LIGHTGRAY)
        }
    }
}