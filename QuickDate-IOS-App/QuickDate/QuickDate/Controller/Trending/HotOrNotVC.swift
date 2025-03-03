//
//  HotOrNotVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import FittedSheets
import RealmSwift
import QuickDateSDK

/// - Tag: HotOrNotVC
class HotOrNotVC: BaseViewController {
    
    // MARK: - Views
//    @IBOutlet weak var upperPrimaryView: UIView!
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var hotNotLabel: UILabel!
    
    @IBOutlet weak var noItemView: UIView!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var noImage: UIImageView!
   
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: HotOrNotShowTableItem.self)
        }
    }
    
    // MARK: - Properties
    // Property Injections
    private let appNavigator: AppNavigator = .shared
    private let appInstance: AppInstance = .shared
    private let defaults: Defaults = .shared
    private let networkManager: NetworkManager = .shared
    private let accessToken = AppInstance.shared.accessToken ?? ""
    // Others
    var hotOrNotUserList: [UserProfileSettings] = [] {
        didSet {
            offset = Int(hotOrNotUserList.last?.id ?? "0")
        }
    }
    private var offset: Int?
    
    private var limit = 20


    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async { [self] in
            handleGradientColors()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        handleGradientColors()
    }
    
    // MARK: - Services
    
    private func setSearchParameters() -> APIParameters {
        var params: APIParameters = [
            API.PARAMS.limit: "\(limit)",
            API.PARAMS.access_token: self.accessToken,
        ]
        
        if let offset = offset {
            params[API.PARAMS.offset] = "\(offset)"
        }
        
        if let filters = defaults.get(for: .dashboardFilter) {
            filters.params.forEach { params[$0.key] = $0.value }
        }
        
        return params
    }
    
    private func fetchHotOrNotUsers(isFromFilter: Bool) {
        guard appInstance.isConnectedToNetwork(in: self.view) else { return }
        
        let params = setSearchParameters()
        
        if isFromFilter {
            hotOrNotUserList.removeAll()
        }
        
        Async.background({
            self.networkManager.fetchDataWithRequest(
                urlString: API.USERS_CONSTANT_METHODS.HOT_OR_NOT_API,
                method: .post, parameters: params, successCode: .code) { [weak self] (result) in
                    switch result {
                    case .failure(let error):
                        Async.main({
                            self?.dismissProgressDialog {
                                self?.view.makeToast(error.localizedDescription)
                            }
                        })
                    case .success(let dict):
                        Async.main({
                            self?.dismissProgressDialog {
                                guard let dictionaryList = dict["data"] as? [JSON] else {
                                    Logger.error("getting random users data"); return
                                }
                                let userList = dictionaryList.map { UserProfileSettings(dict: $0) }
                                self?.append(this: userList, from: isFromFilter)
                            }
                        })
                    }
                }
        })
    }
    
    private func append(this userList: [UserProfileSettings], from isFromFilter: Bool) {
        
        switch isFromFilter {
        case true:
            hotOrNotUserList = userList
            if hotOrNotUserList.isEmpty {
                noItemView.isHidden = !hotOrNotUserList.isEmpty
            }
            guard !hotOrNotUserList.isEmpty else { return } // Safety check
            tableView.reloadData()
            tableView.scrollToRow(at: [0, 0], at: .top, animated: true)
            
        case false:
            let newList = userList.compactMap { (user) -> UserProfileSettings? in
                let isSameUser =  hotOrNotUserList.filter { $0.id == user.id }.first
                return isSameUser == .none ? user : nil
            }
            
            let firstIndex = hotOrNotUserList.count
            let lastIndex = newList.count + firstIndex - 1
            
            guard lastIndex >= firstIndex else { return } // Safety check
            
            let indexPathList = Array(firstIndex...lastIndex).map { IndexPath(row: $0, section: 0) }
            hotOrNotUserList.append(contentsOf: newList)
            tableView.insertRows(at: indexPathList, with: .automatic)
        }
        
    }
    
    private func fetchData(gender: String) {
        if Connectivity.isConnectedToNetwork(){
//            self.hotOrNotArray.removeAll()
            self.tableView.reloadData()
            
            self.showProgressDialog(with: "Loading...")
            
            let accessToken = AppInstance.shared.accessToken ?? ""
            
            Async.background({
                HotOrNotManager.instance.getHotOrNot(AccessToken: accessToken, limit: 20, offset: 0, genders: gender) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            Logger.debug("userList = \(success?.data ?? [])")
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
    
    // MARK: - Actions
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterPressed(_ sender: UIButton) {
        let viewController = DashboardFilterViewController
            .instantiate(fromStoryboardNamed: .dashboard)
        viewController.delegate = self
        viewController.filterType = .hotOrNot
        let controller = SheetViewController(controller: viewController,
                                             sizes: [.fullscreen])
        controller.hasBlurBackground = true
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true, completion: nil)
    }
    
}

// MARK: - DataSource

extension HotOrNotVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotOrNotUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as HotOrNotShowTableItem
        let user = self.hotOrNotUserList[indexPath.row]
        cell.user = user
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
}

// MARK: - Delegate

extension HotOrNotVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.hotOrNotUserList[indexPath.row]
        appNavigator.dashboardNavigate(to: .userDetail(user: .randomUser(user), delegate: .none))
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if hotOrNotUserList.count - 5 == indexPath.row {
            fetchHotOrNotUsers(isFromFilter: false)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            fetchHotOrNotUsers(isFromFilter: false)
        }
    }
}

// MARK: - HotOrNotShowTableItemDelegate

extension HotOrNotVC: HotOrNotShowTableItemDelegate {
    func deleteItem(at indexPath: IndexPath?) {
        guard let indexPath = indexPath else {
            Logger.error("getting indexPath"); return
        }
        Async.main({ [self] in
            hotOrNotUserList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        })
    }
}

// MARK: - FilterDelegate
extension HotOrNotVC: DashboardFilterDelegate {
    func applyFilterSettings() {
        fetchHotOrNotUsers(isFromFilter: true)
    }
}

// MARK: - Helper

extension HotOrNotVC {
    
    private func handleGradientColors() {
        let startColor = Theme.primaryStartColor.colour
        let endColor = Theme.primaryEndColor.colour
//        createMainViewGradientLayer(to: upperPrimaryView,
//                                    startColor: startColor,
//                                    endColor: endColor)
    }

    private func configureNavBar() {
        self.hotNotLabel.text = "Hot or Not".localized
    }
    
    private func setupUI() {
        handleGradientColors()
        configureNavBar()
        self.noImage.tintColor = Theme.primaryEndColor.colour
        self.noLabel.text = "There is no data to show".localized
        noItemView.isHidden = !hotOrNotUserList.isEmpty
        tableView.reloadData()
        
    }
}
