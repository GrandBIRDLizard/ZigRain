const std = @import("std");
const c = @cImport({
    @cInclude("SDL2/SDL.h");
});

const WINDOW_WIDTH = 800;
const WINDOW_HEIGHT = 600;
const NUM_DROPS = 150;

const Drop = struct {
    x: i32,
    y: i32,
};

pub fn main(init: std.process.Init) !void {
    if (c.SDL_Init(c.SDL_INIT_VIDEO) != 0) {
        c.SDL_Log("Unable to initialize SDL: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    }
    defer c.SDL_Quit();

    const window = c.SDL_CreateWindow("Rain Effect", c.SDL_WINDOWPOS_CENTERED, c.SDL_WINDOWPOS_CENTERED, WINDOW_WIDTH, WINDOW_HEIGHT, c.SDL_WINDOW_SHOWN) orelse {
        c.SDL_Log("Unable to create window: %s", c.SDL_GetError());
        return error.SDLWindowCreationFailed;
    };
    defer c.SDL_DestroyWindow(window);

    const renderer = c.SDL_CreateRenderer(window, -1, c.SDL_RENDERER_ACCELERATED) orelse {
        c.SDL_Log("Unable to create renderer: %s", c.SDL_GetError());
        return error.SDLRendererCreationFailed;
    };
    defer c.SDL_DestroyRenderer(renderer);

    // Create an interface with new I/O context
    const rng_impl: std.Random.IoSource = .{ .io = init.io };
    const secureRand = rng_impl.interface();
    
    // Seed PRNG
    var prng = std.Random.DefaultPrng.init(secureRand.int(u64));
    const random = prng.random();


    // Start Raindrops
    var drops: [NUM_DROPS]Drop = undefined;
    for (&drops) |*drop| {
        drop.x = random.intRangeAtMost(i32, 0, WINDOW_WIDTH);
        drop.y = random.intRangeAtMost(i32, -WINDOW_HEIGHT, WINDOW_HEIGHT);
    }

    var rectangle = c.SDL_Rect{ .x = 0, .y = 0, .w = 2, .h = 20 };
    const velocity_y: i32 = 4;
    var is_running = true;
    
    // Main Loop
    while (is_running) {
        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event) != 0) {
            if (event.type == c.SDL_QUIT) is_running = false;
            if (event.type == c.SDL_KEYDOWN and event.key.keysym.sym == c.SDLK_ESCAPE) is_running = false;
        }

        // Update
        for (&drops) |*drop| {
            drop.y += velocity_y;
            if (drop.y > WINDOW_HEIGHT) {
                drop.y = random.intRangeAtMost(i32, -40, -20);
                drop.x = random.intRangeAtMost(i32, 0, WINDOW_WIDTH); 
            }
        }

        // Render
        _ = c.SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
        _ = c.SDL_RenderClear(renderer);

        _ = c.SDL_SetRenderDrawColor(renderer, 0, 255, 255, 255); //RainDrops
        for (drops) |drop| {
            rectangle.x = drop.x;
            rectangle.y = drop.y;
            _ = c.SDL_RenderFillRect(renderer, &rectangle);
        }

        c.SDL_RenderPresent(renderer);
        c.SDL_Delay(16); //~60 FPS
    }
}
