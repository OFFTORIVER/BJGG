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
    
    private var viewModel: SpotViewModel
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
    
    private func configure() {
        configureStyle()
        configureAction()
    }
    
    private func configureStyle() {
        let image = UIImage(systemName: "arrow.up.left.and.arrow.down.right")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        self.setImage(image, for: .normal)
    }
    
    private func configureAction() {
        self.tapPublisher.sink { [self] in
            viewModel.changeScreenSizeStatus()
        }.store(in: &cancellables)
    }
    
    private func bind(viewModel: SpotViewModel) {
        viewModel.screenSizeStatus.sink { [weak self] status in
            self?.setImage(status.changeButtonImage(), for: .normal)
        }.store(in: &cancellables)
    }
}
