package textures

import "vendor:raylib"

NUM_PROCESSES :: 9

ImageProcess :: enum {
    NONE,
    GRAYSCALE,
    TINT,
    INVERT,
    CONTRAST,
    BRIGHTNESS,
    GAUSSIAN_BLUR,
    FLIP_VERTICAL,
    FLIP_HORIZONTAL,
}

processText: []cstring = {
    "NO PROCESSING",
    "COLOR GRAYSCALE",
    "COLOR TINT",
    "COLOR INVERT",
    "COLOR CONTRAST",
    "COLOR BRIGHTNESS",
    "GAUSSIAN BLUR",
    "FLIP VERTICAL",
    "FLIP HORIZONTAL",
}

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [textures] example - image processing")
    defer CloseWindow()

    imOrigin := LoadImage("resources/parrots.png")
    defer UnloadImage(imOrigin)
    ImageFormat(&imOrigin, .UNCOMPRESSED_R8G8B8A8)
    texture := LoadTextureFromImage(imOrigin)
    defer UnloadTexture(texture)

    imCopy := ImageCopy(imOrigin)
    defer UnloadImage(imCopy)

    currentProcess: ImageProcess = .NONE
    textureReload := false

    toggleRecs: [NUM_PROCESSES]Rectangle
    mouseHoverRec := -1

    for i in 0..<NUM_PROCESSES {
        toggleRecs[i] = {40, 50 + 32*f32(i), 150, 30}
    }

    SetTargetFPS(60)

    for !WindowShouldClose() {
        for i in 0..<NUM_PROCESSES {
            if CheckCollisionPointRec(GetMousePosition(), toggleRecs[i]) {
                mouseHoverRec = i

                if IsMouseButtonReleased(.LEFT) {
                    currentProcess = ImageProcess(i)
                    textureReload = true
                }
                break
            } else {
                mouseHoverRec = -1
            }
        }

        if IsKeyPressed(.DOWN) {
            currentProcess += ImageProcess(1)
            if int(currentProcess) > NUM_PROCESSES - 1 {
                currentProcess = ImageProcess(0)
            }
            textureReload = true
        }
        if IsKeyPressed(.UP) {
            currentProcess -= ImageProcess(1)
            if int(currentProcess) < 0 {
                currentProcess = ImageProcess(NUM_PROCESSES - 1)
            }
            textureReload = true
        }

        if textureReload {
            UnloadImage(imCopy)
            imCopy = ImageCopy(imOrigin)

            switch currentProcess {
            case .NONE:            break
            case .GRAYSCALE:       ImageColorGrayscale(&imCopy)
            case .TINT:            ImageColorTint(&imCopy, GREEN)
            case .INVERT:          ImageColorInvert(&imCopy)
            case .CONTRAST:        ImageColorContrast(&imCopy, -40)
            case .BRIGHTNESS:      ImageColorBrightness(&imCopy, -80)
            case .GAUSSIAN_BLUR:   ImageBlurGaussian(&imCopy, 10)
            case .FLIP_VERTICAL:   ImageFlipVertical(&imCopy)
            case .FLIP_HORIZONTAL: ImageFlipHorizontal(&imCopy)
            }

            pixels := LoadImageColors(imCopy)
            UpdateTexture(texture, pixels)
            UnloadImageColors(pixels)

            textureReload = false
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)

            DrawText("IMAGE PROCESSING:", 40, 30, 10, DARKGRAY)

            for i in 0..<NUM_PROCESSES {
                DrawRectangleRec(toggleRecs[i], (ImageProcess(i) == currentProcess || i == mouseHoverRec) ? SKYBLUE : LIGHTGRAY)
                DrawRectangleLines(i32(toggleRecs[i].x), i32(toggleRecs[i].y), i32(toggleRecs[i].width), i32(toggleRecs[i].height), (ImageProcess(i) == currentProcess || i == mouseHoverRec) ? BLUE : GRAY)
                DrawText(processText[i], i32(toggleRecs[i].x) + i32(toggleRecs[i].width/2) - MeasureText(processText[i], 10)/2, i32(toggleRecs[i].y) + 11, 10, (ImageProcess(i) == currentProcess || i == mouseHoverRec) ? DARKBLUE : DARKGRAY)
            }

            DrawTexture(texture, screenWidth - texture.width - 60, screenHeight/2 - texture.height/2, WHITE)
            DrawRectangleLines(screenWidth - texture.width - 60, screenHeight/2 - texture.height/2, texture.width, texture.height, BLACK)
        }
    }
}