
import UIKit
import Alamofire
import CRRefresh

class NewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var postId = ""
    private var pointer = 0
    private var posts = [Post]()
    private var postTableView: UITableView!
    private let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        postTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        postTableView.backgroundColor = .clear
        postTableView.showsVerticalScrollIndicator = false
        postTableView.separatorStyle  = UITableViewCell.SeparatorStyle.none
        postTableView.register(UINib(nibName: "PostCell", bundle: Bundle.main), forCellReuseIdentifier: "PostCell")
        
        postTableView.dataSource = self
        postTableView.delegate = self
        self.view.addSubview(postTableView)
        
        postTableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self!.refreshData()
        }
        
        refreshData()
    }
    
    func refreshData() {
        pointer = 0
        posts.removeAll()
        
        self.loadingIndicator.center = self.view.center
        self.loadingIndicator.hidesWhenStopped = true
        self.loadingIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(self.loadingIndicator)
        self.loadingIndicator.startAnimating()
        
        let parameters : Parameters = [
            "start" : 0,
            "limit" : 3
        ]
        
        Alamofire.request(ADDR.POSTS, method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON { response in
            self.loadingIndicator.stopAnimating()
            
            if let json = response.result.value {
                let jsonData = json as! [String : Any]
                                
                let message = jsonData["message"] as! String
                
                if message == "success" {
                    let temp = jsonData["data"] as! [String : Any]
                    let listJson = temp["list"] as! NSArray

                    print(listJson)
                    
                    for postJson in listJson {
                        let postData = postJson as! [String : Any]
                        let id = postData["_id"] as! String
                        let title = postData["title"] as! String
                        let author = postData["author"] as! String
                        let description = postData["description"] as! String
                        let dateAdded = postData["dateAdded"] as! String
                        let viewCount = postData["viewCount"] as! Int

                        let post = Post()
                        post.id = id
                        post.title = title
                        post.author = author
                        post.description = description
                        post.dateAdded = dateAdded
                        post.viewCount = viewCount
                        self.posts.append(post)
                    }
                    
                    self.pointer = self.pointer + CONST.PAGE_LIMIT
                    
                    DispatchQueue.main.async {
                        self.loadingIndicator.stopAnimating()
                        self.postTableView.reloadData()
                        self.postTableView.cr.endHeaderRefresh()
                    }
                }
            }
        }
    }
    
    func loadData() {
        let parameters:[String: Int] = [
            "start":pointer + 1,
            "limit":CONST.PAGE_LIMIT
        ]
        
        Alamofire.request(ADDR.POSTS, method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON { response in
            if let json = response.result.value {
                let jsonData = json as! [String : Any]
                
                let message = jsonData["message"] as! String
                
                if message == "success" {
                    var newPosts = [Post]()

                    let temp = jsonData["data"] as! [String : Any]
                    let listJson = temp["list"] as! NSArray
                    
                    for postJson in listJson {
                        let postData = postJson as! [String : Any]
                        let id = postData["_id"] as! String
                        let title = postData["title"] as! String
                        let author = postData["author"] as! String
                        let description = postData["description"] as! String
                        let dateAdded = postData["dateAdded"] as! String
                        let viewCount = postData["viewCount"] as! Int
                        
                        let post = Post()
                        post.id = id
                        post.title = title
                        post.author = author
                        post.description = description
                        post.dateAdded = dateAdded
                        post.viewCount = viewCount
                        self.posts.append(post)
                        newPosts.append(post)
                    }
                    
                    DispatchQueue.main.async {
                        //self.pointerself.postTableView.beginUpdates()
            

                        for (index, post) in self.posts.enumerated() {
                            let row = self.pointer + index
                            
                            print(index)
                            
                            //self.postTableView.insertRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
                        }
                        
                        //self.postTableView.endUpdates()
                        
                        self.pointer = self.pointer + CONST.PAGE_LIMIT
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postId = self.posts[indexPath.row].id
        performSegue(withIdentifier: "segue_post", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        postTableViewCell.backgroundColor = .clear
        postTableViewCell.selectionStyle = .none
        postTableViewCell.titleLabel.text = posts[indexPath.row].title
        
        let description = posts[indexPath.row].description.prefix(80)
        postTableViewCell.descriptionLabel.text = String(description)

        return postTableViewCell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            loadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_post" {
            if let postViewController = segue.destination as? PostViewController {
                postViewController.postId = postId
            }
        }
    }
}
