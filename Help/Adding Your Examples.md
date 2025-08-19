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
