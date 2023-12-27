package audio

import "vendor:raylib"
import c "core:c/libc"

delayBuffer: [^]f32 = nil
delayBufferSize: u32 = 0
delayReadIndex: u32 = 2
delayWriteIndex: u32 = 0

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [audio] example - stream effects")
    defer CloseWindow()

    InitAudioDevice()
    defer CloseAudioDevice()

    music := LoadMusicStream("resources/country.mp3")
    defer UnloadMusicStream(music)

    // TODO: This might be the incorrect way to do malloc/free
    delayBufferSize = 48000*2
    delayBuffer = make([^]f32, delayBufferSize)
    defer free(delayBuffer)

    PlayMusicStream(music)

    timePlayed: f32
    pause: bool

    enableEffectLPF: bool
    enableEffectDelay: bool

    SetTargetFPS(60)

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

        if IsKeyPressed(.F) {
            enableEffectLPF = !enableEffectLPF

            if enableEffectLPF {
                AttachAudioStreamProcessor(music.stream, AudioProcessEffectLPF)
            } else {
                DetachAudioStreamProcessor(music.stream, AudioProcessEffectLPF)
            }
        }

        if IsKeyPressed(.D) {
            enableEffectDelay = !enableEffectDelay

            if enableEffectDelay {
                AttachAudioStreamProcessor(music.stream, AudioProcessEffectDelay)
            } else {
                DetachAudioStreamProcessor(music.stream, AudioProcessEffectDelay)
            }
        }

        timePlayed = GetMusicTimePlayed(music)/GetMusicTimeLength(music)

        if timePlayed > 1 {
            timePlayed = 1
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)

            DrawText("MUSIC SHOULD BE PLAYING!", 245, 150, 20, LIGHTGRAY)

            DrawRectangle(200, 180, 400, 12, LIGHTGRAY)
            DrawRectangle(200, 180, i32(timePlayed*400), 12, MAROON)
            DrawRectangleLines(200, 180, 400, 12, GRAY)

            DrawText("PRESS SPACE TO RESTART MUSIC", 215, 230, 20, LIGHTGRAY)
            DrawText("PRESS P TO PAUSE/RESUME MUSIC", 208, 260, 20, LIGHTGRAY)

            DrawText(TextFormat("PRESS F TO TOGGLE LPF EFFECT: %s", enableEffectLPF? "ON" : "OFF"), 200, 320, 20, GRAY)
            DrawText(TextFormat("PRESS D TO TOGGLE DELAY EFFECT: %s", enableEffectDelay? "ON" : "OFF"), 180, 350, 20, GRAY)
        }
    }
}

// FIXME: both effect are not working, idk how to translate the c code that
//        casts the pointer to float

AudioProcessEffectLPF :: proc "c" (buffer: rawptr, frames: c.uint) {
    low: [2]f32
    cutoff: f32 : 70/44100
    k:      f32 : cutoff / (cutoff + 0.1591549431)

    for i := 0; i < int(frames)*2; i += 2 {
        bufptr := cast([^]f32)buffer

        l := bufptr[i + 0]
        r := bufptr[i + 1]

        low[0] += k * (l - low[0])
        low[1] += k * (r - low[1])

        bufptr[i + 0] = low[0]
        bufptr[i + 1] = low[1]
    }
}

AudioProcessEffectDelay :: proc "c" (buffer: rawptr, frames: c.uint) {
    for i := 0; i < int(frames)*2; i += 2 {
        bufptr := cast([^]f32)buffer

        leftDelay  := delayBuffer[delayReadIndex]; delayReadIndex += 1
        rightDelay := delayBuffer[delayReadIndex]; delayReadIndex += 1

        if delayReadIndex == delayBufferSize {
            delayReadIndex = 0
        }

        bufptr[i + 0] = 0.5 * bufptr[i + 0] + 0.5 * leftDelay
        bufptr[i + 1] = 0.5 * bufptr[i + 1] + 0.5 * rightDelay

        delayBuffer[delayWriteIndex] = bufptr[i + 0]; delayReadIndex += 1
        delayBuffer[delayWriteIndex] = bufptr[i + 1]; delayReadIndex += 1

        if delayWriteIndex == delayBufferSize {
            delayWriteIndex = 0
        }
    }
}