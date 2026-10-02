# ZigRain
Simple rain animation in Zig

# ZigRain

A simple rain animation built with **Zig 0.16.0**,to demonstrate practical use of Zig's new I/O APIs and C interoperability.




ZigRain animates falling raindrops across your screen using SDL2 for graphics. It's an educational project created to explore Zig 0.16.0's evolving language features and how seamlessly Zig integrates with C libraries.

## Key Learning Goals

### Zig's New I/O Context System
I wanted to use Zig 0.16.0's refactored I/O model. Instead of relying on global state, creating an `IoSource` from the process initialization context and using it to seed a cryptographically secure random number generator. Demonstrates the modern, composable approach to I/O in recent Zig versions.

### C Interoperability
I also wanted to explore `@cImport` to bring in SDL2 and directly call C functions from Zig code. This is practical C interop, no wrapper libraries, just clean integration with a mature graphics library. Notice how Zig's `@cInclude` directive handles the C types and how error handling works across language boundaries.

### Build Configuration: (Bypassing the zld .sframe Bug)
The build system forces the LLVM toolchain and LLD linker. 
(`use_llvm = true`, `use_lld = true` in `build.zig`). 
This works around a known issue with macOS's default `zld` linker and `.sframe` sections. 
If you're building on other platforms, these settings are safe but unnecessary. 
Adjust for your environment.

## Building & Running

```bash
zig build run
```
---

The build system handles SDL2 linking automatically. Make sure SDL2 development headers are installed on your system.

On macOS with Homebrew:
```bash
brew install SDL2
```
On Linux (Ubuntu/Debian):
```bash
sudo apt-get install libsdl2-dev
```
---

## How It Works

The program:

-    Initializes SDL2 and creates a window.
-    Seeds a random number generator from the process I/O context.
-    Spawns 150 raindrops at random positions.
-    Animates them falling downward each frame, respawning at the top when they exit the screen.
-    Renders at 60 FPS.

Exit by closing the window or pressing ESC.
Project Structure.

     main.zig : Core animation loop and rain physics
    build.zig : Build configuration with C library linking

---

This project was a way for me to bridge the gap between 
learning a new language feature,  and using it in a real context. 
Modern Zig emphasizes explicit control over I/O and resource management.
this rain animation seemed like a nice stepping stone for me to see that philosophy in action.
