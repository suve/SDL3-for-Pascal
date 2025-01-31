{
  This file is part of:

    SDL3 for Pascal
    (https://github.com/PascalGameDevelopment/SDL3-for-Pascal)
    SPDX-License-Identifier: Zlib
}

{ Test some macros from SDL_audio.inc }

program testaudiomacros;

uses
  SDL3;

begin

  SDL_Log('SDL_AUDIO_BITSIZE(SDL_AUDIO_S16) returns: %d (should be 16)',[SDL_AUDIO_BITSIZE(SDL_AUDIO_S16)]);
  SDL_Log('SDL_AUDIO_BITSIZE(SDL_AUDIO_F32LE) returns: %d (should be 32)',[SDL_AUDIO_BITSIZE(SDL_AUDIO_F32LE)]);
  SDL_Log('SDL_AUDIO_BYTESIZE(SDL_AUDIO_S16) returns: %d (should be 2)',[SDL_AUDIO_BYTESIZE(SDL_AUDIO_S16)]);
  SDL_Log('SDL_AUDIO_ISFLOAT(SDL_AUDIO_S16) returns: %d (should be 0)',[SDL_AUDIO_ISFLOAT(SDL_AUDIO_S16)]);
  SDL_Log('SDL_AUDIO_ISBIGENDIAN(SDL_AUDIO_S16LE) returns: %d (should be 0)',[SDL_AUDIO_ISBIGENDIAN(SDL_AUDIO_S16LE)]);
  SDL_Log('SDL_AUDIO_ISBIGENDIAN(SDL_AUDIO_S16BE) returns: %d (should be )',[SDL_AUDIO_ISBIGENDIAN(SDL_AUDIO_S16BE)]);
  SDL_Log('SDL_AUDIO_ISLITTLEENDIAN(SDL_AUDIO_S16BE) returns: %d (should be 0)',[SDL_AUDIO_ISLITTLEENDIAN(SDL_AUDIO_S16BE)]);
  SDL_Log('SDL_AUDIO_ISLITTLEENDIAN(SDL_AUDIO_S16LE) returns: %d (should be )',[SDL_AUDIO_ISLITTLEENDIAN(SDL_AUDIO_S16LE)]);
  SDL_Log('SDL_AUDIO_ISSIGNED(SDL_AUDIO_U8) returns: %d (should be 0)',[SDL_AUDIO_ISSIGNED(SDL_AUDIO_U8)]);
  SDL_Log('SDL_AUDIO_ISINT(SDL_AUDIO_F32) returns: %d (should be 0)',[SDL_AUDIO_ISINT(SDL_AUDIO_F32)]);
  SDL_Log('SDL_AUDIO_ISUNSIGNED(SDL_AUDIO_S16) returns: %d (should be 0)',[SDL_AUDIO_ISUNSIGNED(SDL_AUDIO_S16)]);

end.

