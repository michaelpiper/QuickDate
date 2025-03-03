//
//  TrendingVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import FittedSheets
import QuickDateSDK

class TrendingVC: BaseViewController {
    
    // MARK: - View
    
    
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backView: UIView!
    
    private let flowLayout = UICollectionViewFlowLayout()
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: TrendingSectionCollectionCell.self)
            collectionView.register(cellType: ProUserListCollectionViewCell.self)
            collectionView.register(cellType: HotOrNotListCollectionViewCell.self)
            collectionView.register(cellType: TrendingCollectionItem.self)
            collectionView.collectionViewLayout = flowLayout
        }
    }
    @IBOutlet weak var filtrBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollToTopButton: UIButton!
    
    // MARK: - Properties
    // Property Injections
    private let appInstance: AppInstance = .shared
    private let defaults: Defaults = .shared
    private let networkManager: NetworkManager = .shared
    private let appNavigator: AppNavigator = .shared
    private let accessToken = AppInstance.shared.accessToken ?? ""
    private let notificationCenter: NotificationCenter = .default

    // Others
    var status:Bool? = false
    
    private var proUserList: [UserProfileSettings] = []
    var hotOrNotUserList: [UserProfileSettings] = []
    private var searchUserList: [UserProfileSettings] = []
    // Offset
    private var proOffset: Int?
    private var hotOrNotOffset: Int?
    private var searchOffset: Int = 0
    // Limit
    private let proLimit = 15
    private let hotOrNotLimit = 10
    private let searchLimit = 25
    
    private var scrollTopButtonIsHidden = true
    private var isPageLoaded: Bool?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.activityIndicatorProcess(to: .start)
        self.fetchData()
        self.addNotificationObservers()
        isPageLoaded = true
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.fetchData), for: .valueChanged)
        self.collectionView.refreshControl = refresher
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard isPageLoaded ?? false else { return } // Safety Check
        
        DispatchQueue.main.async { [self] in
            handleGradientColors()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        handleGradientColors()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    // MARK: - Services
    
    private enum SearchType {
        case pro
        case hot
        case trending
    }
    
    private func setSearchParameters(limit: Int, offset: Int?, type: SearchType) -> APIParameters {
        var params: APIParameters = [
            API.PARAMS.limit: "\(limit)",
            API.PARAMS.access_token: self.accessToken,
        ]
        
        if let offset = offset {
            params[API.PARAMS.offset] = "\(offset)"
        }
        
        switch type {
        case .pro: break
        case .hot:
            let filters = defaults.get(for: .hotOrNotFilter) ?? DashboardFilter()
            filters.params.forEach { params[$0.key] = $0.value }
        case .trending:
            let filters = appInstance.trendingFilters 
            filters.params.forEach { params[$0.key] = $0.value }
        }
        return params
    }
    
    @objc func fetchData() {
        self.searchOffset = 0
        self.proUserList.removeAll()
        self.hotOrNotUserList.removeAll()
        self.searchUserList.removeAll()
        self.collectionView.reloadData()
        self.fetchProUserList()
        /*getHotOrNot()
        fetchTrendingUserList(atFirst: true)*/
    }
    
    // MARK: - Pro
    private func fetchProUserList() {
        guard isConnectedToNetwork() else { return }
        let params = setSearchParameters(limit: proLimit, offset: proOffset, type: .pro)
        Async.background({
            self.networkManager.fetchDataWithRequest(
                urlString: API.USERS_CONSTANT_METHODS.GET_PRO_API,
                method: .post, parameters: params, successCode: .code) { [weak self] (result) in
                    switch result {
                    case .failure(let error):
                        Async.main({
                            self?.dismissProgressDialog {
                                self?.view.makeToast(error.localizedDescription)
                                self?.activityIndicatorProcess(to: .stop)
                            }
                        })
                    case .success(let dict):
                        Async.main({
                            self?.dismissProgressDialog {
                                guard let dictionaryList = dict["data"] as? [JSON] else {
                                    Logger.error("getting random users data"); return
                                }
                                self?.proUserList = dictionaryList.map { UserProfileSettings(dict: $0) }
//                                self?.collectionView.reloadSections([0])
//                                self?.collectionView.reloadData()
                                self?.getHotOrNot()
                            }
                        })
                    }
                }
        })
    }
    // MARK: HotOrNot
    private func getHotOrNot() {
        guard isConnectedToNetwork() else { return }
        let params = setSearchParameters(limit: hotOrNotLimit, offset: hotOrNotOffset, type: .hot)
        
        Async.background({
            self.networkManager.fetchDataWithRequest(
                urlString: API.USERS_CONSTANT_METHODS.HOT_OR_NOT_API,
                method: .post, parameters: params, successCode: .code) { [weak self] (result) in
                    self?.activityIndicatorProcess(to: .stop)
                    switch result {
                    case .failure(let error):
                        Async.main({
                            self?.dismissProgressDialog {
                                self?.view.makeToast(error.localizedDescription)
                                self?.activityIndicatorProcess(to: .stop)
                            }
                        })
                    case .success(let dict):
                        Async.main({
                            self?.dismissProgressDialog {
                                guard let dictionaryList = dict["data"] as? [JSON] else {
                                    Logger.error("getting random users data"); return
                                }
                                self?.hotOrNotUserList = dictionaryList.map { UserProfileSettings(dict: $0) }
//                                self?.collectionView.reloadSections([2])
//                                self?.collectionView.reloadData()
                                self?.fetchTrendingUserList(atFirst: true)
                            }
                        })
                    }
                }
        })
                    
    }
    
    // MARK: Trending
    private func fetchTrendingUserList(atFirst: Bool) {
        guard isConnectedToNetwork() else { return }
        if atFirst {
            searchUserList.removeAll()
        }
        let params = setSearchParameters(limit: searchLimit, offset: searchOffset, type: .trending)
        print(params)
        Logger.error("Filter Params:---------- \(params)")        
        Async.background {
            self.networkManager.fetchDataWithRequest(
                urlString: API.USERS_CONSTANT_METHODS.SEARCH_API,
                method: .post, parameters: params, successCode: .code) { [weak self] (result) in
                    Async.main {
                        self?.collectionView.refreshControl?.endRefreshing()
                    }
                    switch result {
                    case .failure(let error):
                        Async.main({
                            self?.dismissProgressDialog {
                                self?.view.makeToast(error.localizedDescription)
                                self?.activityIndicatorProcess(to: .stop)
                            }
                        })
                    case .success(let dict):
                        Async.main {
                            self?.dismissProgressDialog {
                                guard let dictionaryList = dict["data"] as? [JSON] else {
                                    Logger.error("getting random users data"); return
                                }
                                let userList = dictionaryList.map { UserProfileSettings(dict: $0) }
                                self?.addOrAppendUsers(with: userList, atFirst: atFirst)
                                self?.activityIndicatorProcess(to: .stop)
                            }
                        }
                    }
                }
        }
    }
    
    private func addOrAppendUsers(with userList: [UserProfileSettings], atFirst: Bool) {
        switch atFirst {
        case true:
            searchUserList = userList
            self.collectionView.reloadData()
        case false:
            let newList = userList.compactMap { (user) -> UserProfileSettings? in
                let isSameUser =  searchUserList.filter { $0.id == user.id }.first
                return isSameUser == .none ? user : nil
            }
            let firstIndex = searchUserList.count
            let lastIndex = newList.count + firstIndex - 1
            guard lastIndex >= firstIndex else { return } // Safety check
            let indexPathList = Array(firstIndex...lastIndex).map { IndexPath(row: $0, section: 3) }
            searchUserList.append(contentsOf: newList)
            collectionView.insertItems(at: indexPathList)
        }
        searchOffset += 1
    }
    
    // MARK: - Private Functions
    
    private func activityIndicatorProcess(to process: Process) {
        DispatchQueue.main.async { [self] in
            self.activityIndicator.isHidden = process == .start ? false : true
            switch process {
            case .start: activityIndicator.startAnimating()
            case .stop:  activityIndicator.stopAnimating()
            }
        }
    }
    
    private func isConnectedToNetwork() -> Bool {
        guard Connectivity.isConnectedToNetwork() else {
            self.view.makeToast(InterNetError)
            self.activityIndicatorProcess(to: .stop); return false
        }
        return true
    }
    
    // MARK: - Observe
    @objc private func deleteObjectInHotOrNotUserList(_ notification: Notification) {
        guard let dict = notification.userInfo as NSDictionary?,
              let indexPathRow = dict[UserInfoKey.indexPath.rawValue] as? Int else {
            Logger.error("getting dict"); return
        }
        guard indexPathRow < hotOrNotUserList.count else { return } // Safety Check
        hotOrNotUserList.remove(at: indexPathRow)
        
        if hotOrNotUserList.isEmpty {
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.reloadSections([3])
        }
    }
    
    @objc private func showErrorInHotOrNotUserList(_ notification: Notification) {
        guard let dict = notification.userInfo as NSDictionary?,
              let error = dict[UserInfoKey.error.rawValue] as? String else {
            Logger.error("getting dict"); return
        }
        Logger.error(error)
        view.makeToast(error)
    }
    
    // MARK: - Actions
    
    @objc private func viewMoreButtonTrendingPressed() {
        let viewController = TrendingListVC.instantiate(fromStoryboardNamed: .trending)
        viewController.searchOffset = searchOffset
        viewController.searchUserList = searchUserList
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func viewMoreButtonPressed() {
        appNavigator.trendingNavigate(to: .hotOrNot(userList: hotOrNotUserList))
    }
    
    @IBAction func boostPressed(_ sender: UIButton) {
        let vc = R.storyboard.main.boostVC()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func filterPressed(_ sender: UIButton) {
        let controller = FilterParentVC.instantiate(fromStoryboardNamed: .trending)
        controller.filterDelegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func scrollToTopButtonPressed(_ sender: UIButton) {
        Logger.debug("pressed")
        collectionView.scrollToItem(at: [0, 0], at: .top, animated: true)
    }
    
}

// MARK: - DataSource

extension TrendingVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 3 ? searchUserList.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 1:
            let section: TrendingSection = .hot
            let cell = collectionView.dequeueReusableCell(for: indexPath) as TrendingSectionCollectionCell
            cell.section = section
            if indexPath.section == 1 {
                cell.viewMoreButton.addTarget(self, action: #selector(viewMoreButtonPressed), for: .touchUpInside)
            }
            return cell
        case 0:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as ProUserListCollectionViewCell
            cell.userList = proUserList
            cell.controller = self
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as HotOrNotListCollectionViewCell
            cell.userList = hotOrNotUserList
            cell.viewController = self
            cell.controller = self
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as TrendingCollectionItem
            cell.user = searchUserList[indexPath.row]
            cell.indexPathRow = indexPath.row
            cell.viewController = self
            cell.baseVC = self
            return cell
        default: return UICollectionViewCell()
        }
    }
}

// MARK: - Delegate

extension TrendingVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            appNavigator.dashboardNavigate(
                to: .userDetail(user: .randomUser(searchUserList[indexPath.row]),
                                delegate: .none))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let reloadingIndex = searchUserList.count - 2
        if reloadingIndex == indexPath.row {
            Logger.debug("reloadingIndex: \(reloadingIndex)")
            fetchTrendingUserList(atFirst: false)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > 400 {
            guard scrollTopButtonIsHidden else { return }
            scrollToTopButton.isHidden = false
            scrollTopButtonIsHidden = false
        } else {
            guard !scrollTopButtonIsHidden else { return }
            scrollToTopButton.isHidden = true
            scrollTopButtonIsHidden = true
        }
    }
}

// MARK: - FlowLayout

extension TrendingVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 1: return CGSize(width: collectionView.frame.width, height: 50)
        case 0: return CGSize(width: collectionView.frame.width, height: 100)
        case 2:
            let height: CGFloat = hotOrNotUserList.isEmpty ? 0 : 290
            return CGSize(width: collectionView.frame.width, height: height)
        case 3: return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.width/2)
        default: return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - FilterDelegate
extension TrendingVC: FilterDelegate {
    
    func filter(status: Bool) {
        fetchTrendingUserList(atFirst: true)
    }
    
}

// MARK: - Helper
extension TrendingVC {
    
    private func addNotificationObservers() {
        notificationCenter.addObserver(self, selector: #selector(deleteObjectInHotOrNotUserList),
                                       name: .hotOrNotUserDelete, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(showErrorInHotOrNotUserList),
                                       name: .hotOrNotUserCellError, object: nil)
        
    }
    
    private func handleGradientColors() {
        let startColor = Theme.primaryStartColor.colour
        let endColor = Theme.primaryEndColor.colour
//        createMainViewGradientLayer(to: upperPrimaryView,
//                                    startColor: startColor,
//                                    endColor: endColor)
    }
    
    private func configureUI() {
      //  navBarView.setThemeBackgroundColor(.secondaryBackgroundColor)
        self.navBarView.clipsToBounds = true
    //    navBarView.layer.cornerRadius = 15
      //  navBarView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        //        self.backView.backgroundColor = Theme.primaryEndColor.colour
        scrollToTopButton.setTitle("", for: .normal)
    }
    
}
