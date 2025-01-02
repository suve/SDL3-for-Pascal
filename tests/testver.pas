{
  This file is part of:

    SDL3 for Pascal
    (https://github.com/PascalGameDevelopment/SDL3-for-Pascal)
    SPDX-License-Identifier: Zlib
}

{ Test is based on testver.c }

{$DEFINE C_VARIADIC_LOG} // !!! This define compiles Case 2. Comment out for Case 1 !!!

program testver;

uses
  SDL3 {$IFNDEF C_VARIADIC_LOG}, SysUtils{$ENDIF};

var
  version: Integer;

begin
  if SDL_VERSION_ATLEAST(3, 0, 0) then
    SDL_Log('Compiled with SDL 3.0 or newer')
  else
    SDL_Log('Compiled with SDL older than 3.0');

{ Case 1: Do NOT use C's variadic function:

  Uses SDL_Log(fmt: PAnsiChar) with only the string parameter.
  There is not variadic part in the SDL function itself.

  The variadic part is provided by Pascal's Format() function
  from SysUtils. }
{$IFNDEF C_VARIADIC_LOG}
  SDL_Log('Case 1: SDL_Log without variadic part.');
  SDL_Log(PChar(Format('Compiled version: %d.%d.%d (%s)',[
          SDL_MAJOR_VERSION, SDL_MINOR_VERSION, SDL_MICRO_VERSION,
          SDL_REVISION])));
  version := SDL_GetVersion();
  SDL_Log(PChar(Format('Runtime version: %d.%d.%d (%s)',
          [SDL_VERSIONNUM_MAJOR(version), SDL_VERSIONNUM_MINOR(version), SDL_VERSIONNUM_MICRO(version),
          SDL_GetRevision()])));
  {$ENDIF}

{ Case 2: Use C's variadic function:

  Uses SDL_Log(fmt: PAnsiChar; Args: array of const). The variadic part
  is provided directly by C's function. SysUtils is not needed. }
{$IFDEF C_VARIADIC_LOG}
  SDL_Log('Case 2: SDL_Log with variadic part.');
  SDL_Log('Compiled version: %d.%d.%d (%s)', [
          SDL_MAJOR_VERSION, SDL_MINOR_VERSION, SDL_MICRO_VERSION,
          SDL_REVISION]);
  version := SDL_GetVersion();
  SDL_Log('Runtime version: %d.%d.%d (%s)',
          [SDL_VERSIONNUM_MAJOR(version), SDL_VERSIONNUM_MINOR(version), SDL_VERSIONNUM_MICRO(version),
          SDL_GetRevision()]);
{$ENDIF}

  SDL_Quit();
end.

