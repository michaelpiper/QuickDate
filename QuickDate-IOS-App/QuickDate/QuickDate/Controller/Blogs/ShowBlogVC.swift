

import UIKit
import WebKit

class ShowBlogVC: BaseViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    var object:Blog?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
        showTabBar()
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func copyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        UIPasteboard.general.string = object?.url
        self.view.makeToast("Copy to clipboard".localized)
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.share(url: object?.url ?? "")
    }
    
    
    private func setupUI() {
        self.headerLabel.text = self.object?.title
        self.titleLabel.text = self.object?.title
        var content = (object?.content ?? "").replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).replacingOccurrences(of: "\n", with: "")
//        content = content.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "<p><br /><br /></p>", with: "").htmlAttributedString ?? ""
        self.contentLabel.text = content
        self.descLabel.text = object?.description
        self.imageView.sd_setImage(with: URL(string: object?.thumbnail ?? ""))
        handleViews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.bottomView.isHidden = false
        }
    }
    
    // !!!: Be careful about webView I added all properties in HTML style
    private func createHTML(with body: String) -> String {
        let width = self.view.frame.width - 20
        return """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
        <meta name="viewport" content="width=\(width), initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
            <style> img { width: \(width)px; object-fit: cover; } </style>
            <style> body {
                    font-size: 16px;
                    background-color: #FFFFFFFF;
                } </style>
        </head>
        <body>
                <h1>\(object?.title ?? "")</h1>
        <div> <img src="\(object?.thumbnail ?? "")"/> </div>
            \(body)
        </body>
        </html>
        """
    }
    
    private func handleViews() {
        guard let object = object else {
            return
        }
        let view = object.view
        self.viewsLabel.text = NSLocalizedString("\(view) Views", comment: "\(view) Views")
    }
    
    private func alertShow(URL: String) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let copyLink = UIAlertAction(title: "Copy Link".localized, style: .default) { (action) in
            UIPasteboard.general.string = URL
            self.view.makeToast("Copy to clipboard".localized)
        }
        let share = UIAlertAction(title: "Share".localized, style: .default) { (action) in
            self.share(url: URL)
        }
        let cancel = UIAlertAction(title: "Cancel".localized, style: .destructive, handler: nil)
        alert.addAction(copyLink)
        alert.addAction(share)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func share(url: String) {
        let myWebsite = NSURL(string:url)
        guard let url = myWebsite else {
            print("nothing found")
            return
        }
        let shareItems:Array = [ url]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func moreButtonPressed(_ sender: UIButton) {
        alertShow(URL: object?.url ?? "")
    }
}
