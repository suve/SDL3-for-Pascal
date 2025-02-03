{
  This file is part of:

    SDL3 for Pascal
    (https://github.com/PascalGameDevelopment/SDL3-for-Pascal)
    SPDX-License-Identifier: Zlib
}

{*
 * # CategoryClipboard
 *
 * SDL provides access to the system clipboard, both for reading information
 * from other processes and publishing information of its own.
 *
 * This is not just text! SDL apps can access and publish data by mimetype.
  }

{ Function prototypes  }

{*
 * Put UTF-8 text into the clipboard.
 *
 * \param text the text to store in the clipboard.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety You may only call this function from the main thread.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_GetClipboardText
 * \sa SDL_HasClipboardText
  }
function SDL_SetClipboardText(text: PAnsiChar): cbool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetClipboardText' {$ENDIF} {$ENDIF};

{*
 * Get UTF-8 text from the clipboard.
 *
 * This functions returns an empty string if there was not enough memory left
 * for a copy of the clipboard's content.
 *
 * \returns the clipboard text on success or an empty string on failure; call
 *          SDL_GetError() for more information. This should be freed with
 *          SDL_free() when it is no longer needed.
 *
 * \threadsafety You may only call this function from the main thread.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_HasClipboardText
 * \sa SDL_SetClipboardText
  }
function SDL_GetClipboardText: PAnsiChar; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetClipboardText' {$ENDIF} {$ENDIF};

{*
 * Query whether the clipboard exists and contains a non-empty text string.
 *
 * \returns true if the clipboard has text, or false if it does not.
 *
 * \threadsafety You may only call this function from the main thread.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_GetClipboardText
 * \sa SDL_SetClipboardText
  }
function SDL_HasClipboardText: cbool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_HasClipboardText' {$ENDIF} {$ENDIF};

{*
 * Put UTF-8 text into the primary selection.
 *
 * \param text the text to store in the primary selection.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety You may only call this function from the main thread.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_GetPrimarySelectionText
 * \sa SDL_HasPrimarySelectionText
  }
function SDL_SetPrimarySelectionText(text: PAnsiChar): cbool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetPrimarySelectionText' {$ENDIF} {$ENDIF};

{*
 * Get UTF-8 text from the primary selection.
 *
 * This functions returns an empty string if there was not enough memory left
 * for a copy of the primary selection's content.
 *
 * \returns the primary selection text on success or an empty string on
 *          failure; call SDL_GetError() for more information. This should be
 *          freed with SDL_free() when it is no longer needed.
 *
 * \threadsafety You may only call this function from the main thread.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_HasPrimarySelectionText
 * \sa SDL_SetPrimarySelectionText
  }
function SDL_GetPrimarySelectionText: PAnsiChar; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetPrimarySelectionText' {$ENDIF} {$ENDIF};

{*
 * Query whether the primary selection exists and contains a non-empty text
 * string.
 *
 * \returns true if the primary selection has text, or false if it does not.
 *
 * \threadsafety You may only call this function from the main thread.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_GetPrimarySelectionText
 * \sa SDL_SetPrimarySelectionText
  }
function SDL_HasPrimarySelectionText: cbool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_HasPrimarySelectionText' {$ENDIF} {$ENDIF};

{*
 * Callback function that will be called when data for the specified mime-type
 * is requested by the OS.
 *
 * The callback function is called with nil as the mime_type when the
 * clipboard is cleared or new data is set. The clipboard is automatically
 * cleared in SDL_Quit().
 *
 * \param userdata a Pointer to provided user data.
 * \param mime_type the requested mime-type.
 * \param size a Pointer filled in with the length of the returned data.
 * \returns a Pointer to the data for the provided mime-type. Returning nil
 *          or setting length to 0 will cause no data to be sent to the
 *          "receiver". It is up to the receiver to handle this. Essentially
 *          returning no data is more or less undefined behavior and may cause
 *          breakage in receiving applications. The returned data will not be
 *          freed so it needs to be retained and dealt with internally.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_SetClipboardData
  }
type
  TSDL_ClipboardDataCallback = function(userdata: Pointer; mime_type: PAnsiChar; size: psize_t): Pointer; cdecl;

{*
 * Callback function that will be called when the clipboard is cleared, or new
 * data is set.
 *
 * \param userdata a Pointer to provided user data.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_SetClipboardData
  }
type
  TSDL_ClipboardCleanupCallback = procedure(userdata: Pointer); cdecl;

{*
 * Offer clipboard data to the OS.
 *
 * Tell the operating system that the application is offering clipboard data
 * for each of the proivded mime-types. Once another application requests the
 * data the callback function will be called allowing it to generate and
 * respond with the data for the requested mime-type.
 *
 * The size of text data does not include any terminator, and the text does
 * not need to be null terminated (e.g. you can directly copy a portion of a
 * document)
 *
 * \param callback a function Pointer to the function that provides the
 *                 clipboard data.
 * \param cleanup a function Pointer to the function that cleans up the
 *                clipboard data.
 * \param userdata an opaque Pointer that will be forwarded to the callbacks.
 * \param mime_types a list of mime-types that are being offered.
 * \param num_mime_types the number of mime-types in the mime_types list.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety You may only call this function from the main thread.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_ClearClipboardData
 * \sa SDL_GetClipboardData
 * \sa SDL_HasClipboardData
  }
function SDL_SetClipboardData(callback: TSDL_ClipboardDataCallback; cleanup: TSDL_ClipboardCleanupCallback; userdata: Pointer; mime_types: PPAnsiChar; num_mime_types: size_t): cbool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetClipboardData' {$ENDIF} {$ENDIF};

{*
 * Clear the clipboard data.
 *
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety You may only call this function from the main thread.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_SetClipboardData
  }
function SDL_ClearClipboardData: cbool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_ClearClipboardData' {$ENDIF} {$ENDIF};

{*
 * Get the data from clipboard for a given mime type.
 *
 * The size of text data does not include the terminator, but the text is
 * guaranteed to be null terminated.
 *
 * \param mime_type the mime type to read from the clipboard.
 * \param size a Pointer filled in with the length of the returned data.
 * \returns the retrieved data buffer or nil on failure; call SDL_GetError()
 *          for more information. This should be freed with SDL_free() when it
 *          is no longer needed.
 *
 * \threadsafety You may only call this function from the main thread.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_HasClipboardData
 * \sa SDL_SetClipboardData
  }
function SDL_GetClipboardData(mime_type: PAnsiChar; size: psize_t): Pointer; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetClipboardData' {$ENDIF} {$ENDIF};

{*
 * Query whether there is data in the clipboard for the provided mime type.
 *
 * \param mime_type the mime type to check for data for.
 * \returns true if there exists data in clipboard for the provided mime type,
 *          false if it does not.
 *
 * \threadsafety You may only call this function from the main thread.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_SetClipboardData
 * \sa SDL_GetClipboardData
  }
function SDL_HasClipboardData(mime_type: PAnsiChar): cbool; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_HasClipboardData' {$ENDIF} {$ENDIF};

{*
 * Retrieve the list of mime types available in the clipboard.
 *
 * \param num_mime_types a Pointer filled with the number of mime types, may
 *                       be nil.
 * \returns a null terminated array of strings with mime types, or nil on
 *          failure; call SDL_GetError() for more information. This should be
 *          freed with SDL_free() when it is no longer needed.
 *
 * \threadsafety You may only call this function from the main thread.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_SetClipboardData
  }
function SDL_GetClipboardMimeTypes(num_mime_types: psize_t):PPAnsiChar; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetClipboardMimeTypes' {$ENDIF} {$ENDIF};

