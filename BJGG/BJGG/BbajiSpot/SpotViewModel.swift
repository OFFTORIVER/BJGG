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
    @Published private(set) var screenSizeStatus: ScreenSizeStatus = .origin
    
    private var cancellables = Set<AnyCancellable>()
    
    struct Input {
        let screenSizeButtonTapPublisher: AnyPublisher<Void, Never>?
        let willEnterForeground: NotificationCenter.Publisher?
        let didEnterBackground: NotificationCenter.Publisher?
    }
    
    struct Output {
        var willEnterForeground: PassthroughSubject<Bool, Never>
    }
    
    func transform(input: Input) -> Output {
        let willEnterForeground = PassthroughSubject<Bool, Never>()
        
        input.screenSizeButtonTapPublisher?.sink { [weak self] _ in
            self?.changeScreenSizeStatus()
        }.store(in: &cancellables)
        
        input.didEnterBackground?.sink { _ in
            willEnterForeground.send(false)
        }.store(in: &cancellables)
        
        input.willEnterForeground?.sink { _ in
            willEnterForeground.send(true)
        }.store(in: &cancellables)
        
        return Output(willEnterForeground: willEnterForeground)
    }
    
    func changeScreenSizeStatus() {
        if screenSizeStatus == .normal || screenSizeStatus == .origin {
            screenSizeStatus = .full
        } else {
            screenSizeStatus = .normal
        }
    }
}
