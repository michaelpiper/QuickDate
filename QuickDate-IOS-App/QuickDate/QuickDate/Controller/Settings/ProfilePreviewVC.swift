//
//  ProfilePreviewVC.swift
//  QuickDate
//
//  Created by iMac on 27/07/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK

class ProfilePreviewVC: BaseViewController {
    
    @IBOutlet weak var cross6Btn: UIButton!
    @IBOutlet weak var cross5Btn: UIButton!
    @IBOutlet weak var cross4Btn: UIButton!
    @IBOutlet weak var cross3Btn: UIButton!
    @IBOutlet weak var cross2Btn: UIButton!
    @IBOutlet weak var cross1Btn: UIButton!
    
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var imageView3: UIImageView!
    @IBOutlet var imageView4: UIImageView!
    @IBOutlet var imageView5: UIImageView!
    @IBOutlet var imageView6: UIImageView!
    
    @IBOutlet weak var profleCompleted: UILabel!
    @IBOutlet var percentLabel: UILabel!
    @IBOutlet var percentProgressView: UIProgressView!
    
    @IBOutlet weak var aboutMeLabel: UILabel!
    
    @IBOutlet weak var workStatus: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var relationshipStatus: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet var interestsLabel: UILabel!
    
    @IBOutlet weak var bodyTypeLabel: UILabel!
    @IBOutlet weak var hairColor: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var ethenicityLabel: UILabel!
    
    @IBOutlet var characterLabel: UILabel!
    @IBOutlet var chidrenLabel: UILabel!
    @IBOutlet var friendsLabel: UILabel!
    @IBOutlet var petLabel: UILabel!
    
    @IBOutlet var iLiveWithLabel: UILabel!
    @IBOutlet var carLabel: UILabel!
    @IBOutlet var religionLabel: UILabel!
    @IBOutlet var smokeLabel: UILabel!
    @IBOutlet var drinkLabel: UILabel!
    @IBOutlet var travelLabel: UILabel!
    
    @IBOutlet var musicGenreLabel: UILabel!
    @IBOutlet var dishLabel: UILabel!
    @IBOutlet var songLabel: UILabel!
    @IBOutlet var hobbyLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var sportLabel: UILabel!
    @IBOutlet var bookLabel: UILabel!
    @IBOutlet var movieLabel: UILabel!
    @IBOutlet var colorLabel: UILabel!
    @IBOutlet var tvShowLabel: UILabel!
    
    @IBOutlet var profileCompletionView: UIView!
    @IBOutlet var aboutMeView: UIView!
    @IBOutlet var profileInfoView: UIView!
    @IBOutlet var interestsView: UIView!
    @IBOutlet var looksView: UIView!
    @IBOutlet var personalityView: UIView!
    @IBOutlet var lifeStyleView: UIView!
    @IBOutlet var favouriteView: UIView!

    
    // MARK: - Property Injections -
    /// Images Setup
    private let imagePickerController = UIImagePickerController()
    private var imageCount:Int = 1
    private var mediaFiles: [MediaFile] = []
    private let appManager: AppManager = .shared
    private let appInstance: AppInstance = .shared
    private var userSettings = AppInstance.shared.userProfileSettings
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addShadowView()
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
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: - Selectors -
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            let aboutVC = R.storyboard.popUps.aboutMePopUpVC()
//            aboutVC?.delegate = self
            self.present(aboutVC!, animated: true, completion: nil)
        case 2:
            let nextVC = R.storyboard.settings.editProfileInfoVC()
            self.navigationController?.pushViewController(nextVC!, animated: true)
        case 3:
            let interestVC = R.storyboard.popUps.interestPopUpVC()
//             interestVC?.delegate = self
            self.present(interestVC!, animated: true, completion: nil)
        case 4:
            let nextVC = R.storyboard.settings.editLooksVC()
            self.navigationController?.pushViewController(nextVC!, animated: true)
        case 5:
            let nextVC = R.storyboard.settings.editPersonalityVC()
            self.navigationController?.pushViewController(nextVC!, animated: true)
        case 6:
            let nextVC = R.storyboard.settings.editLifeStyleVC()
            self.navigationController?.pushViewController(nextVC!, animated: true)
        case 7:
            let nextVC = R.storyboard.settings.editFavouritesVC()
            self.navigationController?.pushViewController(nextVC!, animated: true)
        default:
            break
        }
    }
    
    @IBAction func imageViewTapped(_ sender: UIButton) {
        imageCount = sender.tag
        Logger.verbose("Tapped \(imageCount)")
        let vc = R.storyboard.popUps.imagePickerPopupVC()
        vc?.delegate = self
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true)
    }
    
    @IBAction func deleteImagePressed(_ sender: UIButton) {
        if sender.tag == 0 {
            if mediaFiles.count == 1 {
                self.deleteMedia(Id: mediaFiles[0].id )
                appInstance.userProfileSettings?.mediafiles.remove(at: 0)
                imageView1.image = R.image.thumbnail()
            }
        }else if sender.tag == 1 {
            if mediaFiles.count == 2 {
                self.deleteMedia(Id: mediaFiles[1].id )
                appInstance.userProfileSettings?.mediafiles.remove(at: 1)
                imageView2.image = R.image.thumbnail()
            }
        }else if sender.tag == 2 {
            if mediaFiles.count == 3 {
                self.deleteMedia(Id: mediaFiles[2].id )
                appInstance.userProfileSettings?.mediafiles.remove(at: 2)
                imageView3.image = R.image.thumbnail()
            }
        }else if sender.tag == 3 {
            if mediaFiles.count == 4 {
                self.deleteMedia(Id: mediaFiles[3].id )
                appInstance.userProfileSettings?.mediafiles.remove(at: 3)
                imageView4.image = R.image.thumbnail()
            }
        }else if sender.tag == 4 {
            if mediaFiles.count == 5 {
                self.deleteMedia(Id: mediaFiles[4].id )
                appInstance.userProfileSettings?.mediafiles.remove(at: 4)
                imageView5.image = R.image.thumbnail()
            }
        }else if sender.tag == 5 {
            if mediaFiles.count == 6 {
                self.deleteMedia(Id: mediaFiles[5].id )
                appInstance.userProfileSettings?.mediafiles.remove(at: 5)
                imageView6.image = R.image.thumbnail()
            }
        }
    }
}

extension ProfilePreviewVC {
    func setupUI() {
        self.setupImageViews()
        self.setupProfileCompletion()
        self.setupAboutMe()
        self.setupProfileInfo()
        self.setupInterest()
        self.setupLooks()
        self.setupPersonality()
        self.setupLifeStyles()
        self.setupFavourite()
    }
    
    func addShadowView() {
        self.profileCompletionView.addShadow()
        self.aboutMeView.addShadow()
        self.profileInfoView.addShadow()
        self.interestsView.addShadow()
        self.looksView.addShadow()
        self.personalityView.addShadow()
        self.lifeStyleView.addShadow()
        self.favouriteView.addShadow()
        self.onUpdateProfileData()
    }
    
    private func onUpdateProfileData() {
        AppManager.shared.onUpdateProfile = { () in
            Async.main {
                self.userSettings = AppInstance.shared.userProfileSettings
                self.mediaFiles = self.userSettings?.mediafiles ?? []
                self.setupUI()
            }
        }
    }
    
    func setupImageViews() {
        mediaFiles = getMediaFiles()
        if mediaFiles.count == 0 {
            self.imageView1.image = R.image.thumbnail()
            self.imageView2.image = R.image.thumbnail()
            self.imageView3.image = R.image.thumbnail()
            self.imageView4.image = R.image.thumbnail()
            self.imageView5.image = R.image.thumbnail()
            self.imageView6.image = R.image.thumbnail()
        }else {
            // FIXME: Re-write these codes below to provide clean code
            if mediaFiles.count == 1 {
                let url1 = URL(string: mediaFiles[0].avatar)
                self.imageView1.sd_setImage(with: url1, placeholderImage: R.image.thumbnail())
            }else if mediaFiles.count == 2 {
                let url1 = URL(string: mediaFiles[0].avatar)
                let url2 = URL(string: mediaFiles[1].avatar)
                self.imageView1.sd_setImage(with: url1, placeholderImage: R.image.thumbnail())
                self.imageView2.sd_setImage(with: url2, placeholderImage: R.image.thumbnail())
            }else if mediaFiles.count == 3 {
                let url1 = URL(string: mediaFiles[0].avatar)
                let url2 = URL(string: mediaFiles[1].avatar)
                let url3 = URL(string: mediaFiles[2].avatar)
                self.imageView1.sd_setImage(with: url1, placeholderImage: R.image.thumbnail())
                self.imageView2.sd_setImage(with: url2, placeholderImage: R.image.thumbnail())
                self.imageView3.sd_setImage(with: url3, placeholderImage: R.image.thumbnail())
            }else if mediaFiles.count == 4 {
                let url1 = URL(string: mediaFiles[0].avatar)
                let url2 = URL(string: mediaFiles[1].avatar)
                let url3 = URL(string: mediaFiles[2].avatar)
                let url4 = URL(string: mediaFiles[3].avatar)
                self.imageView1.sd_setImage(with: url1, placeholderImage: R.image.thumbnail())
                self.imageView2.sd_setImage(with: url2, placeholderImage: R.image.thumbnail())
                self.imageView3.sd_setImage(with: url3, placeholderImage: R.image.thumbnail())
                self.imageView4.sd_setImage(with: url4, placeholderImage: R.image.thumbnail())
            }else if mediaFiles.count == 5 {
                let url1 = URL(string: mediaFiles[0].avatar)
                let url2 = URL(string: mediaFiles[1].avatar)
                let url3 = URL(string: mediaFiles[2].avatar)
                let url4 = URL(string: mediaFiles[3].avatar)
                let url5 = URL(string: mediaFiles[4].avatar)                
                self.imageView1.sd_setImage(with: url1, placeholderImage: R.image.thumbnail())
                self.imageView2.sd_setImage(with: url2, placeholderImage: R.image.thumbnail())
                self.imageView3.sd_setImage(with: url3, placeholderImage: R.image.thumbnail())
                self.imageView4.sd_setImage(with: url4, placeholderImage: R.image.thumbnail())
                self.imageView5.sd_setImage(with: url5, placeholderImage: R.image.thumbnail())
            }else if mediaFiles.count == 6 {
                let url1 = URL(string: mediaFiles[0].avatar)
                let url2 = URL(string: mediaFiles[1].avatar)
                let url3 = URL(string: mediaFiles[2].avatar)
                let url4 = URL(string: mediaFiles[3].avatar)
                let url5 = URL(string: mediaFiles[4].avatar)
                let url6 = URL(string: mediaFiles[5].avatar)
                self.imageView1.sd_setImage(with: url1, placeholderImage: R.image.thumbnail())
                self.imageView2.sd_setImage(with: url2, placeholderImage: R.image.thumbnail())
                self.imageView3.sd_setImage(with: url3, placeholderImage: R.image.thumbnail())
                self.imageView4.sd_setImage(with: url4, placeholderImage: R.image.thumbnail())
                self.imageView5.sd_setImage(with: url5, placeholderImage: R.image.thumbnail())
                self.imageView6.sd_setImage(with: url6, placeholderImage: R.image.thumbnail())
            }
        }
    }
    
    func setupProfileCompletion() {
        _ = Double(userSettings?.profile_completion ?? 0)
        self.percentProgressView.progress = Float(userSettings?.profile_completion ?? 0)/100.0
        self.percentLabel.text = "\(userSettings?.profile_completion ?? 0)%"
    }
    
    func setupAboutMe() {
        if userSettings?.about == "" {
            self.aboutMeLabel.text = "------"
        } else {
            self.aboutMeLabel.text = userSettings?.about
        }
    }
    
    func setupProfileInfo() {
        if userSettings?.full_name == "" {
            self.nameLabel.text = "-----"
        }else{
            self.nameLabel.text = userSettings?.full_name
        }
        
        if userSettings?.gender_txt == "" {
            self.genderLabel.text = "-----"
        }else {
            self.genderLabel.text = userSettings?.gender_txt
        }
        
        if  userSettings?.birthday == "" {
            self.birthdayLabel.text = "-----"
        }else{
            self.birthdayLabel.text  = userSettings?.birthday
        }
        
        if userSettings?.location == "" {
            self.locationLabel.text = "-----"
        }else {
            self.locationLabel.text = userSettings?.location
        }
        
        if userSettings?.profile.preferredLanguage.text == "" {
            self.languageLabel.text = "-----"
        }else {
            self.languageLabel.text = userSettings?.profile.preferredLanguage.text
        }
        
        if userSettings?.profile.relationShip.text == "" {
            self.relationshipStatus.text = "-----"
        } else {
            self.relationshipStatus.text = userSettings?.profile.relationShip.text.htmlAttributedString
        }
        
        if userSettings?.profile.workStatus.text == "" {
            self.workStatus.text = "-----"
        } else {
            self.workStatus.text = userSettings?.profile.workStatus.text.htmlAttributedString
        }
        
        if userSettings?.profile.education.text == "" {
            self.educationLabel.text = "-----"
        }else {
            self.educationLabel.text = userSettings?.profile.education.text.htmlAttributedString
        }
    }
    
    func setupInterest() {
        if userSettings?.interest == "" {
            self.interestsLabel.text = "------"
        }else{
            self.interestsLabel.text = userSettings?.interest
        }
    }
    
    func setupLooks() {
        if userSettings?.profile.ethnicity.text == "" {
            self.ethenicityLabel.text = "-----"
        }else{
            self.ethenicityLabel.text = userSettings?.profile.ethnicity.text
        }
        if userSettings?.profile.body.text == "" {
            self.bodyTypeLabel.text = "-----"
        }else{
            self.bodyTypeLabel.text = userSettings?.profile.body.text
        }
        if userSettings?.profile.height.text == "" {
            self.heightLabel.text = "-----"
        }else{
            self.heightLabel.text = userSettings?.profile.height.text
        }
        if userSettings?.profile.hairColor.text == "" {
            self.hairColor.text = "-----"
        }else{
            self.hairColor.text = userSettings?.profile.hairColor.text
        }
    }
    
    func setupPersonality() {
        if userSettings?.profile.character.text == "" {
            self.characterLabel.text = "-----"
        }else{
            self.characterLabel.text = userSettings?.profile.character.text
        }
        
        if userSettings?.profile.children.text == "" {
            self.chidrenLabel.text = "-----"
        }else{
            self.chidrenLabel.text = userSettings?.profile.children.text
        }
        
        if userSettings?.profile.friends.text == "" {
            self.friendsLabel.text = "-----"
        }else{
            self.friendsLabel.text = userSettings?.profile.friends.text
        }
        if userSettings?.profile.pets.text == "" {
            self.petLabel.text = "-----"
            
        }else{
            self.petLabel.text = userSettings?.profile.pets.text
        }
    }
    
    func setupLifeStyles() {
        if userSettings?.profile.liveWith.text == "" {
            self.iLiveWithLabel.text = "-----"
        }else{
            self.iLiveWithLabel.text = userSettings?.profile.liveWith.text
        }
        if userSettings?.profile.car.text == "" {
            self.carLabel.text = "-----"
        }else{
            self.carLabel.text = userSettings?.profile.car.text
        }
        if userSettings?.profile.religion.text == "" {
            self.religionLabel.text = "-----"
        }else{
            self.religionLabel.text = userSettings?.profile.religion.text
        }
        if userSettings?.profile.smoke.text == "" {
            self.smokeLabel.text = "-----"
        }else{
            self.smokeLabel.text = userSettings?.profile.smoke.text
        }
        if userSettings?.profile.drink.text == "" {
            self.drinkLabel.text = "-----"
        }else{
            self.drinkLabel.text = userSettings?.profile.drink.text
        }
        if userSettings?.profile.travel.text == "" {
            self.travelLabel.text = "-----"
        }else{
            self.travelLabel.text = userSettings?.profile.travel.text
        }
    }
    
    func setupFavourite() {
        if userSettings?.favourites.music == "" {

            self.musicGenreLabel.text = "-----"
        }else{
            self.musicGenreLabel.text = userSettings?.favourites.music
        }
        if userSettings?.favourites.dish == "" {
             self.dishLabel.text = "-----"
        }else{
            self.dishLabel.text = userSettings?.favourites.dish
        }
        if userSettings?.favourites.song == "" {
            self.songLabel.text = "-----"
        }else{
            self.songLabel.text = userSettings?.favourites.song
        }
        if userSettings?.favourites.hobby == "" {
            self.hobbyLabel.text = "-----"
        }else{
            self.hobbyLabel.text = userSettings?.favourites.hobby
        }
        if userSettings?.favourites.city == "" {
            self.cityLabel.text = "-----"
        }else{
            self.cityLabel.text = userSettings?.favourites.city
        }
        if  userSettings?.favourites.sport == "" {
            self.sportLabel.text = "-----"
        }else{
            self.sportLabel.text = userSettings?.favourites.sport
        }
        if userSettings?.favourites.book == "" {
             self.bookLabel.text = "-----"
        }else{
            self.bookLabel.text = userSettings?.favourites.book
        }
        if userSettings?.favourites.movie == "" {
            self.movieLabel.text = "-----"
        }else{
            self.movieLabel.text = userSettings?.favourites.movie
        }
        if userSettings?.favourites.colour == "" {
            self.colorLabel.text = "-----"
        }else{
            self.colorLabel.text = userSettings?.favourites.colour
        }
        if userSettings?.favourites.tvChoice == "" {
            self.tvShowLabel.text = "-----"
        }else{
            self.tvShowLabel.text = userSettings?.favourites.tvChoice
        }
    }
    
    private func getMediaFiles() -> [MediaFile] {
        guard let userSettings = appInstance.userProfileSettings else {
            Logger.error("getting user settings"); return []
        }
        return userSettings.mediafiles
    }
}

extension ProfilePreviewVC: ImagePickerPopupDelegate {
    func imagePickerType(_ type: Int) {
        imagePickerController.delegate = self
        switch type {
        case 1001:
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.mediaTypes = ["public.image"]
        case 1002:
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.view.makeToast("Sorry Camera is not found...")
                return
            }
            imagePickerController.sourceType = .camera
            imagePickerController.mediaTypes = ["public.image"]
        case 1003:
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.mediaTypes = ["public.movie"]
        case 1004:
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.view.makeToast("Sorry Camera is not found...")
                return
            }
            imagePickerController.sourceType = .camera
            imagePickerController.mediaTypes = ["public.movie"]
        default:
            break
        }
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

extension ProfilePreviewVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        if self.imageCount == 1{
            self.imageView1.image = image
            
        }else if self.imageCount == 2{
            self.imageView2.image = image
        }
        else if self.imageCount == 3{
            self.imageView3.image = image
        }
        else if self.imageCount == 4{
            self.imageView4.image = image
        }
        else if self.imageCount == 5{
            self.imageView5.image = image
        }else if self.imageCount == 6{
            self.imageView6.image = image
        }
        picker.dismiss(animated: true, completion: nil)
        self.updateMedia(Image: image)
    }
    
    private func updateMedia(Image: UIImage) {
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let mediaImageData = Image.jpegData(compressionQuality: 0.2)
            Async.background({
                UpdateMediaManager.instance.updateAvatar(AccesToken: accessToken, MediaData: mediaImageData, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("success = \(success?.message ?? "")")
                                self.view.makeToast(success?.message)
                                self.appManager.fetchUserProfile()
                                Logger.verbose("UPDATED")
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                self.view.makeToast(sessionError?.errors?.errorText ?? "")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                                self.view.makeToast(error?.localizedDescription ?? "")
                            }
                        })
                    }
                })
            })
        }else{
            Logger.error("internetErrro = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
        
    }
    
    private func deleteMedia(Id: Int) {
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            
            Async.background({
                UpdateMediaManager.instance.deleteMedia(AccessToken: accessToken, MediaId: Id, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("success = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                
                                self.appManager.fetchUserProfile()
                                Logger.verbose("UPDATED")
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                self.view.makeToast(sessionError?.errors?.errorText ?? "")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                                self.view.makeToast(error?.localizedDescription ?? "")
                            }
                        })
                    }
                })
            })
        }else{
            Logger.error("internetErrro = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
}
