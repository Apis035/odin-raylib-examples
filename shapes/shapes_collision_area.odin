package shapes

import "vendor:raylib"

main :: proc() {
    using raylib

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - collision area")
    defer CloseWindow()

    boxA: Rectangle = {10, f32(GetScreenHeight())/2 - 50, 200, 100}
    boxASpeedX: f32 = 4

    boxB: Rectangle = { f32(GetScreenWidth())/2 - 30, f32(GetScreenHeight())/2 - 30, 60, 60}

    boxCollision: Rectangle

    screenUpperLimit: i32 = 40

    pause     := false
    collision := false

    SetTargetFPS(60)

    for !WindowShouldClose() {
        if !pause do boxA.x += boxASpeedX

        if (boxA.x + boxA.width >= f32(GetScreenWidth())) || (boxA.x <= 0) do boxASpeedX *= -1

        boxB.x = f32(GetMouseX()) - boxB.width/2
        boxB.y = f32(GetMouseY()) - boxB.height/2

        boxB.x = clamp(boxB.x, 0, f32(GetScreenWidth()) - boxB.width)
        boxB.y = clamp(boxB.y, f32(screenUpperLimit), f32(GetScreenHeight()) - boxB.height)

        collision = CheckCollisionRecs(boxA, boxB)

        if collision do boxCollision = GetCollisionRec(boxA, boxB)

        if IsKeyPressed(.SPACE) do pause = !pause

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(RAYWHITE)

            DrawRectangle(0, 0, screenWidth, screenUpperLimit, collision ? RED : BLACK)

            DrawRectangleRec(boxA, GOLD)
            DrawRectangleRec(boxB, BLUE)

            if collision {
                DrawRectangleRec(boxCollision, LIME)

                text: cstring = "COLLISION!"
                DrawText(text, GetScreenWidth()/2 - MeasureText(text, 20)/2, screenUpperLimit/2 - 10, 20, BLACK)

                DrawText(TextFormat("Collision Area: %i", i32(boxCollision.width) * i32(boxCollision.height)), GetScreenWidth()/2 - 100, screenUpperLimit + 10, 20, BLACK)
            }

            DrawText("Press SPACE to PAUSE/RESUME", 20, screenHeight - 35, 20, LIGHTGRAY)

            DrawFPS(10, 10)
        }
    }
}