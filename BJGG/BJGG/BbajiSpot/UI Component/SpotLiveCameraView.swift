//
//  SpotLiveCameraView.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/18.
//

import AVFoundation
import Combine
import CombineCocoa
import SnapKit
import UIKit

final class SpotLiveCameraView: UIView {
    
    lazy var videoPlayerControlView: SpotLiveCameraControlView = {
        let view = SpotLiveCameraControlView(viewModel: viewModel)
        view.alpha = 0.0
        return view
    }()
    
    var stanbyView: SpotLiveCameraStandbyView = SpotLiveCameraStandbyView()
    
    private let videoURL = BbajiInfo().getLiveCameraUrl()
    private let reloadButton: UIButton = {
       let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 45, weight: .regular, scale: .medium)
        let image = UIImage(systemName: "arrow.clockwise", withConfiguration: config)?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
        
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    private var playerItemContext = 0

    private var playerItem: AVPlayerItem?
    
    private let viewModel: SpotViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: SpotViewModel) {
        self.viewModel = viewModel
        super.init(frame: CGRect.zero)

        configure()
        bind(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    private func configure() {
        configureLayout()
        configureStyle()
        configureComponent()
        configureAction()
    }
    
    private func configureLayout() {
        
        addSubview(videoPlayerControlView)
        videoPlayerControlView.snp.makeConstraints({ make in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        })
        
        addSubview(stanbyView)
        stanbyView.snp.makeConstraints({ make in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
        })
        
        addSubview(reloadButton)
        reloadButton.snp.makeConstraints({ make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(100)
        })
    }
    
    private func configureStyle() {
        self.backgroundColor = .black
        self.isUserInteractionEnabled = true
    }
    
    private func configureComponent() {
        self.player?.rate = 30
        playerLayer.player?.currentItem?.automaticallyPreservesTimeOffsetFromLive = true
        
        changeReloadButtonActiveStatus(as: false)
        interactionEnableStatus(as: true)
    }
    
    private func configureAction() {
        reloadButton.tapPublisher.sink { [self] _ in
            viewModel.changePlayStatus(as: .origin)
        }.store(in: &cancellables)
    }
    
    private func bind(viewModel: SpotViewModel) {
        
        let tapGesture = UITapGestureRecognizer()
        addGestureRecognizer(tapGesture)
        let input = SpotViewModel.Input(
            cameraViewTapGesture: tapGesture.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        output.controlStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
            guard let self = self else { return }
            status.changeControlStatusView(view: self.videoPlayerControlView)
        }.store(in: &cancellables)
        
        viewModel.playStatus.sink { [self] status in
            switch status {
            case .origin:
                playVideo()
                changeReloadButtonActiveStatus(as: false)
                stanbyView.reloadStandbyView()
            case .readyToPlay:
                changeReloadButtonActiveStatus(as: false)
                stanbyView.changeStandbyView(isStandbyNeed: false)
            case .failed:
                changeReloadButtonActiveStatus(as: true)
                stanbyView.stopLoadingAnimation()
                stanbyView.changeStandbyView(isStandbyNeed: true)
            }
        }.store(in: &cancellables)
    }
    
    private func setUpAsset(with url: URL, completion: ((_ asset: AVAsset) -> Void)?) {
        let asset = AVAsset(url: url)
        
        Task {
            let isPlayable = try await asset.load(.isPlayable)
            
            if isPlayable {
                completion?(asset)
            } else {
                print("Non-playable")
            }
        }
    }
    
    // https://medium.com/@tarasuzy00/build-video-player-in-ios-i-avplayer-43cd1060dbdc
    private func setUpPlayerItem(with asset: AVAsset) {
        playerItem = AVPlayerItem(asset: asset)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
            
        DispatchQueue.main.async { [weak self] in
            self?.player = AVPlayer(playerItem: self?.playerItem!)
        }
    }
        
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }

            interactionEnableStatus(as: true)
            switch status {
            case .readyToPlay:
                print(".readyToPlay")
                viewModel.changePlayStatus(as: .readyToPlay)
                player?.play()
            case .failed:
                viewModel.changePlayStatus(as: .failed)
                print(".failed")
            case .unknown:
                print(".unknown")
                viewModel.changePlayStatus(as: .failed)
            @unknown default:
                print("@unknown default")
            }
        }
    }
    
    private func play(with url: URL) {
        setUpAsset(with: url) { [weak self] (asset: AVAsset) in
            self?.setUpPlayerItem(with: asset)
        }
    }
    
    private func playVideo() {
        interactionEnableStatus(as: true)
        guard let url = URL(string: videoURL) else { return }
        self.play(with: url)
    }
    
    private func interactionEnableStatus(as isActive: Bool) {
        self.isUserInteractionEnabled = isActive
    }
}

// MARK: ViewModel 호출 메소드
extension SpotLiveCameraView {
    private func changeReloadButtonActiveStatus(as active: Bool) {
        reloadButton.isHidden = !active
    }
}
