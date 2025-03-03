//
//  UserLikesVC.swift
//  QuickDate
//
//  Created by iMac on 04/08/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK

class UserLikesVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStackView: UIStackView!
    
    private let networkManager: NetworkManager = .shared
    private let accessToken = AppInstance.shared.accessToken ?? ""
    
    //MARK: - Life Cycle Function -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchLikesUser()
        self.tableView.addPullToRefresh {
            self.emptyStackView.isHidden = true
            self.fetchLikesUser()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    //MARK: - Selectors -
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchLikesUser() {
        self.showProgressDialog(with: "")
        if Connectivity.isConnectedToNetwork() {
            let param: APIParameters =  [
                "access_token": accessToken,
                "limit": "10"
            ]
            
            self.networkManager.fetchDataWithRequest(urlString: API.USERS_CONSTANT_METHODS.LIST_LIKES_API, method: .post, parameters: param, successCode: .status) { [weak self] result in
                Async.main {
                    self?.tableView.stopPullToRefresh()
                }
                switch result {
                case .success(let success):
                    print(success)
                    Async.main {
                        self?.dismissProgressDialog {
                            if let data = success["data"] as? NSArray {
                                self?.emptyStackView.isHidden = data.count != 0
                            }
                        }
                    }
                case .failure(let error):
                    Async.main({
                        self?.dismissProgressDialog {
                            self?.view.makeToast(error.localizedDescription)
                        }
                    })
                }
            }
        }else {
            self.view.makeToast(InterNetError)
        }
    }
}
