//
//  NetworkObserver.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 5.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import Async
import Reachability
import SwiftEventBus
import QuickDateSDK

final class NetworkObserver {
    // MARK: Instance
    static let shared = NetworkObserver()
    
    // MARK: - Properties
    // Privates
    private var reachability: Reachability?
    
    // Publics
    /// A NetworkCondition property of internet connection of the device
    public private(set) var networkCondition: NetworkCondition = .unReachable
    /// Connection sources which are cellular, wifi, ethernet and unknown
    public private(set) var connectionType: NetworkConnectionType = .none
    
    // MARK: - Enums
    enum NetworkCondition {
        case reachable
        case unReachable
    }
    
    enum NetworkConnectionType {
        case cellular
        case wifi
        case none
    }
    
    // MARK: - Initialiser
    
    private init() {}
    
    // MARK: - Public Functions
    
    public func startHost(_ hostNames: [String], at index: Int) {
        stopNotifier()
        setupReachability(hostNames[index], useClosures: false)
        startNotifier()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.startHost(hostNames, at: (index + 1) % 3)
        }
    }
    
    public func stopNotifier() {
        print("--- stop notifier")
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        reachability = nil
    }
    
    // MARK: - Private Functions
    private func setupReachability(_ hostName: String?, useClosures: Bool) {
        var reachability: Reachability?
        switch hostName {
        case .some(let hostName):
            do {
                reachability = try Reachability(hostname: hostName)
            } catch {
                
            }
        case .none:
            do {
                reachability = try Reachability()
            }
            catch {
                
            }
        }
        
        self.reachability = reachability
        print("--- set up with host name: \(hostName ?? "nil")")
        if useClosures {
            // TODO: consider this code before release it's came from example
            reachability?.whenReachable = { reachability in
//                self.updateLabelColourWhenReachable(reachability)
            }
            reachability?.whenUnreachable = { reachability in
//                self.updateLabelColourWhenNotReachable(reachability)
            }
        } else {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(reachabilityChanged),
                name: .reachabilityChanged,
                object: reachability
            )
        }
    }
    
    private func startNotifier() {
        print("--- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            Logger.error("Unable to start notifier")
            return
        }
    }
    
    @objc func reachabilityChanged(_ note: Notification) {
        
        // TODO: EventBusses will be deleted or not, consider it again
        Async.main({
            
            guard let reachability = note.object as? Reachability else {
                self.changePublicPropertiesTo(network: .unReachable, type: .none)
                return
            }
            
            switch reachability.connection {                
            case .wifi:
                Logger.info("Reachable via WiFi")
                self.changePublicPropertiesTo(network: .reachable, type: .wifi)
                SwiftEventBus.post(EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_CONNECTED)
                SwiftEventBus.post("fetch")
                
            case .cellular:
                Logger.info("Reachable via Cellular")
                self.changePublicPropertiesTo(network: .reachable, type: .cellular)
                SwiftEventBus.post(EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_CONNECTED)

            case .none:
                Logger.info("Network not reachable")
                self.changePublicPropertiesTo(network: .unReachable, type: .none)
                SwiftEventBus.post(EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_DIS_CONNECTED)

            case .unavailable:
                break
            }
        })
    }
    
    private func changePublicPropertiesTo(network condition: NetworkCondition,
                                          type connectionType: NetworkConnectionType) {
        self.networkCondition = condition
        self.connectionType = connectionType
    }
    
}
