//
//  NetworkViewModel.swift
//  BJGG
//
//  Created by 황정현 on 10/29/23.
//

import Combine
import Dispatch

final class NetworkViewModel {
    @Published private(set)var isNetworkConnected: Bool?
    
    private let networkManager: NetworkManager
    private var cancellables = Set<AnyCancellable>()
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
        
        bindNetworkStatus()
    }
    
    
    private func bindNetworkStatus() {
        NetworkManager.shared.$networkConnectionStatus
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
}
