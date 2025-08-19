# Setup

## Installation

On a Mac with Xcode 16.4 (or higher) installed...

* Download and open the [CodeBase ZIP file](https://github.com/zenopolis/CodeBase/archive/refs/heads/main.zip) from GitHub.
* Rename the folder from `CodeBase-main` to `CodeBase`.
* Place the **CodeBase** folder in your **Developer** folder.
* Open the **CodeBase Project** file to open the project in Xcode.
* If a warning message appears, click **Trust and Open**.

### Signing & Capabilities

In Xcode, you will need to add your bundle identifier and switch on signing.

* Use an identifier in the form `com.example.CodeBase` (replacing _com.example_ with your own reverse-DNS formatted identifier).

Test everything works by building and running.

### Installing Templates

* Close Xcode.
* Using **Finder**, open the directory:
 
`CodeBase/Resources/Templates/File Templates/CodeBase Example Items/`

* Place a **copy** of these `.xctemplate` folders in the following directory (create any missing folders):

`~Library/Developer/Xcode/Templates/File Templates/CodeBase Example Items/`

* Re-open Xcode.
