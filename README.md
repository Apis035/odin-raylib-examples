# Raylib Odin Example

[Raylib](https://raylib.com/) [examples](https://github.com/raysan5/raylib/tree/master/examples) ported to [Odin](https://odin-lang.org/) programming language.

### Running a single file

Within Visual Studio Code, you can run build task command (`Terminal` > `Run Build Task...` or `ctrl + shift + B`) while opening an example file to run it.

### Build all example

Execute `build.bat` file. Supply additional parameter for build optimization. Compiled executable are in *bin* folder.

```batch
:: No optimization, fast compile
build none

:: Optimize speed
build speed

:: Optimize size
build size
```

Use `clean` parameter to clean output folder.

If you have [UPX](https://upx.github.io/) installed, supply `upx` to second parameter to pack the executable to make it smaller.

```batch
build aggressive upx
```

---

Note: VSCode build task and build batch script only work on Windows.