{*
 * SDL Audio Device instance IDs.
 *
 * Zero is used to signify an invalid/null device.
 *
 * \since This datatype is available since SDL 3.1.3.
  }
type
  PPSDL_AudioDeviceID = ^PSDL_AudioDeviceID;
  PSDL_AudioDeviceID = ^TSDL_AudioDeviceID;
  TSDL_AudioDeviceID = cuint32;

