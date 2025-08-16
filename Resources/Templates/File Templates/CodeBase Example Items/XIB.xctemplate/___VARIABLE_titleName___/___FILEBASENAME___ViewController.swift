//___FILEHEADER___

import UIKit

class ___FILEBASENAMEASIDENTIFIER___: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Replace our view with XIB view
        let views = Bundle.main.loadNibNamed("___VARIABLE_productName:identifier___View", owner: self, options: nil)
        if let replacementView = views?[0] as? ___VARIABLE_productName:identifier___View {
            self.view = replacementView
        }
    }
    
}
