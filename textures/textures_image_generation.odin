package textures

import "vendor:raylib"

NUM_TEXTURES :: 7 // 9

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [textures] example - procedural images generation")
    defer CloseWindow()

    // TODO: update gradient functions to raylib 5.0
    verticalGradient    := GenImageGradientV(screenWidth, screenHeight, RED, BLUE)
    horizontalGradient  := GenImageGradientH(screenWidth, screenHeight, RED, BLUE)
    // diagonalGradient    :=
    radialGradient      := GenImageGradientRadial(screenWidth, screenHeight, 0, WHITE, BLACK)
    // squareGradient      :=
    checked             := GenImageChecked(screenWidth, screenHeight, 32, 32, RED, BLUE)
    whiteNoise          := GenImageWhiteNoise(screenWidth, screenHeight, 0.5)
    perlinNoise         := GenImagePerlinNoise(screenWidth, screenHeight, 50, 50, 4)
    cellular            := GenImageCellular(screenWidth, screenHeight, 32)

    textures: [NUM_TEXTURES]Texture2D

    textures[0] = LoadTextureFromImage(verticalGradient)
    textures[1] = LoadTextureFromImage(horizontalGradient)
    // textures[] = LoadTextureFromImage(diagonalGradient)
    textures[2] = LoadTextureFromImage(radialGradient)
    // textures[3] = LoadTextureFromImage(squareGradient)
    textures[3] = LoadTextureFromImage(checked)
    textures[4] = LoadTextureFromImage(whiteNoise)
    textures[5] = LoadTextureFromImage(perlinNoise)
    textures[6] = LoadTextureFromImage(cellular)

    defer for i in 0..<NUM_TEXTURES {
        UnloadTexture(textures[i])
    }

    UnloadImage(verticalGradient)
    UnloadImage(horizontalGradient)
    // UnloadImage(diagonalGradient)
    UnloadImage(radialGradient)
    // UnloadImage(squareGradient)
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
                // case 2: DrawText("DIAGONAL GRADIENT", 540, 10, 20, RAYWHITE)
                case 2: DrawText("RADIAL GRADIENT", 580, 10, 20, LIGHTGRAY)
                // case 4: DrawText("SQUARE GRADIENT", 580, 10, 20, LIGHTGRAY)
                case 3: DrawText("CHECKED", 680, 10, 20, RAYWHITE)
                case 4: DrawText("WHITE NOISE", 640, 10, 20, RED)
                case 5: DrawText("PERLIN NOISE", 640, 10, 20, RED)
                case 6: DrawText("CELLULAR", 670, 10, 20, RAYWHITE)
            }
        }
    }
}