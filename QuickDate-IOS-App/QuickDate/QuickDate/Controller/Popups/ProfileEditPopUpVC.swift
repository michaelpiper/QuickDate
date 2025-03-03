
import UIKit

protocol DidSetProfilesParamDelegate {
    func setProfileParam(status: Bool, selectedString: String, index: String, type: ProfileEditType)
}

/// - Tag: ProfileEditPopUpVC
class ProfileEditPopUpVC: UIViewController {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    // MARK: - Properties
    private let appInstance: AppInstance = .shared
    
    var editType: ProfileEditType = .language    
    var language:GetSettingsModel.DataClass?
    var loadingArray: [PropertiesModel] = []
    var delegate: DidSetProfilesParamDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        self.tableView.separatorStyle = .none
        self.typeLabel.text = editType.rawValue.capitalized
        self.loadingArray = editType.propertiesArray
        let height = CGFloat(self.loadingArray.count * 44)
        if height > ((self.view.frame.height*0.5)+120) {
            self.tableViewHeight.constant = self.view.frame.height*0.5
        }else {
            self.tableViewHeight.constant = height
        }
        self.updateViewConstraints()
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension  ProfileEditPopUpVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.loadingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.selectionStyle = .none
        cell?.textLabel?.text = self.loadingArray[indexPath.row].value.htmlAttributedString ?? ""
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) { [self] in
            self.delegate?.setProfileParam(
                status: true,
                selectedString: loadingArray[indexPath.row].value.htmlAttributedString ?? "",
                index: loadingArray[indexPath.row].id,
                type: editType)
        }
    }
}
