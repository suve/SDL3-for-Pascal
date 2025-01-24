 {** The SDL keyboard scancode representation.
 *
 * An SDL scancode is the physical representation of a key on the keyboard,
 * independent of language and keyboard mapping.
 *
 * Values of this type are used to represent keyboard keys, among other places
 * in the `scancode` field of the SDL_KeyboardEvent structure.
 *
 * The values in this enumeration are based on the USB usage page standard:
 * https://usb.org/sites/default/files/hut1_5.pdf
 *
 * \since This enum is available since SDL 3.1.3.
  }
type
  PPSDL_Scancode = ^PSDL_Scancode;
  PSDL_Scancode = ^TSDL_Scancode;
  TSDL_Scancode =  Integer;
const
  SDL_SCANCODE_UNKNOWN = 0;

