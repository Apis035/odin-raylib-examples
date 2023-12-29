package textures

import "vendor:raylib"
import "core:math"
import "core:math/linalg"

MAX_POINTS :: 11

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [textures] example - textured polygon")
    defer CloseWindow()

    texcoords: [MAX_POINTS]Vector2 = {
        { 0.75, 0.0 },
        { 0.25, 0.0 },
        { 0.0, 0.5 },
        { 0.0, 0.75 },
        { 0.25, 1.0 },
        { 0.375, 0.875 },
        { 0.625, 0.875 },
        { 0.75, 1.0 },
        { 1.0, 0.75 },
        { 1.0, 0.5 },
        { 0.75, 0.0 },
    }

    points: [MAX_POINTS]Vector2
    for i in 0..<MAX_POINTS {
        points[i] = (texcoords[i] - 0.5) * 256
    }

    positions: [MAX_POINTS]Vector2
    for i in 0..<MAX_POINTS {
        positions[i] = points[i]
    }

    texture := LoadTexture("resources/cat.png")
    defer UnloadTexture(texture)

    angle: f32

    SetTargetFPS(60)

    for !WindowShouldClose() {
        angle += 1
        for i in 0..<MAX_POINTS {
            positions[i] = Vector2Rotate(points[i], angle*DEG2RAD)
        }

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)

            DrawText("textured polygon", 20, 20, 20, DARKGRAY)

            DrawTexturePoly(texture, {f32(GetScreenWidth()/2), f32(GetScreenHeight()/2)}, positions[:], texcoords[:], MAX_POINTS, WHITE)
        }
    }
}

DrawTexturePoly :: proc(texture: raylib.Texture2D,
                        center: raylib.Vector2,
                        points, texcoords: []raylib.Vector2,
                        pointCount: i32, tint: raylib.Color) {
    using raylib

    rlSetTexture(texture.id)
    {
        rlBegin(RL_QUADS)

        rlColor4ub(tint.r, tint.g, tint.b, tint.a)

        for i in 0..<pointCount-1 {
            rlTexCoord2f(0.5, 0.5)
            rlVertex2f(center.x, center.y)

            rlTexCoord2f(texcoords[i].x, texcoords[i].y)
            rlVertex2f(points[i].x + center.x, points[i].y + center.y)

            rlTexCoord2f(texcoords[i+1].x, texcoords[i+1].y)
            rlVertex2f(points[i+1].x + center.x, points[i+1].y + center.y)

            rlTexCoord2f(texcoords[i+1].x, texcoords[i+1].y)
            rlVertex2f(points[i+1].x + center.x, points[i+1].y + center.y)
        }
        rlEnd()
    }
    rlSetTexture(0)
}

// temporary solution, i don't know which odin proc rotates a vector2
Vector2Rotate :: proc(v: raylib.Vector2, angle: f32) -> (result: raylib.Vector2) {
    cosres := math.cos(angle)
    sinres := math.sin(angle)

    result = {
        v.x*cosres - v.y*sinres,
        v.x*sinres + v.y*cosres,
    }

    return result
}