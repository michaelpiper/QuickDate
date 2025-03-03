//
//  AppManager+GiftsAndStickers.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 27.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import Async
import QuickDateSDK
import RealmSwift

extension AppManager {
    
    /// Every time adminSettings will fetch from remote server in the background
    /// during first opening the app in order to handle changes which is done by Admin
    func fetchGiftsFromRemoteServer() {
        
        guard let giftsURL = URL(string: API.COMMON_CONSTANT_METHODS.GET_GIFTS_API) else {
            Logger.error("getting URL"); return
        }
        
        guard let session = getUserSession() else {
            Logger.error("getting session"); return
        }
        
        let params: APIParameters = [API.PARAMS.access_token: session.accessToken]
        
        Async.background({
            self.networkManager.fetchData(with: giftsURL,
                                          method: .post, parameters: params)
            { (result: Result<Data, NetworkError>) in
                switch result {
                case .failure(let error): Logger.error(error)
                case .success(let data):  self.giftsData = data
                }
            }
        })
    }
    
    /// Every time adminSettings will fetch from remote server in the background
    /// during first opening the app in order to handle changes which is done by Admin
    func fetchStickersFromRemoteServer() {
        
        guard let giftsURL = URL(string: API.COMMON_CONSTANT_METHODS.GET_STICKERS_API) else {
            Logger.error("getting URL"); return
        }
        
        guard let session = getUserSession() else {
            Logger.error("getting session"); return
        }
        
        let params: APIParameters = [API.PARAMS.access_token: session.accessToken]
        
        Async.background({
            self.networkManager.fetchData(with: giftsURL,
                                          method: .post, parameters: params)
            { (result: Result<Data, NetworkError>) in
                switch result {
                case .failure(let error): Logger.error(error)
                case .success(let data):  self.stickersData = data
                }
            }
        })
    }
}
