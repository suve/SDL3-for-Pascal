{*
 * This is a unique ID for a keyboard for the time it is connected to the
 * system, and is never reused for the lifetime of the application.
 *
 * If the keyboard is disconnected and reconnected, it will get a new ID.
 *
 * The value 0 is an invalid ID.
 *
 * \since This datatype is available since SDL 3.1.3.
  }
type
  PPSDL_KeyboardID = ^PSDL_KeyboardID;
  PSDL_KeyboardID = ^TSDL_KeyboardID;
  TSDL_KeyboardID = cuint32;

