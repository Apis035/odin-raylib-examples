package textures

import "vendor:raylib"

NUM_TEXTURES :: 9

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [textures] example - procedural images generation")
    defer CloseWindow()

    verticalGradient    := GenImageGradientLinear(screenWidth, screenHeight, 0, RED, BLUE)
    horizontalGradient  := GenImageGradientLinear(screenWidth, screenHeight, 90, RED, BLUE)
    diagonalGradient    := GenImageGradientLinear(screenWidth, screenHeight, 45, RED, BLUE)
    radialGradient      := GenImageGradientRadial(screenWidth, screenHeight, 0, WHITE, BLACK)
    squareGradient      := GenImageGradientSquare(screenWidth, screenHeight, 0, WHITE, BLACK)
    checked             := GenImageChecked(screenWidth, screenHeight, 32, 32, RED, BLUE)
    whiteNoise          := GenImageWhiteNoise(screenWidth, screenHeight, 0.5)
    perlinNoise         := GenImagePerlinNoise(screenWidth, screenHeight, 50, 50, 4)
    cellular            := GenImageCellular(screenWidth, screenHeight, 32)

    textures: [NUM_TEXTURES]Texture2D

    textures[0] = LoadTextureFromImage(verticalGradient)
    textures[1] = LoadTextureFromImage(horizontalGradient)
    textures[2] = LoadTextureFromImage(diagonalGradient)
    textures[3] = LoadTextureFromImage(radialGradient)
    textures[4] = LoadTextureFromImage(squareGradient)
    textures[5] = LoadTextureFromImage(checked)
    textures[6] = LoadTextureFromImage(whiteNoise)
    textures[7] = LoadTextureFromImage(perlinNoise)
    textures[8] = LoadTextureFromImage(cellular)

    defer for i in 0..<NUM_TEXTURES {
        UnloadTexture(textures[i])
    }

    UnloadImage(verticalGradient)
    UnloadImage(horizontalGradient)
    UnloadImage(diagonalGradient)
    UnloadImage(radialGradient)
    UnloadImage(squareGradient)
    UnloadImage(checked)
    UnloadImage(whiteNoise)
    UnloadImage(perlinNoise)
    UnloadImage(cellular)

    currentTexture := 0

    SetTargetFPS(60)

    for !WindowShouldClose() {
        if IsMouseButtonPressed(.LEFT) || IsKeyPressed(.RIGHT) {
            currentTexture = (currentTexture + 1) % NUM_TEXTURES
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)

            DrawTexture(textures[currentTexture], 0, 0, WHITE)

            DrawRectangle(30, 400, 325, 30, Fade(SKYBLUE, 0.5))
            DrawRectangleLines(30, 400, 325, 30, Fade(WHITE, 0.5))
            DrawText("MOUSE LEFT BUTTON to CYCLE PROCEDURAL TEXTURES", 40, 410, 10, WHITE)

            switch(currentTexture) {
                case 0: DrawText("VERTICAL GRADIENT", 560, 10, 20, RAYWHITE)
                case 1: DrawText("HORIZONTAL GRADIENT", 540, 10, 20, RAYWHITE)
                case 2: DrawText("DIAGONAL GRADIENT", 540, 10, 20, RAYWHITE)
                case 3: DrawText("RADIAL GRADIENT", 580, 10, 20, LIGHTGRAY)
                case 4: DrawText("SQUARE GRADIENT", 580, 10, 20, LIGHTGRAY)
                case 5: DrawText("CHECKED", 680, 10, 20, RAYWHITE)
                case 6: DrawText("WHITE NOISE", 640, 10, 20, RED)
                case 7: DrawText("PERLIN NOISE", 640, 10, 20, RED)
                case 8: DrawText("CELLULAR", 670, 10, 20, RAYWHITE)
            }
        }
    }
}