{
  This file is part of:

    SDL3 for Pascal
    (https://github.com/PascalGameDevelopment/SDL3-for-Pascal)
    SPDX-License-Identifier: Zlib
}

{ Test is based on testver.c }

program testver;

uses
  SDL3, SysUtils;

var
  version: Integer;

begin
  if SDL_VERSION_ATLEAST(3, 0, 0) then
    SDL_Log('Compiled with SDL 3.0 or newer')
  else
    SDL_Log('Compiled with SDL older than 3.0');

  SDL_Log(PChar(Format('Compiled version: %d.%d.%d (%s)',[
          SDL_MAJOR_VERSION, SDL_MINOR_VERSION, SDL_MICRO_VERSION,
          SDL_REVISION])));
  version := SDL_GetVersion();
  SDL_Log(PChar(Format('Runtime version: %d.%d.%d (%s)',
          [SDL_VERSIONNUM_MAJOR(version), SDL_VERSIONNUM_MINOR(version), SDL_VERSIONNUM_MICRO(version),
          SDL_GetRevision()])));
  SDL_Quit();
end.

