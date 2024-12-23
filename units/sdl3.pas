unit SDL3;

{
                                SDL3-for-Pascal
                               =================
          Pascal units for SDL3 - Simple Direct MediaLayer, Version 3

  (to be extended - todo)

}

{$I sdl.inc}

interface

  {$IFDEF WINDOWS}
    uses
      {$IFDEF FPC}
      ctypes,
      {$ENDIF}
      Windows;
  {$ENDIF}

  {$IF DEFINED(UNIX) AND NOT DEFINED(ANDROID)}
    uses
      {$IFDEF FPC}
      ctypes,
      UnixType,
      {$ENDIF}
      {$IFDEF DARWIN}
      CocoaAll;
      {$ELSE}
      X,
      XLib;
      {$ENDIF}
  {$ENDIF}

  {$IF DEFINED(UNIX) AND DEFINED(ANDROID) AND DEFINED(FPC)}
    uses
      ctypes,
      UnixType;
  {$ENDIF}

const

  {$IFDEF WINDOWS}
    SDL_LibName = 'SDL3.dll';
  {$ENDIF}

  {$IFDEF UNIX}
    {$IFDEF DARWIN}
      SDL_LibName = 'libSDL3.dylib';
      {$IFDEF FPC}
        {$LINKLIB libSDL2}
      {$ENDIF}
    {$ELSE}
      {$IFDEF FPC}
        SDL_LibName = 'libSDL3.so';
      {$ELSE}
        SDL_LibName = 'libSDL3.so.0';
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  {$IFDEF MACOS}
    SDL_LibName = 'SDL3';
    {$IFDEF FPC}
      {$linklib libSDL3}
    {$ENDIF}
  {$ENDIF}

{ The include file translates
  corresponding C header file.
                                          Inc file was updated against
  SDL_init.inc --> SDL_init.h             this version of the header file: }
{$I SDL_init.inc}                         // 3.1.6-prev
{$I SDL_log.inc}                          // 3.1.6-prev
{$I SDL_version.inc}                      // 3.1.6-prev
{$I SDL_revision.inc}                     // 3.1.6-prev

implementation

{ Macros from SDL_version.h }
function SDL_VERSIONNUM(major, minor, patch: Integer): Integer;
begin
  Result:=(major*1000000)+(minor*1000)+patch;
end;

function SDL_VERSIONNUM_MAJOR(version: Integer): Integer;
begin
  Result:=version div 1000000;
end;

function SDL_VERSIONNUM_MINOR(version: Integer): Integer;
begin
  Result:=(version div 1000) mod 1000;
end;

function SDL_VERSIONNUM_MICRO(version: Integer): Integer;
begin
  Result:=version mod 1000;
end;

function SDL_VERSION: Integer;
begin
  Result:=SDL_VERSIONNUM(SDL_MAJOR_VERSION, SDL_MINOR_VERSION, SDL_MICRO_VERSION);
end;

function SDL_VERSION_ATLEAST(X, Y, Z: Integer): Boolean;
begin
  if (SDL_VERSION >= SDL_VERSIONNUM(X, Y, Z)) then
    Result:=True
  else
    Result:=False;
end;

end.

