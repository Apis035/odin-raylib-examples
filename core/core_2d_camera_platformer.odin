package core

import rl "vendor:raylib"
import "core:math/linalg"

GRAVITY:         f32 : 400
PLAYER_JUMP_SPD: f32 : 350
PLAYER_HOR_SPD:  f32 : 200

Player :: struct {
    position: rl.Vector2,
    speed:    f32,
    canJump:  bool,
}

EnvItem :: struct {
    rect:     rl.Rectangle,
    blocking: bool,
    color:    rl.Color,
}

main :: proc() {
    using rl

    screenWidth  :: 800
    screenHeight :: 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera")
    defer CloseWindow()

    player: Player
    player.position = {400, 280}
    player.speed    = 0
    player.canJump  = false

    envItems: []EnvItem = {
        {{0, 0,   1000, 400}, false, LIGHTGRAY},
        {{0, 400, 1000, 200}, true,  GRAY},
        {{300, 200, 400, 10}, true,  GRAY},
        {{250, 300, 100, 10}, true,  GRAY},
        {{650, 300, 100, 10}, true,  GRAY},
    }

    camera: Camera2D
    camera.target   = player.position
    camera.offset   = {f32(screenWidth)/2, f32(screenHeight)/2}
    camera.rotation = 0
    camera.zoom     = 1

    cameraUpdaters: []proc(^Camera2D, ^Player, []EnvItem, f32, i32, i32) = {
        UpdateCameraCenter,
        UpdateCameraCenterInsideMap,
        UpdateCameraCenterSmoothFollow,
        UpdateCameraEvenOutOnLanding,
        UpdateCameraPlayerBoundsPush,
    }

    cameraOption := 0

    cameraDescriptions: []cstring = {
        "Follow player center",
        "Follow plater center, but clamp to map edges",
        "Follow player center; smoothed",
        "Follow player center horizontally; update player center vertically after landing",
        "Player push camera on getting too close to screen edge",
    }

    SetTargetFPS(60)

    for !WindowShouldClose() {
        deltaTime := GetFrameTime()

        UpdatePlayer(&player, envItems, deltaTime)

        camera.zoom += GetMouseWheelMove() * 0.05
        camera.zoom = clamp(camera.zoom, 0.25, 3)

        if IsKeyPressed(.R) {
            camera.zoom = 1
            player.position = {400, 280}
        }

        if IsKeyPressed(.C) {
            cameraOption = (cameraOption + 1) % len(cameraUpdaters)
        }

        cameraUpdaters[cameraOption](&camera, &player, envItems, deltaTime, screenWidth, screenHeight)

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(LIGHTGRAY)

            {
                BeginMode2D(camera)
                defer EndMode2D()

                for i := 0; i < len(envItems); i += 1 {
                    DrawRectangleRec(envItems[i].rect, envItems[i].color)
                }

                playerRect: Rectangle = {player.position.x - 20, player.position.y - 40, 40, 40}
                DrawRectangleRec(playerRect, RED)
            }

            DrawText("Controls:", 20, 20, 10, BLACK)
            DrawText("- Right/Left to move", 40, 40, 10, DARKGRAY)
            DrawText("- Space to jump", 40, 60, 10, DARKGRAY)
            DrawText("- Mouse Wheel to Zoom in-out, R to reset zoom", 40, 80, 10, DARKGRAY)
            DrawText("- C to change camera mode", 40, 100, 10, DARKGRAY)
            DrawText("Current camera mode:", 20, 120, 10, BLACK)
            DrawText(cameraDescriptions[cameraOption], 40, 140, 10, DARKGRAY)
        }
    }
}

UpdatePlayer :: proc(player: ^Player, envItems: []EnvItem, delta: f32) {
    using rl

    if IsKeyDown(.LEFT)  { player.position.x -= PLAYER_HOR_SPD * delta }
    if IsKeyDown(.RIGHT) { player.position.x += PLAYER_HOR_SPD * delta }
    if IsKeyDown(.SPACE) && player.canJump {
        player.speed = -PLAYER_JUMP_SPD
        player.canJump = false
    }

    hitObstacle := false

    for i := 0; i < len(envItems); i += 1 {
        ei := envItems[i]
        p  := player.position
        if ei.blocking &&
                ei.rect.x <= p.x &&
                ei.rect.x + ei.rect.width >= p.x &&
                ei.rect.y >= p.y &&
                ei.rect.y <= p.y + player.speed * delta {
            hitObstacle = true
            player.speed = 0
            p.y = ei.rect.y
        }
    }

    if !hitObstacle {
        player.position.y += player.speed * delta
        player.speed += GRAVITY * delta
        player.canJump = false
    } else {
        player.canJump = true
    }
}

UpdateCameraCenter :: proc(camera: ^rl.Camera2D, player: ^Player, envItems: []EnvItem, delta: f32, width, height: i32) {
    camera.offset = {f32(width)/2, f32(height)/2}
    camera.target = player.position
}

UpdateCameraCenterInsideMap :: proc(camera: ^rl.Camera2D, player: ^Player, envItems: []EnvItem, delta: f32, width, height: i32) {
    camera.target = player.position
    camera.offset = {f32(width)/2, f32(height)/2}

    minX, minY, maxX, maxY: f32 = 1000, 1000, -1000, -1000

    for i := 0; i < len(envItems); i += 1 {
        ei := envItems[i]
        minX = min(ei.rect.x, minX)
        maxX = max(ei.rect.x + ei.rect.width, maxX)
        minY = min(ei.rect.y, minY)
        maxY = max(ei.rect.y + ei.rect.height, maxY)
    }

    using rl

    posMax := GetWorldToScreen2D({maxX, maxY}, camera^)
    posMin := GetWorldToScreen2D({minX, minY}, camera^)

    // writing f32(width) and f32(height) everywhere is confusing
    fw := f32(width)
    fh := f32(height)

    if posMax.x < fw { camera.offset.x = fw - (posMax.x - fw/2) }
    if posMax.y < fh { camera.offset.y = fh - (posMax.y - fh/2) }
    if posMin.x > 0  { camera.offset.x = fw/2 - posMin.x }
    if posMin.y > 0  { camera.offset.y = fh/2 - posMin.y }
}

UpdateCameraCenterSmoothFollow :: proc(camera: ^rl.Camera2D, player: ^Player, envItems: []EnvItem, delta: f32, width, height: i32) {
    minSpeed:        f32 : 30
    minEffectLength: f32 : 10
    fractionSpeed:   f32 : 0.8

    camera.offset = {f32(width)/2, f32(height)/2}
    diff := player.position - camera.target
    length := linalg.length(diff)

    if length > minEffectLength {
        speed := max(fractionSpeed * length, minSpeed)
        camera.target = camera.target + diff * (speed*delta/length)
    }
}

UpdateCameraEvenOutOnLanding :: proc(camera: ^rl.Camera2D, player: ^Player, envItems: []EnvItem, delta: f32, width, height: i32) {
    @(static) evenOutSpeed:  f32 = 700
    @(static) eveningOut:        = false
    @(static) evenOutTarget: f32

    camera.offset = {f32(width)/2, f32(height)/2}
    camera.target.x = player.position.x

    if eveningOut {
        if evenOutTarget > camera.target.y {
            camera.target.y += evenOutSpeed * delta

            if camera.target.y > evenOutTarget {
                camera.target.y = evenOutTarget
                eveningOut = false
            }
        } else {
            camera.target.y -= evenOutSpeed * delta

            if camera.target.y < evenOutTarget {
                camera.target.y = evenOutTarget
                eveningOut = false
            }
        }
    } else {
        if player.canJump && player.speed == 0 && player.position.y != camera.target.y {
            eveningOut = true
            evenOutTarget = player.position.y
        }
    }
}

UpdateCameraPlayerBoundsPush :: proc(camera: ^rl.Camera2D, player: ^Player, envItems: []EnvItem, delta: f32, width, height: i32) {
    using rl

    @(static) bbox: Vector2 = {0.2, 0.2}

    fw := f32(width)
    fh := f32(height)

    bboxWorldMin := GetScreenToWorld2D({(1-bbox.x) * 0.5 * fw, (1-bbox.y) * 0.5 * fh}, camera^)
    bboxWorldMax := GetScreenToWorld2D({(1+bbox.x) * 0.5 * fw, (1+bbox.y) * 0.5 * fh}, camera^)

    camera.offset = {(1-bbox.x) * 0.5 * fw, (1-bbox.y) * 0.5 * fh}

    if player.position.x < bboxWorldMin.x { camera.target.x = player.position.x }
    if player.position.y < bboxWorldMin.y { camera.target.y = player.position.y }
    if player.position.x > bboxWorldMax.x { camera.target.x = bboxWorldMin.x + (player.position.x - bboxWorldMax.x) }
    if player.position.y > bboxWorldMax.y { camera.target.y = bboxWorldMin.y + (player.position.y - bboxWorldMax.y) }
}
