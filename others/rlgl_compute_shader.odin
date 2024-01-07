package others

import "vendor:raylib"

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
    golLogicShader  := rlCompileShader(cstring(golLogicCode), RL_COMPUTE_SHADER)
    golLogicProgram := rlLoadComputeShaderProgram(golLogicShader)
    defer rlUnloadShaderProgram(golLogicProgram)
    UnloadFileText(golLogicCode)

    golRenderShader := LoadShader(nil, "resources/shaders/glsl430/gol_render.glsl")
    resUniformLoc   := ShaderLocationIndex(GetShaderLocation(golRenderShader, "resolution"))
    defer UnloadShader(golRenderShader)

    golTransfertCode    := LoadFileText("resources/shaders/glsl430/gol_transfert.glsl")
    golTransfertShader  := rlCompileShader(cstring(golTransfertCode), RL_COMPUTE_SHADER)
    golTransfertProgram := rlLoadComputeShaderProgram(golTransfertShader)
    defer rlUnloadShaderProgram(golTransfertProgram)
    UnloadFileText(golTransfertCode)

    ssboA := rlLoadShaderBuffer(GOL_WIDTH*GOL_WIDTH*size_of(u32), nil, RL_DYNAMIC_COPY)
    ssboB := rlLoadShaderBuffer(GOL_WIDTH*GOL_WIDTH*size_of(u32), nil, RL_DYNAMIC_COPY)
    ssboTransfert := rlLoadShaderBuffer(size_of(GolUpdateSSBO), nil, RL_DYNAMIC_COPY)
    defer {
        rlUnloadShaderBuffer(ssboA)
        rlUnloadShaderBuffer(ssboB)
        rlUnloadShaderBuffer(ssboTransfert)
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
            rlUpdateShaderBuffer(ssboTransfert, &transfertBuffer, size_of(GolUpdateSSBO), 0)

            rlEnableShader(golTransfertProgram)
            rlBindShaderBuffer(ssboA, 1)
            rlBindShaderBuffer(ssboTransfert, 3)
            rlComputeShaderDispatch(transfertBuffer.count, 1, 1)
            rlDisableShader()

            transfertBuffer.count = 0
        } else {
            rlEnableShader(golLogicProgram)
            rlBindShaderBuffer(ssboA, 1)
            rlBindShaderBuffer(ssboB, 2)
            rlComputeShaderDispatch(GOL_WIDTH/16, GOL_WIDTH/16, 1)
            rlDisableShader()

            ssboA, ssboB = ssboB, ssboA
        }

        rlBindShaderBuffer(ssboA, 1)
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