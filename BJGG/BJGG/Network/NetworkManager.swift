//
//  NetworkManager.swift
//  BJGG
//
//  Created by 황정현 on 2023/03/23.
//

import Combine
import Network
import UIKit

final class NetworkManager {
    @Published private var networkConnectionStatus: NWPath.Status?
    @Published private(set)var isNetworkConnected: Bool?
    
    static let shared = NetworkManager()
    
    private let monitor = NWPathMonitor()
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        startMonitoring()
        bindNetworkStatus()
    }
    
    private func bindNetworkStatus() {
        $networkConnectionStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] networkConnectionStatus in
                guard let networkStatus = networkConnectionStatus else { return }
                switch networkStatus {
                case .satisfied:
                    self?.isNetworkConnected = true
                case .unsatisfied:
                    self?.isNetworkConnected = false
                case .requiresConnection:
                    self?.isNetworkConnected = false
                @unknown default:
                    fatalError()
                }
            }.store(in: &cancellables)
    }
    
    private func startMonitoring() {
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
