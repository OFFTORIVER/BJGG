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
    
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    
    private init() { }
    
    func startMonitoring(window: UIWindow, completion: @escaping () -> Void ){
        let queue = DispatchQueue(label: "NetworkMonitor")
        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive
            
            if path.status != .satisfied {
                DispatchQueue.main.async(execute: {
                    let alert = UIAlertController(title: nil, message: "인터넷에 연결되어 있지 않습니다.\n네트워크 연결을 확인하세요.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "재시도", style: .default, handler: { _ in
                        self?.monitor.start(queue: queue)
                    })
                    alert.addAction(action)
                    
                    window.makeKeyAndVisible()
                    window.rootViewController?.present(alert, animated: true, completion: nil)
                })
            } else {
                completion()
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
