unit SDL3_net;

{
  This file is part of:

    SDL3 for Pascal
    (https://github.com/PascalGameDevelopment/SDL3-for-Pascal)
    SPDX-License-Identifier: Zlib

}

{$I sdl.inc}

(*
 * # CategorySDLNet
 *
 * SDL_net is a simple library to help with networking.
 *
 * In current times, it's a relatively thin layer over system-level APIs like
 * BSD Sockets or WinSock. Its primary strength is in making those interfaces
 * less complicated to use, and handling several unexpected corner cases, so
 * the app doesn't have to.
 *
 * Some design philosophies of SDL_net:
 *
 * - Nothing is blocking (but you can explicitly wait on things if you want).
 * - Addressing is abstract so you don't have to worry about specific networks
 *   and their specific protocols.
 * - Simple is better than hard, and not necessarily less powerful either.
 *
 * There are several pieces to this library, and most apps won't use them all,
 * but rather choose the portion that's relevant to their needs.
 *
 * All apps will call NET_Init() on startup and NET_Quit() on shutdown.
 *
 * The cornerstone of the library is the NET_Address object. This is what
 * manages the details of how to reach another computer on the network, and
 * what network protocol to use to get there. You'll need a NET_Address to
 * talk over the network. If you need to convert a hostname (such as
 * "google.com" or "libsdl.org") into a NET_Address, you can call
 * NET_ResolveHostname(), which will do the appropriate DNS queries on a
 * background thread. Once these are ready, you can use the NET_Address to
 * connect to these hosts over the Internet.
 *
 * Something that initiates a connection to a remote system is called a
 * "client," connecting to a "server." To establish a connection, use the
 * NET_Address you resolved with NET_CreateClient(). Once the connection is
 * established (a non-blocking operation), you'll have a NET_StreamSocket
 * object that can send and receive data over the connection, using
 * NET_WriteToStreamSocket() and NET_ReadFromStreamSocket().
 *
 * To instead be a server, that clients connect to, call NET_CreateServer() to
 * get a NET_Server object. All a NET_Server does is allow you to accept
 * connections from clients, turning them into NET_StreamSockets, where you
 * can read and write from the opposite side of the connection from a given
 * client.
 *
 * These things are, underneath this API, TCP connections, which means you can
 * use a client or server to talk to something that _isn't_ using SDL_net at
 * all.
 *
 * Clients and servers deal with "stream sockets," a reliable stream of bytes.
 * There are tradeoffs to using these, especially in poor network conditions.
 * Another option is to use "datagram sockets," which map to UDP packet
 * transmission. With datagrams, everyone involved can send small packets of
 * data that may arrive in any order, or not at all, but transmission can
 * carry on if a packet is lost, each packet is clearly separated from every
 * other, and communication can happen in a peer-to-peer model instead of
 * client-server: while datagrams can be more complex, these _are_ useful
 * properties not avaiable to stream sockets. NET_CreateDatagramSocket() is
 * used to prepare for datagram communication, then NET_SendDatagram() and
 * NET_ReceiveDatagram() transmit packets.
 *
 * As previously mentioned, SDL_net's API is "non-blocking" (asynchronous).
 * Any network operation might take time, but SDL_net's APIs will not wait
 * until they complete. Any operation will return immediately, with options to
 * check if the operation has completed later. Generally this is what a video
 * game needs, but there are times where it makes sense to pause until an
 * operation completes; in a background thread this might make sense, as it
 * could simplify the code dramatically.
 *
 * The functions that block until an operation completes:
 *
 * - NET_WaitUntilConnected
 * - NET_WaitUntilInputAvailable
 * - NET_WaitUntilResolved
 * - NET_WaitUntilStreamSocketDrained
 *
 * All of these functions offer a timeout, which allow for a maximum wait
 * time, an immediate non-blocking query, or an infinite wait.
 *
 * Finally, SDL_net offers a way to simulate network problems, to test the
 * always-less-than-ideal conditions in the real world. One can
 * programmatically make the app behave like it's on a flakey wifi connection
 * even if it's running wired directly to a gigabit fiber line. The functions:
 *
 * - NET_SimulateAddressResolutionLoss
 * - NET_SimulateStreamPacketLoss
 * - NET_SimulateDatagramPacketLoss
 *)
interface

uses
  {$IFDEF FPC}
    ctypes,
  {$ENDIF}
  SDL3;

const
{$IFDEF WINDOWS}
  NET_LibName = 'SDL3_net.dll';
{$ENDIF}

{$IFDEF UNIX}
  {$IFDEF DARWIN}
    NET_LibName = 'libSDL3_net.dylib';
    {$IFDEF FPC}
      {$LINKLIB libSDL3_net}
    {$ENDIF}
  {$ELSE}
    {$IFDEF FPC}
      NET_LibName = 'libSDL3_net.so';
    {$ELSE}
      NET_LibName = 'libSDL3_net.so.0';
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF MACOS}
  NET_LibName = 'SDL3_net';
  {$IFDEF FPC}
    {$linklib libSDL3_net}
  {$ENDIF}
{$ENDIF}

{$I ctypes.inc}

const
(*
 * The current major version of the SDL_net headers.
 *
 * If this were SDL_net version 3.2.1, this value would be 3.
 *
 * \since This macro is available since SDL_net 3.0.0.
 *)
  SDL_NET_MAJOR_VERSION = 3;

(*
 * The current minor version of the SDL_net headers.
 *
 * If this were SDL_net version 3.2.1, this value would be 2.
 *
 * \since This macro is available since SDL_net 3.0.0.
 *)
  SDL_NET_MINOR_VERSION = 2;

(*
 * The current micro (or patchlevel) version of the SDL_net headers.
 *
 * If this were SDL_net version 3.2.1, this value would be 1.
 *
 * \since This macro is available since SDL_net 3.0.0.
 *)
  SDL_NET_MICRO_VERSION = 0;

(*
 * This is the version number function for the current SDL_net version.
 *
 * \since This macro is available since SDL_net 3.0.0.
 *
 * \sa NET_Version
 *)
function SDL_NET_VERSION(): Integer;

(*
 * This function will evaluate to true if compiled with SDL_net at least X.Y.Z.
 *
 * \since This macro is available since SDL_net 3.0.0.
 *)
function SDL_NET_VERSION_ATLEAST(major, minor, micro: Integer):Boolean;

(*
 * This function gets the version of the dynamically linked SDL_net library.
 *
 * \returns SDL_net version.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_net 3.0.0.
 *)
function NET_Version(): cint; cdecl;
  external NET_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_NET_Version' {$ENDIF} {$ENDIF};

type
(*
 * A tri-state for asynchronous operations.
 *
 * Lots of tasks in SDL_net are asynchronous, as they can't complete until
 * data passes over a network at some murky future point in time.
 *
 * This includes sending data over a stream socket, resolving a hostname,
 * connecting to a remote system, and other tasks.
 *
 * The library never blocks on tasks that take time to complete, with the
 * exception of functions named "Wait", which are intended to do nothing but
 * block until a task completes. Functions that are attempting to do something
 * that might block, or are querying the status of a task in-progress, will
 * return a NET_Status, so an app can see if a task completed, and its final
 * outcome.
 *
 * \since This enum is available since SDL_net 3.0.0.
 *)
  TNET_Status = type cint;
  PNET_Status = ^TNET_Status;
  PPNET_Status = ^PNET_STATUS;

const
  NET_FAILURE = TNET_Status(-1); (**< Async operation complete, result was failure. *)
  NET_WAITING = TNET_Status( 0); (**< Async operation is still in progress, check again later. *)
  NET_SUCCESS = TNET_Status(+1); (**< Async operation complete, result was success. *)

{ -- init/quit functions... -- }

(*
 * Initialize the SDL_net library.
 *
 * This must be successfully called once before (almost) any other SDL_net
 * function can be used.
 *
 * It is safe to call this multiple times; the library will only initialize
 * once, and won't deinitialize until NET_Quit() has been called a matching
 * number of times. Extra attempts to init report success.
 *
 * \returns true on success, false on error; call SDL_GetError() for details.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_net 3.0.0.
 *
 * \sa NET_Quit
 *)
function NET_Init(): Boolean; cdecl;
  external NET_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_NET_Init' {$ENDIF} {$ENDIF};

(*
 * Deinitialize the SDL_net library.
 *
 * This must be called when done with the library, probably at the end of your
 * program.
 *
 * It is safe to call this multiple times; the library will only deinitialize
 * once, when this function is called the same number of times as NET_Init was
 * successfully called.
 *
 * Once you have successfully deinitialized the library, it is safe to call
 * NET_Init to reinitialize it for further use.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_net 3.0.0.
 *
 * \sa NET_Init
 *)
procedure NET_Quit; cdecl;
  external NET_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_NET_Quit' {$ENDIF} {$ENDIF};

{ -- hostname resolution API -- }

type
(*
 * Opaque representation of a computer-readable network address.
 *
 * This is an opaque datatype, to be treated by the app as a handle.
 *
 * SDL_net uses these to identify other servers; you use them to connect to a
 * remote machine, and you use them to find out who connected to you. They are
 * also used to decide what network interface to use when creating a server.
 *
 * These are intended to be protocol-independent; a given address might be for
 * IPv4, IPv6, or something more esoteric. SDL_net attempts to hide the
 * differences.
 *
 * \since This datatype is available since SDL_net 3.0.0.
 *
 * \sa NET_ResolveHostname
 * \sa NET_GetLocalAddresses
 * \sa NET_CompareAddresses
 *)
  PNET_Address = Type Pointer;
  PPNET_Address = ^PNET_Address;

(*
 * Resolve a human-readable hostname.
 *
 * SDL_net doesn't operate on human-readable hostnames (like `www.libsdl.org`
 * but on computer-readable addresses. This function converts from one to the
 * other. This process is known as "resolving" an address.
 *
 * You can also use this to turn IP address strings (like "159.203.69.7") into
 * NET_Address objects.
 *
 * Note that resolving an address is an asynchronous operation, since the
 * library will need to ask a server on the internet to get the information it
 * needs, and this can take time (and possibly fail later). This function will
 * not block. It either returns NULL (catastrophic failure) or an unresolved
 * NET_Address. Until the address resolves, it can't be used.
 *
 * If you want to block until the resolution is finished, you can call
 * NET_WaitUntilResolved(). Otherwise, you can do a non-blocking check with
 * NET_GetAddressStatus().
 *
 * When you are done with the returned NET_Address, call NET_UnrefAddress() to
 * dispose of it. You need to do this even if resolution later fails
 * asynchronously.
 *
 * \param host The hostname to resolve.
 * \returns A new NET_Address on success, NULL on error; call SDL_GetError()
 *          for details.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_net 3.0.0.
 *
 * \sa NET_WaitUntilResolved
 * \sa NET_GetAddressStatus
 * \sa NET_RefAddress
 * \sa NET_UnrefAddress
 *)
function NET_ResolveHostname(const host: PAnsiChar): PNET_Address; cdecl;
  external NET_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_NET_ResolveHostname' {$ENDIF} {$ENDIF};

(*
 * Block until an address is resolved.
 *
 * The NET_Address objects returned by NET_ResolveHostname take time to do
 * their work, so it does so _asynchronously_ instead of making your program
 * wait an indefinite amount of time.
 *
 * However, if you want your program to sleep until the address resolution is
 * complete, you can call this function.
 *
 * This function takes a timeout value, represented in milliseconds, of how
 * long to wait for resolution to complete. Specifying a timeout of -1
 * instructs the library to wait indefinitely, and a timeout of 0 just checks
 * the current status and returns immediately (and is functionally equivalent
 * to calling NET_GetAddressStatus).
 *
 * Resolution can fail after some time (DNS server took awhile to reply that
 * the hostname isn't recognized, etc), so be sure to check the result of this
 * function instead of assuming it worked!
 *
 * Once an address is successfully resolved, it can be used to connect to the
 * host represented by the address.
 *
 * If you don't want your program to block, you can call NET_GetAddressStatus
 * from time to time until you get a non-zero result.
 *
 * \param address The NET_Address object to wait on.
 * \param timeout Number of milliseconds to wait for resolution to complete.
 *                -1 to wait indefinitely, 0 to check once without waiting.
 * \returns NET_SUCCESS if successfully resolved, NET_FAILURE if resolution
 *          failed, NET_WAITING if still resolving (this function timed out
 *          without resolution); if NET_FAILURE, call SDL_GetError() for
 *          details.
 *
 * \threadsafety It is safe to call this function from any thread, and several
 *               threads can block on the same address simultaneously.
 *
 * \since This function is available since SDL_net 3.0.0.
 *
 * \sa NET_GetAddressStatus
 *)
function NET_WaitUntilResolved(address: PNET_Address; timeout: cint32): TNET_Status; cdecl;
  external NET_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_NET_WaitUntilResolved' {$ENDIF} {$ENDIF};

(*
 * Check if an address is resolved, without blocking.
 *
 * The NET_Address objects returned by NET_ResolveHostname take time to do
 * their work, so it does so _asynchronously_ instead of making your program
 * wait an indefinite amount of time.
 *
 * This function allows you to check the progress of that work without
 * blocking.
 *
 * Resolution can fail after some time (DNS server took awhile to reply that
 * the hostname isn't recognized, etc), so be sure to check the result of this
 * function instead of assuming it worked because it's non-zero!
 *
 * Once an address is successfully resolved, it can be used to connect to the
 * host represented by the address.
 *
 * \param address The NET_Address to query.
 * \returns NET_SUCCESS if successfully resolved, NET_FAILURE if resolution
 *          failed, NET_WAITING if still resolving (this function timed out
 *          without resolution); if NET_FAILURE, call SDL_GetError() for
 *          details.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_net 3.0.0.
 *
 * \sa NET_WaitUntilResolved
 *)
function NET_GetAddressStatus(address: PNET_Address): TNET_Status; cdecl;
  external NET_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_NET_GetAddressStatus' {$ENDIF} {$ENDIF};

(*
 * Get a human-readable string from a resolved address.
 *
 * This returns a string that's "human-readable", in that it's probably a
 * string of numbers and symbols, like "159.203.69.7" or
 * "2604:a880:800:a1::71f:3001". It won't be the original hostname (like
 * "icculus.org"), but it's suitable for writing to a log file, etc.
 *
 * Do not free or modify the returned string; it belongs to the NET_Address
 * that was queried, and is valid as long as the object lives. Either make
 * sure the address has a reference as long as you need this or make a copy of
 * the string.
 *
 * This will return NIL if resolution is still in progress, or if resolution
 * failed. You can use NET_GetAddressStatus() or NET_WaitUntilResolved() to
 * make sure resolution has successfully completed before calling this.
 *
 * \param address The NET_Address to query.
 * \returns a string, or NIL on error; call SDL_GetError() for details.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_net 3.0.0.
 *
 * \sa NET_GetAddressStatus
 * \sa NET_WaitUntilResolved
 *)
function NET_GetAddressString(address: PNET_Address): PAnsiChar; cdecl;
  external NET_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_NET_GetAddressString' {$ENDIF} {$ENDIF};

(*
 * Get the protocol-level bytes of a network address from a resolved address.
 *
 * This data is not human-readable, is protocol-specific, and might not even
 * be in a specific byte order.
 *
 * This is only useful for possibly hashing, to map a address to a specific
 * player in a game, or possibly for handing to a system-level networking API
 * (which is _not_ recommended; an app does this at their own risk).
 *
 * Do not store these bytes for future runs of the program; there is no
 * promise the format won't change.
 *
 * On return `*num_bytes` will hold the number of bytes provided with the
 * address. Since the data is not NULL-terminated, this is the only way to
 * determine its size; as such, this parameter must not be NULL.
 *
 * Do not free or modify the returned data; it belongs to the NET_Address that
 * was queried, and is valid as long as the object lives. Either make sure the
 * address has a reference as long as you need this or make a copy of the
 * bytes.
 *
 * This will return NULL if resolution is still in progress, or if resolution
 * failed. You can use NET_GetAddressStatus() or NET_WaitUntilResolved() to
 * make sure resolution has successfully completed before calling this.
 *
 * A human-readable version is available in NET_GetAddressString() and isn't
 * any less efficient to query than the raw bytes.
 *
 * \param address The NET_Address to query.
 * \param num_bytes on return, will be set to the number of bytes returned.
 * \returns a pointer to bytes, or NULL on error; call SDL_GetError() for
 *          details.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_net 3.0.0.
 *
 * \sa NET_GetAddressString
 * \sa NET_GetAddressStatus
 * \sa NET_WaitUntilResolved
 *)
function NET_GetAddressBytes(address: PNET_Address; num_bytes: pcint): Pointer; cdecl;
  external NET_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_NET_GetAddressBytes' {$ENDIF} {$ENDIF};

(*
 * Add a reference to an NET_Address.
 *
 * Since several pieces of the library might share a single NET_Address,
 * including a background thread that's working on resolving, these objects
 * are referenced counted. This allows everything that's using it to declare
 * they still want it, and drop their reference to the address when they are
 * done with it. The object's resources are freed when the last reference is
 * dropped.
 *
 * This function adds a reference to an NET_Address, increasing its reference
 * count by one.
 *
 * The documentation will tell you when the app has to explicitly unref an
 * address. For example, NET_ResolveHostname() creates addresses that are
 * already referenced, so the caller needs to unref it when done.
 *
 * Generally you only have to explicit ref an address when you have different
 * parts of your own app that will be sharing an address. In normal usage, you
 * only have to unref things you've created once (like you might free()
 * something), but you are free to add extra refs if it makes sense.
 *
 * This returns the same address passed as a parameter, which makes it easy to
 * ref and assign in one step:
 *
 * ```c
 * myAddr = NET_RefAddress(yourAddr);
 * ```
 *
 * \param address The NET_Address to add a reference to.
 * \returns the same address that was passed as a parameter.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_net 3.0.0.
 *)
function NET_RefAddress(address: PNET_Address): PNET_Address; cdecl;
  external NET_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_NET_RefAddress' {$ENDIF} {$ENDIF};

(**
 * Drop a reference to an NET_Address.
 *
 * Since several pieces of the library might share a single NET_Address,
 * including a background thread that's working on resolving, these objects
 * are referenced counted. This allows everything that's using it to declare
 * they still want it, and drop their reference to the address when they are
 * done with it. The object's resources are freed when the last reference is
 * dropped.
 *
 * This function drops a reference to an NET_Address, decreasing its reference
 * count by one.
 *
 * The documentation will tell you when the app has to explicitly unref an
 * address. For example, NET_ResolveHostname() creates addresses that are
 * already referenced, so the caller needs to unref it when done.
 *
 * \param address The NET_Address to drop a reference to.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_net 3.0.0.
 *)
procedure NET_UnrefAddress(address: PNET_Address); cdecl;
  external NET_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_NET_UnrefAddress' {$ENDIF} {$ENDIF};

(*
 * Enable simulated address resolution failures.
 *
 * Often times, testing a networked app on your development machine--which
 * might have a wired connection to a fast, reliable network service--won't
 * expose bugs that happen when networks intermittently fail in the real
 * world, when the wifi is flakey and firewalls get in the way.
 *
 * This function allows you to tell the library to pretend that some
 * percentage of address resolutions will fail.
 *
 * The higher the percentage, the more resolutions will fail and/or take
 * longer for resolution to complete.
 *
 * Setting this to zero (the default) will disable the simulation. Setting to
 * 100 means _everything_ fails unconditionally. At what percent the system
 * merely borders on unusable is left as an exercise to the app developer.
 *
 * This is intended for debugging purposes, to simulate real-world conditions
 * that are various degrees of terrible. You probably should _not_ call this
 * in production code, where you'll likely see real failures anyhow.
 *
 * \param percent_loss A number between 0 and 100. Higher means more failures.
 *                     Zero to disable.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_net 3.0.0.
 *)
procedure NET_SimulateAddressResolutionLoss(percent_loss: cint); cdecl;
  external NET_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_NET_SimulateAddressResolutionLoss' {$ENDIF} {$ENDIF};

(*
 * Compare two NET_Address objects.
 *
 * This compares two addresses, returning a value that is useful for qsort (or
 * SDL_qsort).
 *
 * \param a first address to compare.
 * \param b second address to compare.
 * \returns a value less than zero if `a` is "less than" `b`, a value greater
 *          than zero if "greater than", zero if equal.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_net 3.0.0.
 *)
function NET_CompareAddresses(const a, b: PNET_Address): cint; cdecl;
  external NET_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_NET_CompareAddresses' {$ENDIF} {$ENDIF};

(*
 * Obtain a list of local addresses on the system.
 *
 * This returns addresses that you can theoretically bind a socket to, to
 * accept connections from other machines at that address.
 *
 * You almost never need this function; first, it's hard to tell _what_ is a
 * good address to bind to, without asking the user (who will likely find it
 * equally hard to decide). Second, most machines will have lots of _private_
 * addresses that are accessible on the same LAN, but not public ones that are
 * accessible from the outside Internet.
 *
 * Usually it's better to use NET_CreateServer() or NET_CreateDatagramSocket()
 * with a NULL address, to say "bind to all interfaces."
 *
 * The array of addresses returned from this is guaranteed to be
 * NULL-terminated. You can also pass a pointer to an int, which will return
 * the final count, not counting the NULL at the end of the array.
 *
 * Pass the returned array to NET_FreeLocalAddresses when you are done with
 * it. It is safe to keep any addresses you want from this array even after
 * calling that function, as long as you called NET_RefAddress() on them.
 *
 * \param num_addresses on exit, will be set to the number of addresses
 *                      returned. Can be NULL.
 * \returns A NULL-terminated array of NET_Address pointers, one for each
 *          bindable address on the system, or NULL on error; call
 *          SDL_GetError() for details.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_net 3.0.0.
 *)
function NET_GetLocalAddresses(num_addresses: pcint): PPNET_Address; cdecl;
  external NET_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_NET_GetLocalAddresses' {$ENDIF} {$ENDIF};

(*
 * Free the results from NET_GetLocalAddresses.
 *
 * This will unref all addresses in the array and free the array itself.
 *
 * Since addresses are reference counted, it is safe to keep any addresses you
 * want from this array even after calling this function, as long as you
 * called NET_RefAddress() on them first.
 *
 * It is safe to pass a NULL in here, it will be ignored.
 *
 * \param addresses A pointer returned by NET_GetLocalAddresses().
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_net 3.0.0.
 *)
procedure NET_FreeLocalAddresses(addresses: PPNET_Address); cdecl;
  external NET_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_NET_FreeLocalAddresses' {$ENDIF} {$ENDIF};


implementation


function SDL_NET_VERSION(): Integer;
begin
  Result := SDL_VERSIONNUM(SDL_NET_MAJOR_VERSION, SDL_NET_MINOR_VERSION, SDL_NET_MICRO_VERSION)
end;

function SDL_NET_VERSION_ATLEAST(major, minor, micro: Integer): Boolean;
begin
  Result := (SDL_NET_MAJOR_VERSION >= major) and
    ((SDL_NET_MAJOR_VERSION > major) or (SDL_NET_MINOR_VERSION >= minor)) and
    ((SDL_NET_MAJOR_VERSION > major) or (SDL_NET_MINOR_VERSION > minor) or (SDL_NET_MICRO_VERSION >= micro))
end;


end.
