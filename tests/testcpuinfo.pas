{
  This file is part of:

    SDL3 for Pascal
    (https://github.com/PascalGameDevelopment/SDL3-for-Pascal)
    SPDX-License-Identifier: Zlib
}

{ Test CPU Info routines }

program testcpuinfo;

uses
  SDL3;

begin

  SDL_Log('SDL_GetNumLogicalCPUCores: %d',[SDL_GetNumLogicalCPUCores]);
  SDL_Log('SDL_GetCPUCacheLineSize: %d',[SDL_GetCPUCacheLineSize]);
  SDL_Log('SDL_HasAltiVec: %d',[SDL_HasAltiVec]);
  SDL_Log('SDL_HasMMX: %d',[SDL_HasMMX]);
  SDL_Log('SDL_HasSSE: %d',[SDL_HasSSE]);
  SDL_Log('SDL_HasSSE2: %d',[SDL_HasSSE2]);
  SDL_Log('SDL_HasSSE3: %d',[SDL_HasSSE3]);
  SDL_Log('SDL_HasSSE41: %d',[SDL_HasSSE41]);
  SDL_Log('SDL_HasSSE42: %d',[SDL_HasSSE42]);
  SDL_Log('SDL_HasAVX: %d',[SDL_HasAVX]);
  SDL_Log('SDL_HasAVX2: %d',[SDL_HasAVX2]);
  SDL_Log('SDL_HasAVX512F: %d',[SDL_HasAVX512F]);
  SDL_Log('SDL_HasARMSIMD: %d',[SDL_HasARMSIMD]);
  SDL_Log('SDL_HasNEON: %d',[SDL_HasNEON]);
  SDL_Log('SDL_HasLSX: %d',[SDL_HasLSX]);
  SDL_Log('SDL_HasLASX: %d',[SDL_HasLASX]);
  SDL_Log('SDL_GetSystemRAM: %d',[SDL_GetSystemRAM]);
  SDL_Log('SDL_GetSIMDAlignment: %d',[SDL_GetSIMDAlignment]);

end.

