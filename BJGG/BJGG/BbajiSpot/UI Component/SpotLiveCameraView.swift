//
//  SpotLiveCameraView.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/18.
//

import AVFoundation
import SnapKit
import UIKit

protocol SpotLiveCameraViewDelegate: AnyObject {
    func videoIsReadyToPlay()
}

final class SpotLiveCameraView: UIView {
    
    var controlStatus: ControlStatus = .hidden
    
    var videoPlayerControlView: SpotLiveCameraControlView = SpotLiveCameraControlView()
    var stanbyView: SpotLiveCameraStanbyView = SpotLiveCameraStanbyView()
    
    private let videoURL = BbajiInfo().getLiveCameraUrl()
    private lazy var reloadButton: UIButton = {
        let button = UIButton()
        
        let config = UIImage.SymbolConfiguration(pointSize: 45, weight: .regular, scale: .medium)
        let image = UIImage(systemName: "arrow.clockwise", withConfiguration: config)?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    
    weak var delegate: SpotLiveCameraViewDelegate?
    
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
    
    override init(frame: CGRect  =  CGRect()) {
        super.init(frame: frame)

        setUpLayout()
        componentConfigure()
        playVideo()
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
    
    private func setUpLayout() {
        
        self.backgroundColor = .black
        
        addSubview(videoPlayerControlView)
        videoPlayerControlView.snp.makeConstraints({ make in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        })
        
        videoPlayerControlView.alpha = 0.0
        changeReloadButtonActiveStatus(as: false)
        interactionEnableStatus(as: true)
        
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
    
    private func componentConfigure() {
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(touchVideoPlayerScreen))
        self.addGestureRecognizer(touchGesture)
        
        reloadButton.addTarget(self, action: #selector(pressedReloadButton), for: .touchUpInside)
        
        self.player?.rate = 30
        playerLayer.player?.currentItem?.automaticallyPreservesTimeOffsetFromLive = true
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
            
            stanbyView.changeStandbyView(as: status)
            switch status {
            case .readyToPlay:
                print(".readyToPlay")
                interactionEnableStatus(as: true)
                delegate?.videoIsReadyToPlay()
                player?.play()
            case .failed:
                interactionEnableStatus(as: false)
                changeReloadButtonActiveStatus(as: true)
                print(".failed")
            case .unknown:
                print(".unknown")
                interactionEnableStatus(as: false)
                changeReloadButtonActiveStatus(as: true)
            @unknown default:
                print("@unknown default")
            }
        }
    }
    
    func play(with url: URL) {
        setUpAsset(with: url) { [weak self] (asset: AVAsset) in
            self?.setUpPlayerItem(with: asset)
        }
    }
    
    func playVideo() {
        
        interactionEnableStatus(as: true)
        
        guard let url = URL(string: videoURL) else { return }
        self.play(with: url)
    }
    
    func pause() {
        playerLayer.player?.pause()
    }
    
    func replay() {
        playerLayer.player?.play()
    }
    
    func interactionEnableStatus(as isActive: Bool) {
        self.isUserInteractionEnabled = isActive
    }
    
    func changeReloadButtonActiveStatus(as active: Bool) {
        if active {
            reloadButton.isHidden = false
        } else {
            reloadButton.isHidden = true
        }
    }
    
    @objc private func touchVideoPlayerScreen() {
        controlStatus.changeControlStatus(view: videoPlayerControlView)
    }
    
    @objc private func pressedReloadButton() {
        self.playVideo()
        changeReloadButtonActiveStatus(as: false)
        stanbyView.configureLayout()
    }
}

extension SpotLiveCameraView {
    enum ControlStatus {
        case exist
        case hidden
        
        mutating func changeControlStatus(view: UIView) {
            switch self {
            case .exist:
                UIView.animate(withDuration: 0.2, delay: TimeInterval(0.0), animations: {
                    view.alpha = 0.0
                })
                self = .hidden
            case .hidden:
                UIView.animate(withDuration: 0.2, delay: TimeInterval(0.0), animations: {
                    view.alpha = 1.0
                })
                self = .exist
            }
        }
    }
}
