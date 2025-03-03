

import UIKit
import Async
import QuickDateSDK

class BlogsVC: BaseViewController {
    
//    @IBOutlet weak var upperPrimaryView: UIView!
    @IBOutlet weak var exploreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var blogsArray = [Blog]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchBlogs()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        handleGradientColors()
    }
    
    private func handleGradientColors() {
//        let startColor = Theme.primaryStartColor.colour
//        let endColor = Theme.primaryEndColor.colour
//        createMainViewGradientLayer(to: upperPrimaryView,
//                                    startColor: startColor,
//                                    endColor: endColor)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    private func setupUI(){
        self.exploreLabel.text = NSLocalizedString("Explore Articles", comment: "Explore Articles")
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(resource: R.nib.blogsTableCell), forCellReuseIdentifier: R.reuseIdentifier.blogsTableCell.identifier)
    }
    private func fetchBlogs(){
        self.showProgressDialog(with: "Loading...")
        if Connectivity.isConnectedToNetwork(){
            
            let accessToken = AppInstance.shared.accessToken ?? ""
            Async.background({
                BlogsManager.instance.getBlogs(AccessToken: accessToken, limit: 20, offset: 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.blogsArray = success?.data ?? []
                                self.tableView.reloadData()
                                
                                
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                self.view.makeToast(sessionError?.message ?? "")
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
                
            })
            
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
    
}

extension BlogsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blogsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.blogsTableCell.identifier) as? BlogsTableCell
        let object = self.blogsArray[indexPath.row]
        cell?.bind(object)
        cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.blogsArray[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)        
        let vc = R.storyboard.blogs.showBlogVC()
        vc?.object = object
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
