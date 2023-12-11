package shapes

import "vendor:raylib"

MAX_COLORS_COUNT :: 21

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - colors palette")
    defer CloseWindow()

    colors: [MAX_COLORS_COUNT]Color = {
        DARKGRAY, MAROON, ORANGE, DARKGREEN, DARKBLUE, DARKPURPLE, DARKBROWN,
        GRAY, RED, GOLD, LIME, BLUE, VIOLET, BROWN, LIGHTGRAY, PINK, YELLOW,
        GREEN, SKYBLUE, PURPLE, BEIGE,
    }

    colorNames: [MAX_COLORS_COUNT]cstring = {
        "DARKGRAY", "MAROON", "ORANGE", "DARKGREEN", "DARKBLUE", "DARKPURPLE",
        "DARKBROWN", "GRAY", "RED", "GOLD", "LIME", "BLUE", "VIOLET", "BROWN",
        "LIGHTGRAY", "PINK", "YELLOW", "GREEN", "SKYBLUE", "PURPLE", "BEIGE",
    }

    colorRecs: [MAX_COLORS_COUNT]Rectangle

    for i := 0; i < MAX_COLORS_COUNT; i += 1 {
        colorRecs[i].x = f32(20 + 100 * (i%7) + 10 * (i%7))
        colorRecs[i].y = f32(80 + 100 * (i/7) + 10 * (i/7))
        colorRecs[i].width = 100
        colorRecs[i].height = 100
    }

    colorState: [MAX_COLORS_COUNT]enum {
        DEFAULT,
        HOVER,
    }

    mousePoint: Vector2 = {0, 0}

    SetTargetFPS(60)

    for !WindowShouldClose() {
        mousePoint = GetMousePosition()

        for i := 0; i < MAX_COLORS_COUNT; i += 1 {
            if CheckCollisionPointRec(mousePoint, colorRecs[i]) {
                colorState[i] = .HOVER
            } else {
                colorState[i] = .DEFAULT
            }
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)

            DrawText("raylib colors palette", 28, 42, 20, BLACK)
            DrawText("press SPACE to see all colors", GetScreenWidth() - 180, GetScreenHeight() - 40, 10, GRAY)

            for i := 0; i < MAX_COLORS_COUNT; i += 1 {
                DrawRectangleRec(colorRecs[i], Fade(colors[i], colorState[i] == .DEFAULT ? 0.6 : 1))

                if IsKeyDown(.SPACE) || colorState[i] == .HOVER {
                    DrawRectangle(i32(colorRecs[i].x), i32(colorRecs[i].y + colorRecs[i].height) - 26, i32(colorRecs[i].width), 20, BLACK)
                    DrawRectangleLinesEx(colorRecs[i], 6, Fade(BLACK, 0.3))
                    DrawText(colorNames[i], i32(colorRecs[i].x + colorRecs[i].width) - MeasureText(colorNames[i], 10) - 12, i32(colorRecs[i].y + colorRecs[i].height) - 20, 10, colors[i])
                }
            }
        }
    }
}