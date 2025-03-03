//
//  TrendingListVC.swift
//  QuickDate
//
//  Created by iMac on 20/10/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit
import Async
import FittedSheets
import QuickDateSDK

class TrendingListVC: BaseViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(cellType: TrendingCollectionItem.self)
            collectionView.collectionViewLayout = flowLayout
        }
    }
    
    //MARK:- Variable
    private let flowLayout = UICollectionViewFlowLayout()
    private var trendingUsers: [[String:Any]] = []
    private let appInstance: AppInstance = .shared
    private let proLimit = 15
    private let hotOrNotLimit = 2 // 20
    private let searchLimit = 25
    var searchOffset: Int = 0
    private let defaults: Defaults = .shared
    private let accessToken = AppInstance.shared.accessToken ?? ""
    private let networkManager: NetworkManager = .shared
    private let appNavigator: AppNavigator = .shared
    var searchUserList: [UserProfileSettings] = []
    private enum SearchType {
        case pro
        case hot
        case trending
    }
    
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
}

// MARK: - Custom Function
extension TrendingListVC {
    private func setupUI() {
     //   self.fetchTrendingUserList(atFirst: true)
        self.collectionView.reloadData()
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
    
    private func isConnectedToNetwork() -> Bool {
        guard Connectivity.isConnectedToNetwork() else {
            self.view.makeToast(InterNetError)
            return false
        }
        return true
    }
    
    private func fetchTrendingUserList(atFirst: Bool) {
        guard isConnectedToNetwork() else { return }
        if atFirst {
            searchUserList.removeAll()
        }
        let params = setSearchParameters(limit: searchLimit, offset: searchOffset, type: .trending)
    //    self.showProgressDialog(with: "Loading...")
        Async.background({
            self.networkManager.fetchDataWithRequest(
                urlString: API.USERS_CONSTANT_METHODS.SEARCH_API,
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
                                self?.addOrAppendUsers(with: userList, atFirst: atFirst)
                            }
                        })
                    }
                }
        })
    }
    
    private func addOrAppendUsers(with userList: [UserProfileSettings], atFirst: Bool) {
        switch atFirst {
        case true:
            searchUserList = userList
            collectionView.reloadData()
        case false:
            let newList = userList.compactMap { (user) -> UserProfileSettings? in
                let isSameUser =  searchUserList.filter { $0.id == user.id }.first
                return isSameUser == .none ? user : nil
            }
            let firstIndex = searchUserList.count
            let lastIndex = newList.count + firstIndex - 1
            guard lastIndex >= firstIndex else { return } // Safety check
            let indexPathList = Array(firstIndex...lastIndex).map { IndexPath(row: $0, section: 0) }
            searchUserList.append(contentsOf: newList)
            collectionView.insertItems(at: indexPathList)
        }
        searchOffset += 1
    }
}

// MARK: - Action
extension TrendingListVC {
    @IBAction func onBtnFilter(_ sender: UIButton) {
    }
    
    @IBAction func onBtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - DataSource
extension TrendingListVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchUserList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as TrendingCollectionItem
        cell.user = searchUserList[indexPath.row]
        cell.indexPathRow = indexPath.row
        cell.viewController = self
        cell.baseVC = self
        return cell
    }
}

// MARK: - Delegate
extension TrendingListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        appNavigator.dashboardNavigate(
            to: .userDetail(user: .randomUser(searchUserList[indexPath.row]),
                            delegate: .none))
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let reloadingIndex = searchUserList.count - 12
        if reloadingIndex == indexPath.row {
            Logger.debug("reloadingIndex: \(reloadingIndex)")
            fetchTrendingUserList(atFirst: false)
        }
    }
}

// MARK: - FlowLayout
extension TrendingListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width/2, height: 250)
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
