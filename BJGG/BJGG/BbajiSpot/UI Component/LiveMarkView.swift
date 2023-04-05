//
//  LiveMarkView.swift
//  BJGG
//
//  Created by 황정현 on 2023/03/04.
//

import Combine
import UIKit
import SnapKit

final class LiveMarkView: UIView {

    private lazy var liveLabel: UILabel = {
        let label = UILabel()
        label.configureLabelStyle(font: .systemFont(ofSize: 12, weight: .medium), alignment: .center)
        label.textColor = .clear
        label.text = "LIVE"
        return label
    }()
    
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
    
    private func configure() {
        configureLayout()
        configureStyle()
    }

    private func configureLayout() {
        addSubview(liveLabel)
        liveLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(self.snp.height)
        }
    }
    
    private func configureStyle() {
        backgroundColor = UIColor.lightGray
    }
    
    private func bind(viewModel: SpotViewModel) {
        viewModel.readyToPlay.sink { [weak self] status in
            if status == .readyToPlay {
                self?.liveMarkActive(to: true)
            } else {
                self?.liveMarkActive(to: false)
            }
            
        }.store(in: &cancellables)
    }
    
    func setUpLiveLabelRadius(to: CGFloat) {
        self.layer.cornerRadius = to
    }
}

// MARK: ViewModel 호출 메소드
extension LiveMarkView {
    func liveMarkActive(to active: Bool) {
        let currentColor = backgroundColor
        var targetBackgroundColor: UIColor? = currentColor
        var targetLabelColor: UIColor?
        
        if active {
            targetBackgroundColor = UIColor(rgb: 0xE17481)
            targetLabelColor = .white
        } else {
            targetBackgroundColor = .clear
            targetLabelColor = .clear
            liveLabel.textColor = targetLabelColor
        }
        
        UIView.animate(withDuration: 0.7, delay: 0.3, animations: {
            self.backgroundColor = targetBackgroundColor
            self.liveLabel.textColor = targetLabelColor
            self.isHidden = !active
        })
    }

}
