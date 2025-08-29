![CodeBaseHeader](https://github.com/user-attachments/assets/bfd45fc2-3394-4283-8059-2f6010b35859)

# CodeBase

CodeBase is an environment for Xcode that allows you to gather together your coding notes with live working examples.

* It acts as a single source of truth for your coding experiments and examples, turning your environment into a personal knowledge base.
* It enables you to run, test, and display your examples in a single app, keeping track of what you learn and showcasing your skills.

## Example

![iPad-Example](https://github.com/user-attachments/assets/6ef57698-50b3-4e48-a822-9eb729d6d1e5)

  _Compiled, CodeBase is an organized showcase for your examples._

---

![Xcode-Example](https://github.com/user-attachments/assets/5b66e33c-53ad-4193-8655-8618673a2e9c)

  _In Xcode you use groups or folders to match the compiled version._
  

## Key Features

* **Outline index** to help you organize your notes and code examples. 
* **Code Templates** for **SwiftUI**, Swift **UIKit** and **XIB** based examples.
* **Document Templates** for **Markdown** files and **URLs**.

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

## Adding Your Examples

### Creating Example Items

* Select the **My Examples** folder in the **Project Navigator**.
* Press `Cmd+N` to open the **Template picker**.
* Select the **iOS** tab.
* Scroll down to the **CodeBase Example Files** section.
* Select the type of item you want to add.

### Adding an Item to the Outline

Each example item has its own folder. Within this folder, there will be a file with a name ending with "Deployment". Follow the instructions in this file to add the example to the **Outline Index**. 

You can delete the deployment file when it is no longer needed.

### Creating Sections

You can create sections to organize your code and examples into a hierarchy.

To add a section to the outline, add **Item** code, like this:

```swift
Item(image: "sf.symbol", title: "My Section Title") {
    
    // Other Items in this section go here
    
}
```

...to the `items` property in `OutlineViewController.swift`.

You can mirror these sections in the **My Examples** folder by creating a hierarchy of folders with the same names as your section item titles.

## Author

**CodeBase** was created by [David Kennedy](https://zenopolis.com/contact/).

## License

CodeBase is available under the MIT license. See the LICENSE file for more info.

