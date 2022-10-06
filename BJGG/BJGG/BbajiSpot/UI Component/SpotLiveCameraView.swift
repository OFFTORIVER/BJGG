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
    var avpController = AVPlayerViewController()
    private var url: URL!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        url = URL(string: BbajiInfo().getLiveCameraUrl())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func liveCameraSetting(size: CGSize) {
        player = AVPlayer(url: url!)
        avpController.player = player
        avpController.view.frame.size.height = size.height
        avpController.view.frame.size.width = size.width
        self.addSubview(avpController.view)
        player?.play()
    }

}
