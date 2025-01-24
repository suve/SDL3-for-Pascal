{*
 * This is a unique ID for a mouse for the time it is connected to the system,
 * and is never reused for the lifetime of the application.
 *
 * If the mouse is disconnected and reconnected, it will get a new ID.
 *
 * The value 0 is an invalid ID.
 *
 * \since This datatype is available since SDL 3.1.3.
  }
type
  PPSDL_MouseID = ^PSDL_MouseID;
  PSDL_MouseID = ^TSDL_MouseID;
  TSDL_MouseID = cuint32;

{*
 * Scroll direction types for the Scroll event
 *
 * \since This enum is available since SDL 3.1.3.
  }
type
  PPSDL_MouseWheelDirection = ^PSDL_MouseWheelDirection;
  PSDL_MouseWheelDirection = ^TSDL_MouseWheelDirection;
  TSDL_MouseWheelDirection =  Integer;
const
  SDL_MOUSEWHEEL_NORMAL = TSDL_MouseWheelDirection(0);  {*< The scroll direction is normal  }
  SDL_MOUSEWHEEL_FLIPPED = TSDL_MouseWheelDirection(1); {*< The scroll direction is flipped / natural  }

{*
 * A bitmask of pressed mouse buttons, as reported by SDL_GetMouseState, etc.
 *
 * - Button 1: Left mouse button
 * - Button 2: Middle mouse button
 * - Button 3: Right mouse button
 * - Button 4: Side mouse button 1
 * - Button 5: Side mouse button 2
 *
 * \since This datatype is available since SDL 3.1.3.
 *
 * \sa SDL_GetMouseState
 * \sa SDL_GetGlobalMouseState
 * \sa SDL_GetRelativeMouseState
  }
type
  PPSDL_MouseButtonFlags = ^PSDL_MouseButtonFlags;
  PSDL_MouseButtonFlags = ^TSDL_MouseButtonFlags;
  TSDL_MouseButtonFlags = cuint32;
