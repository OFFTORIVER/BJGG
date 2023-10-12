//
//  NetworkManager.swift
//  BJGG
//
//  Created by 황정현 on 2023/03/23.
//

import Network
import UIKit

final class NetworkManager {
    @Published var networkConnectionStatus: NWPath.Status?
    
    static let shared = NetworkManager()
    
    private let monitor = NWPathMonitor()
    
    private init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        Task {
            for await path in monitor.paths() {
                networkConnectionStatus = path.status
            }
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
