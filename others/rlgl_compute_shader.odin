// odin run rlgl_compute_shader.odin -file -debug -strict-style -max-error-count=3 -define:RAYLIB_SHARED=true
// This program simulates Conways "Game Of Life" in compute shaders.
// As of raylib v5.5 compute shaders require a Raylib rebuild for OpenGL 4.3 support! You need your own raylib.dll here.
package others

import "vendor:raylib"
import rlgl "vendor:raylib/rlgl"

// raylib need to be build with opengl 4.3 for this to work

GOL_WIDTH :: 768
MAX_BUFFERED_TRANSFERTS :: 48

GolUpdateCmd :: struct {
    x, y, w: u32,
    enabled: bool,
}

GolUpdateSSBO :: struct {
    count: u32,
    commands: [MAX_BUFFERED_TRANSFERTS]GolUpdateCmd,
}

main :: proc() {
    using raylib

    InitWindow(GOL_WIDTH, GOL_WIDTH, "raylib [rlgl] example - compute shader - game of life")
    defer CloseWindow()

    resolution: Vector2 = { GOL_WIDTH, GOL_WIDTH }
    brushSize: u32 = 8

    golLogicCode    := LoadFileText("resources/shaders/glsl430/gol.glsl")
    golLogicShader  := rlgl.CompileShader(cstring(golLogicCode), rlgl.COMPUTE_SHADER)
    golLogicProgram := rlgl.LoadComputeShaderProgram(golLogicShader)
    defer rlgl.UnloadShaderProgram(golLogicProgram)
    UnloadFileText(golLogicCode)

    golRenderShader := LoadShader(nil, "resources/shaders/glsl430/gol_render.glsl")
    resUniformLoc   := ShaderLocationIndex(GetShaderLocation(golRenderShader, "resolution"))
    defer UnloadShader(golRenderShader)

    golTransfertCode    := LoadFileText("resources/shaders/glsl430/gol_transfert.glsl")
    golTransfertShader  := rlgl.CompileShader(cstring(golTransfertCode), rlgl.COMPUTE_SHADER)
    golTransfertProgram := rlgl.LoadComputeShaderProgram(golTransfertShader)
    defer rlgl.UnloadShaderProgram(golTransfertProgram)
    UnloadFileText(golTransfertCode)

    ssboA := rlgl.LoadShaderBuffer(GOL_WIDTH*GOL_WIDTH*size_of(u32), nil, rlgl.DYNAMIC_COPY)
    ssboB := rlgl.LoadShaderBuffer(GOL_WIDTH*GOL_WIDTH*size_of(u32), nil, rlgl.DYNAMIC_COPY)
    ssboTransfert := rlgl.LoadShaderBuffer(size_of(GolUpdateSSBO), nil, rlgl.DYNAMIC_COPY)
    defer {
        rlgl.UnloadShaderBuffer(ssboA)
        rlgl.UnloadShaderBuffer(ssboB)
        rlgl.UnloadShaderBuffer(ssboTransfert)
    }

    transfertBuffer: GolUpdateSSBO

    whiteImage := GenImageColor(GOL_WIDTH, GOL_WIDTH, WHITE)
    whiteTex := LoadTextureFromImage(whiteImage)
    defer UnloadTexture(whiteTex)
    UnloadImage(whiteImage)

    for !WindowShouldClose() {
        brushSize += u32(GetMouseWheelMove())

        if (IsMouseButtonDown(.LEFT) || IsMouseButtonDown(.RIGHT)) && transfertBuffer.count < MAX_BUFFERED_TRANSFERTS {
            transfertBuffer.commands[transfertBuffer.count].x = u32(GetMouseX()) - brushSize/2
            transfertBuffer.commands[transfertBuffer.count].y = u32(GetMouseY()) - brushSize/2
            transfertBuffer.commands[transfertBuffer.count].w = brushSize
            transfertBuffer.commands[transfertBuffer.count].enabled = IsMouseButtonDown(.LEFT)
            transfertBuffer.count += 1
        } else if transfertBuffer.count > 0 {
            rlgl.UpdateShaderBuffer(ssboTransfert, &transfertBuffer, size_of(GolUpdateSSBO), 0)

            rlgl.EnableShader(golTransfertProgram)
            rlgl.BindShaderBuffer(ssboA, 1)
            rlgl.BindShaderBuffer(ssboTransfert, 3)
            rlgl.ComputeShaderDispatch(transfertBuffer.count, 1, 1)
            rlgl.DisableShader()

            transfertBuffer.count = 0
        } else {
            rlgl.EnableShader(golLogicProgram)
            rlgl.BindShaderBuffer(ssboA, 1)
            rlgl.BindShaderBuffer(ssboB, 2)
            rlgl.ComputeShaderDispatch(GOL_WIDTH/16, GOL_WIDTH/16, 1)
            rlgl.DisableShader()

            ssboA, ssboB = ssboB, ssboA
        }

        rlgl.BindShaderBuffer(ssboA, 1)
        SetShaderValue(golRenderShader, resUniformLoc, &resolution, .VEC2)

        {
            BeginDrawing()
            defer EndDrawing()

            ClearBackground(BLANK)

            BeginShaderMode(golRenderShader)
                DrawTexture(whiteTex, 0, 0, WHITE)
            EndShaderMode()

            DrawRectangleLines(
                i32(GetMouseX()) - i32(brushSize)/2,
                i32(GetMouseY()) - i32(brushSize)/2,
                i32(brushSize), i32(brushSize),
                RED,
            )

            DrawText("Use mouse wheel to increase/decrease brush size", 10, 10, 20, WHITE)
            DrawFPS(GetScreenWidth() - 100, 10)
        }
    }
}