

import UIKit
import Async
import QuickDateSDK

/// - Tag: BankTransferVC
class BankTransferVC: BaseViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var banktransferLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var receiptImage: UIImageView!
    
    // TODO: Don't forget to turn these before release
    var payInfo: PayingInformation?
    
    var payType:String = ""
    var Description:String = ""
    var amount:Int = 0
    var memberShipType:Int = 0
    var credits:Int = 0
    var paymentType:String = ""
    var isMediaStatus:Bool = false
    var mediaData:Data? = nil
    
    private let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.cancelBtn.isHidden = true
    }
    
    private func setupUI() {
        self.banktransferLabel.text = NSLocalizedString("Bank Transfer", comment: "Bank Transfer")
        self.noteLabel.text = NSLocalizedString("Note", comment: "Note")
        self.selectBtn.setTitle(NSLocalizedString("Select Picture", comment: "Select Picture"), for: .normal)
        self.sendBtn.setTitle(NSLocalizedString("Send", comment: "Send"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        showTabBar()
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.receiptImage.image = nil
        self.mediaData = nil
        self.cancelBtn.isHidden = false
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        if !self.isMediaStatus {
            self.view.makeToast("Please add receipt")
        }else{
            self.uploadReceipt()
        }
    }
    
    @IBAction func selectPictureBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        Logger.verbose("Tapped ")
        let alert = UIAlertController(title: "", message: "Select Source", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func uploadReceipt() {
        self.view.endEditing(true)
        if Connectivity.isConnectedToNetwork() {
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let description = self.Description
            let price = self.amount
            let transferMode = self.payType == "go_pro" ? "membership" : "credits"
            let media = self.mediaData ?? Data()
            Async.background({
                BankTransferManager.instance.sendMedia(AccessToken: accessToken, transferMode: transferMode, price: price, description: description, MediaData: media, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.navigationController?.popViewController(animated: true)
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

extension  BankTransferVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.receiptImage.image = image
        self.mediaData = image.pngData()
        self.isMediaStatus = true
        self.cancelBtn.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
