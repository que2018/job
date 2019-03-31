
import Foundation

struct ADDR  {
    static let API = "http://job-api-server.herokuapp.com/admin/"
    
    static let POSTS = API + "post/get_posts"
    static let CATEGORIES = API + "category/getCategorys"
    static let POST = API + "post/get_post"
    static let LOGIN = API + "customer/login"
}
