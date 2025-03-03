

import UIKit
import Async
import GoogleMobileAds
import QuickDateSDK

class EditFavouritesVC: BaseViewController {
    
    @IBOutlet weak var dishTextField: UITextField!
    @IBOutlet weak var tvShowTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var movieTextField: UITextField!
    @IBOutlet weak var bookTextField: UITextField!
    @IBOutlet weak var sportTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var hobbyTextField: UITextField!
    @IBOutlet weak var songTextField: UITextField!
    @IBOutlet weak var musicTextField: UITextField!
    
    @IBOutlet weak var dishTextView: UIView!
    @IBOutlet weak var tvShowTextView: UIView!
    @IBOutlet weak var colorTextView: UIView!
    @IBOutlet weak var movieTextView: UIView!
    @IBOutlet weak var bookTextView: UIView!
    @IBOutlet weak var sportTextView: UIView!
    @IBOutlet weak var cityTextView: UIView!
    @IBOutlet weak var hobbyTextView: UIView!
    @IBOutlet weak var songTextView: UIView!
    @IBOutlet weak var musicTextView: UIView!
    
    
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        updateFavourites()
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    private func setupUI(){
        if ControlSettings.shouldShowAddMobBanner{
            
            bannerView = GADBannerView(adSize: GADAdSizeBanner)
            addBannerViewToView(bannerView)
            bannerView.adUnitID = ControlSettings.addUnitId
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            
        }
        
        self.musicTextField.placeholder = NSLocalizedString("Music", comment: "Music")
        self.dishTextField.placeholder = NSLocalizedString("Dish", comment: "Dish")
        self.songTextField.placeholder = NSLocalizedString("Song", comment: "Song")
        self.hobbyTextField.placeholder = NSLocalizedString("Hobby", comment: "Hobby")
        self.cityTextField.placeholder = NSLocalizedString("City", comment: "City")
        self.sportTextField.placeholder = NSLocalizedString("Sport", comment: "Sport")
        self.bookTextField.placeholder = NSLocalizedString("Book", comment: "Book")
        self.movieTextField.placeholder = NSLocalizedString("Movie", comment: "Movie")
        self.colorTextField.placeholder = NSLocalizedString("Color", comment: "Color")
        self.tvShowTextField.placeholder = NSLocalizedString("Tv Show", comment: "Tv Show")
        
        let appInstance: AppInstance = .shared
        let userSettings = appInstance.userProfileSettings
        self.musicTextField.text = userSettings?.favourites.music
        self.dishTextField.text = userSettings?.favourites.dish
        self.songTextField.text = userSettings?.favourites.song
        self.hobbyTextField.text = userSettings?.favourites.hobby
        self.cityTextField.text = userSettings?.favourites.city
        self.sportTextField.text  = userSettings?.favourites.sport
        self.bookTextField.text = userSettings?.favourites.book
        self.movieTextField.text = userSettings?.favourites.movie
        self.colorTextField.text = userSettings?.favourites.colour
        self.tvShowTextField.text = userSettings?.favourites.tvChoice
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    private func updateFavourites(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let music  = self.musicTextField.text ?? ""
            let dish = self.dishTextField.text ?? ""
            let song = self.songTextField.text ?? ""
            let hobby = self.hobbyTextField.text ?? ""
            let city = self.cityTextField.text ?? ""
            let sport = self.sportTextField.text ?? ""
            let book = self.bookTextField.text ?? ""
            let movie = self.movieTextField.text ?? ""
            let color = self.colorTextField.text ?? ""
            let tvShow = self.tvShowTextField.text ?? ""
            
            let params = [
                API.PARAMS.access_token: accessToken,
                API.PARAMS.music: music,
                API.PARAMS.dish: dish,
                API.PARAMS.song: song,
                API.PARAMS.hobby: hobby,
                API.PARAMS.city: city,
                API.PARAMS.sport: sport,
                API.PARAMS.book: book,
                API.PARAMS.movie: movie,
                API.PARAMS.colour: color,
                API.PARAMS.tv: tvShow,
            ] as [String : Any]
            
            Async.background({
                ProfileManger.instance.editProfile(params: params) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.data ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                let appManager: AppManager = .shared
                                appManager.fetchUserProfile()
                                Logger.debug("FetchUserProfile Fetched)")
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
                }
            })
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
}

extension EditFavouritesVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dishTextField {
            dishTextView.borderColorV = .PrimaryColor
        }
        if textField == tvShowTextField {
            tvShowTextView.borderColorV = .PrimaryColor
        }
        if textField == colorTextField {
            colorTextView.borderColorV = .PrimaryColor
        }
        if textField == movieTextField {
            movieTextView.borderColorV = .PrimaryColor
        }
        if textField == bookTextField {
            bookTextView.borderColorV = .PrimaryColor
        }
        if textField == sportTextField {
            sportTextView.borderColorV = .PrimaryColor
        }
        if textField == cityTextField {
            cityTextView.borderColorV = .PrimaryColor
        }
        if textField == hobbyTextField {
            hobbyTextView.borderColorV = .PrimaryColor
        }
        if textField == songTextField {
            songTextView.borderColorV = .PrimaryColor
        }
        if textField == musicTextField {
            musicTextView.borderColorV = .PrimaryColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == dishTextField {
            dishTextView.borderColorV = .clear
        }
        if textField == tvShowTextField {
            tvShowTextView.borderColorV = .clear
        }
        if textField == colorTextField {
            colorTextView.borderColorV = .clear
        }
        if textField == movieTextField {
            movieTextView.borderColorV = .clear
        }
        if textField == bookTextField {
            bookTextView.borderColorV = .clear
        }
        if textField == sportTextField {
            sportTextView.borderColorV = .clear
        }
        if textField == cityTextField {
            cityTextView.borderColorV = .clear
        }
        if textField == hobbyTextField {
            hobbyTextView.borderColorV = .clear
        }
        if textField == songTextField {
            songTextView.borderColorV = .clear
        }
        if textField == musicTextField {
            musicTextView.borderColorV = .clear
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
