
import UIKit
import Toaster
import Alamofire

class LoginView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var loginButton: LoadingButton!
    @IBOutlet weak var nameTextField: BottomBorderTextField!
    @IBOutlet var emailTextField: BottomBorderTextField!
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

        emailTextField.setBottomBorder(borderColor: borderColor, width: 1.2)
        passwordTextField.setBottomBorder(borderColor: borderColor, width: 1.2)
    }
    
    @IBAction func submitLogin(_ sender: Any) {
        self.endEditing(true)
        
        let email = self.emailTextField.text!
        let password = self.passwordTextField.text!
        
        self.loginButton.showLoading()
            
        self.emailTextField.isUserInteractionEnabled = false
        self.passwordTextField.isUserInteractionEnabled = false
          
        let parameters:[String: String] = [
            "email": email,
            "password": password
        ]
                
        Alamofire.request(ADDR.LOGIN, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            self.loginButton.hideLoading()

            self.emailTextField.isUserInteractionEnabled = true
            self.passwordTextField.isUserInteractionEnabled = true
                        
            if let json = response.result.value {
                let jsonData = json as! [String : Any]
                
                print(jsonData)
            }
        }
    }
}

