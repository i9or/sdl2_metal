#include <SDL.h>
#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>

int main() {
  SDL_SetHint(SDL_HINT_RENDER_DRIVER, "metal");
  SDL_InitSubSystem(SDL_INIT_VIDEO);
  SDL_Window *window = SDL_CreateWindow("SDL2 Metal", -1, -1, 640, 480, SDL_WINDOW_ALLOW_HIGHDPI);
  SDL_Renderer *renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_PRESENTVSYNC);

  const CAMetalLayer *swapChain = (__bridge CAMetalLayer *)SDL_RenderGetMetalLayer(renderer);

  const id<MTLDevice> gpu = swapChain.device;
  const id<MTLCommandQueue> queue = [gpu newCommandQueue];

  MTLClearColor color = MTLClearColorMake(0, 0, 0, 1);

  bool isRunning = true;
  SDL_Event e;
  auto sign = 1;

  while (isRunning) {
    while (SDL_PollEvent(&e) != 0) {
      switch (e.type) {
        case SDL_KEYDOWN:
        case SDL_QUIT:
          isRunning = false;
          break;
      }
    }

    @autoreleasepool {
      id<CAMetalDrawable> surface = [swapChain nextDrawable];

      if (color.red > 1.0) {
        sign = -1;
      } else if (color.red <= 0.0) {
        sign = 1;
      }

      color.red = color.red + 0.01 * sign;

      SDL_Log("%f\n", color.red);

      MTLRenderPassDescriptor *pass = [MTLRenderPassDescriptor renderPassDescriptor];

      pass.colorAttachments[0].clearColor = color;
      pass.colorAttachments[0].loadAction = MTLLoadActionClear;
      pass.colorAttachments[0].storeAction = MTLStoreActionStore;
      pass.colorAttachments[0].texture = surface.texture;

      id<MTLCommandBuffer> buffer = [queue commandBuffer];
      id<MTLRenderCommandEncoder> encoder = [buffer renderCommandEncoderWithDescriptor:pass];

      [encoder endEncoding];
      [buffer presentDrawable:surface];
      [buffer commit];
    }
  }

  SDL_DestroyRenderer(renderer);
  SDL_DestroyWindow(window);
  SDL_Quit();

  [queue release]
  [gpu release]

  return 0;
}
