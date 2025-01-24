{*
 * This is a unique ID for a sensor for the time it is connected to the
 * system, and is never reused for the lifetime of the application.
 *
 * The value 0 is an invalid ID.
 *
 * \since This datatype is available since SDL 3.1.3.
  }
type
  PPSDL_SensorID = ^PSDL_SensorID;
  PSDL_SensorID = ^TSDL_SensorID;
  TSDL_SensorID = cuint32;

