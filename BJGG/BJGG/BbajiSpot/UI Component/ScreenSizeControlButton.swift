//
//  ScreenSizeControlButton.swift
//  BJGG
//
//  Created by 황정현 on 2023/03/04.
//

import Combine
import CombineCocoa
import UIKit

final class ScreenSizeControlButton: UIButton {
    
    private var spotLiveCameraViewModel: SpotLiveCameraViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    init(spotLiveCameraViewModel: SpotLiveCameraViewModel?) {
        super.init(frame: CGRect.zero)
        self.spotLiveCameraViewModel = spotLiveCameraViewModel
        configure()
        bind(viewModel: spotLiveCameraViewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureStyle()
    }
    
    private func configureStyle() {
        let image = UIImage(systemName: "arrow.up.left.and.arrow.down.right")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        self.setImage(image, for: .normal)
    }
    
    private func bind(viewModel: SpotLiveCameraViewModel?) {
        let input = SpotLiveCameraViewModel.Input(
            cameraViewTapPublisher: nil,
            reloadButtonTapPublisher: nil,
            screenSizeButtonTapPublisher:  self.tapPublisher,
            playStatus: nil
        )

        _ = viewModel?.transform(input: input)
        
        viewModel?.$screenSizeStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.setImage(status.changeButtonImage(), for: .normal)
            }.store(in: &cancellables)
    }
}
