//
//  NetworkManager.swift
//  BJGG
//
//  Created by 황정현 on 2023/03/23.
//

import Network
import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    private let monitor = NWPathMonitor()
    
    private init() { }
    
    func refactorStartMonitoring(window: UIWindow) {
        Task {
            for await path in monitor.paths() {
                switch path.status {
                case .satisfied:
                    DispatchQueue.main.async { [weak self] in
                        self?.fetchData(window: window)
                    }
                default:
                    DispatchQueue.main.async{ [weak self] in
                        self?.showNetworkStatusAlert(window: window)
                    }
                }
            }
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    private func showNetworkStatusAlert(window: UIWindow) {
        let alert = UIAlertController(title: nil, message: "인터넷에 연결되어 있지 않습니다.\n네트워크 연결을 확인하세요.", preferredStyle: .alert)
        let action = UIAlertAction(title: "재시도", style: .default, handler: { _ in
            self.refactorStartMonitoring(window: window)
        })
        alert.addAction(action)
        
        window.makeKeyAndVisible()
        window.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    private func fetchData(window: UIWindow) {
        if let rootVC = window.rootViewController as? UINavigationController {
            if rootVC.viewControllers.count == 1 {
                if let vc = rootVC.viewControllers[0] as? BbajiHomeViewController {
                    vc.viewModel.fetchWeatherNows()
                    return
                }
            } else if rootVC.viewControllers.count == 2 {
                if let vc = rootVC.viewControllers[1] as? BbajiSpotViewController {
                    vc.weatherViewModel?.receiveBbajiWeatherData()
                    return
                }
            }
        }
    }
}
