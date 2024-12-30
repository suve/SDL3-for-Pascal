
{$I jedi.inc} // provides many useful compiler defines to distinguish
              // between compilers, environments, architectures, ...
              // Important: Sets Delphi mode for FPC!

{ Compiler settings }
{$H+}              // strings are ansistrings (Delphi mode)
{$PACKRECORDS C}   // C compatible record alignment

{ Compiler defines }
{$DEFINE SDL} // define "SDL" symbol
