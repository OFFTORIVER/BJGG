//
//  SpotLiveCameraViewModel.swift
//  BJGG
//
//  Created by 황정현 on 2023/06/24.
//

import AVFoundation
import Combine
import UIKit


final class SpotLiveCameraViewModel: ViewModelType {
    @Published private(set) var screenSizeStatus: ScreenSizeStatus = .origin
    @Published private(set) var playStatus: PlayStatus = .origin
    
    private var controlStatus: CurrentValueSubject<ControlStatus, Never> = CurrentValueSubject(.hidden)
    private var cancellables = Set<AnyCancellable>()
    
    struct Input {
        let cameraViewTapPublisher: AnyPublisher<UITapGestureRecognizer, Never>?
        let reloadButtonTapPublisher: AnyPublisher<Void, Never>?
        let screenSizeButtonTapPublisher: AnyPublisher<Void, Never>?
        let playStatus: CurrentValueSubject<AVPlayerItem.Status, Never>?
    }
    
    struct Output {
        var controlStatus: CurrentValueSubject<ControlStatus, Never>
    }
    
    func transform(input: Input) -> Output {
        input.cameraViewTapPublisher?.sink {[weak self] _ in
            self?.changeControlStatus()
        }.store(in: &cancellables)
        
        input.reloadButtonTapPublisher?.sink{ [weak self] _ in
            self?.changePlayStatus(as: .origin)
        }.store(in: &cancellables)
        
        input.screenSizeButtonTapPublisher?.sink { [weak self] _ in
            self?.changeScreenSizeStatus()
        }.store(in: &cancellables)
        
        input.playStatus?.sink { [weak self] status in
            switch status {
            case .readyToPlay:
                print(".readyToPlay")
                self?.changePlayStatus(as: .readyToPlay)
            case .failed:
                print(".failed")
                self?.changePlayStatus(as: .failed)
            case .unknown:
                print(".unknown")
                self?.changePlayStatus(as: .failed)
            @unknown default:
                print("@unknown default")
            }
        }.store(in: &cancellables)
        
        return Output(controlStatus: controlStatus)
    }
    
    private func changeControlStatus() {
        if controlStatus.value == .hidden {
            controlStatus.send(.exist)
        } else {
            controlStatus.send(.hidden)
        }
    }
    
    func changeScreenSizeStatus() {
        if screenSizeStatus == .normal || screenSizeStatus == .origin {
            screenSizeStatus = .full
        } else {
            screenSizeStatus = .normal
        }
    }
    
    func changePlayStatus(as status: PlayStatus) {
        changeControlStatus()
        playStatus = status
    }

}
