//
//  TransactionsListViewController.swift
//  QuickDate
//
//  Created by iMac on 01/11/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit
import QuickDateSDK
import Async

class TransactionsListViewController: BaseViewController {
    
    @IBOutlet weak var tableViewTransaction: UITableView!
    @IBOutlet weak var emptyView: UIStackView!
    
    private let proLimit = 15
    private var proOffset: Int?
    private let networkManager: NetworkManager = .shared
    private let appNavigator: AppNavigator = .shared
    private let accessToken = AppInstance.shared.accessToken ?? ""
    private var arrTransactions = [TransactionsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.tableViewTransaction.addPullToRefresh {
            self.proOffset = 0
            self.fetchTransactionsList(atFirst: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
}

//MARK: Custom Function
extension TransactionsListViewController {
    private func setupUI() {
        tableViewTransaction.delegate = self
        tableViewTransaction.dataSource = self
        tableViewTransaction.backgroundColor = .clear
        tableViewTransaction.register(UINib(nibName: "TransactionsTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionsTableViewCell")
        self.fetchTransactionsList(atFirst: true)
    }
    
    private func isConnectedToNetwork() -> Bool {
        guard Connectivity.isConnectedToNetwork() else {
            self.view.makeToast(InterNetError)
           return false
        }
        return true
    }
    
    private func setSearchParameters(limit: Int, offset: Int?) -> APIParameters {
        var params: APIParameters = [
            API.PARAMS.limit: "\(limit)",
            API.PARAMS.access_token: self.accessToken,
        ]
        
        if let offset = offset {
            params[API.PARAMS.offset] = "\(offset)"
        }
        return params
    }
    
    private func fetchTransactionsList(atFirst: Bool) {
        guard isConnectedToNetwork() else { return }
        let params = setSearchParameters(limit: proLimit, offset: proOffset)
        if atFirst {
            arrTransactions.removeAll()
        }
        Async.background({
            self.networkManager.fetchDataWithRequest(
                urlString: API.USERS_CONSTANT_METHODS.LIST_TRANSACTIONS_API,
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
                                if let arrayData = dict["data"] as? [[String: Any]] {
                                    let decoder = JSONDecoder()
                                    if let data = try? JSONSerialization.data(withJSONObject: arrayData, options: []) {
                                        if let arrModel = try? decoder.decode([TransactionsData].self, from: data) {
                                            for object in arrModel {
                                                self?.arrTransactions.append(object)
                                            }
                                        }
                                    }
                                }
                                self?.emptyView.isHidden = !(self?.arrTransactions.count == 0)
                                self?.tableViewTransaction.reloadData()
                            }
                        })
                    }
                }
        })
    }
}

//MARK: Action
extension TransactionsListViewController {
    @IBAction func onBtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension TransactionsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsTableViewCell", for: indexPath) as! TransactionsTableViewCell
        cell.setTransactionsData(modelObject: arrTransactions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let reloadingIndex = arrTransactions.count - 12
        
        if reloadingIndex == indexPath.row {
            Logger.debug("reloadingIndex: \(reloadingIndex)")
            fetchTransactionsList(atFirst: false)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
