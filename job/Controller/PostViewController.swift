
import UIKit
import Alamofire

class PostViewController: UIViewController {

    var postId = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var despLabel: UILabel!
    
    private let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    func loadData() {
        self.loadingIndicator.center = self.view.center
        self.loadingIndicator.hidesWhenStopped = true
        self.loadingIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(self.loadingIndicator)
        self.loadingIndicator.startAnimating()
        
        Alamofire.request(ADDR.POST) .responseJSON { response in
            self.loadingIndicator.stopAnimating()
            
            if let json = response.result.value {
                let jsonData = json as! [String : Any]
                
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                }
            }
        }
    }
}
