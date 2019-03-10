
import UIKit

class LoginView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var usernameTextField: BottomBorderTextField!
    @IBOutlet weak var passwordTextField: BottomBorderTextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configView()
    }
    
    private func configView() {
        Bundle.main.loadNibNamed("LoginView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let borderColor = UIColor(red: 207 / 255, green: 207 / 255, blue: 207 / 255, alpha: 1.0)

        usernameTextField.setBottomBorder(borderColor: borderColor, width: 1.2)
        passwordTextField.setBottomBorder(borderColor: borderColor, width: 1.2)
    }
}

