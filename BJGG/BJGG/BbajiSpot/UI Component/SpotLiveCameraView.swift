//
//  LiveCameraView.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/18.
//

import UIKit
import AVKit

final class SpotLiveCameraView: UIView {
    private var player: AVPlayer?
    var avpController = RotatableAVPlayerViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func liveCameraSetting(size: CGSize) {
        let url = URL(string: BbajiInfo().getLiveCameraUrl())
        player = AVPlayer(url: url!)
        avpController.player = player
        avpController.view.frame.size.height = size.height
        avpController.view.frame.size.width = size.width
        self.addSubview(avpController.view)
        player?.play()
    }

}

class RotatableAVPlayerViewController: AVPlayerViewController {
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
             return .landscapeRight
          }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
}
