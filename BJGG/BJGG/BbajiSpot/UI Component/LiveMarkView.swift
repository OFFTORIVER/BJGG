//
//  LiveMarkView.swift
//  BJGG
//
//  Created by 황정현 on 2023/03/04.
//

import UIKit

import UIKit

final class LiveMarkView: UIView {

    private var liveLabel: UILabel = UILabel()
    
    override init(frame: CGRect  =  CGRect()) {
        super.init(frame: frame)

        backgroundColor = UIColor.lightGray
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureLayout()
        configureComponent()
    }

    private func configureLayout() {
        addSubview(liveLabel)
        liveLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            liveLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            liveLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            liveLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            liveLabel.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    
    private func configureComponent() {
        liveLabel.textAlignment = .center
        liveLabel.text = "LIVE"
        liveLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        liveLabel.textColor = .clear
        
    }

    func setUpLiveLabelRadius(to: CGFloat) {
        self.layer.cornerRadius = to
    }
    
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
