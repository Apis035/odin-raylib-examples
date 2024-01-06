# Raylib Odin Example

[Raylib](https://raylib.com/) [examples](https://github.com/raysan5/raylib/tree/master/examples) ported to [Odin](https://odin-lang.org/) programming language.

### Quickly running a single example

Within Visual Studio Code, you can run build task command (`Terminal` > `Run Build Task...` or `ctrl + shift + B`) while opening an example file to run it.

### Build all examples

Execute `build.bat` file. You can supply additional parameter to change compilation process:
- Build optimization: `none`, `minimal`, `speed`, `size`, `aggressive`
- Enable UPX packing: `upx`
- Use LLD for linking: `lld`
- Clean output files: `clean`

Example:
```batch
build               %= build all examples =%
build speed         %= build with speed optimization =%
build none lld      %= build with no optimization, use LLD linker =%
build size upx      %= build optimized for size, compress with upx =%
```

[UPX](https://upx.github.io/) needs to be callable from enviroment variable for compressing with `upx` flag.

---

Note: VSCode build task and build script currently only work on Windows.