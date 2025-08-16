# Setup

## Signing & Capabilities

In Xcode:

* Select the CodeBase project file at the top of the Project Navigator.
* Select the CodeBase Target.
* Select the Signing & Capabilities tab.
* Select a _Team_.
* Add a bundle identifier in the form `com.example.CodeBase` (replacing _com.example_ with your own reverse domain name.)

Test everything works by building and running.

## Installing Templates

Place a **copy** of the `.xctemplate` folders found in the `CodeBase/Resources/Templates/File Templates/CodeBase Example Items/` folder in this project into the following Home Directory folder (creating any folders that don't exist):

`~Library/Developer/Xcode/Templates/File Templates/CodeBase Example Items/`

Close and re-open Xcode before use.
