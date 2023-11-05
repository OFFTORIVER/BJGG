//
//  SpotViewModel.swift
//  BJGG
//
//  Created by 황정현 on 2023/04/04.
//

import AVFoundation
import Combine
import UIKit

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

final class SpotViewModel: ViewModelType {
    private var cancellables = Set<AnyCancellable>()
    private var networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    struct Input {
        let willEnterForeground: NotificationCenter.Publisher?
        let didEnterBackground: NotificationCenter.Publisher?
    }
    
    struct Output {
        var willEnterForeground: PassthroughSubject<Bool, Never>
    }
    
    func transform(input: Input) -> Output {
        let willEnterForeground = PassthroughSubject<Bool, Never>()
        
        input.didEnterBackground?.sink { _ in
            willEnterForeground.send(false)
        }.store(in: &cancellables)
        
        input.willEnterForeground?.sink { _ in
            willEnterForeground.send(true)
        }.store(in: &cancellables)
        
        return Output(willEnterForeground: willEnterForeground)
    }
    
    func isNetworkConnected() -> Published<Bool?>.Publisher {
        return networkManager.$isNetworkConnected
    }
}
