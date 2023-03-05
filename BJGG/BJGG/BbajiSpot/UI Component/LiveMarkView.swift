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
        setUpLayout()
        componentConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        addSubview(liveLabel)
        liveLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            liveLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            liveLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            liveLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            liveLabel.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
    }
    
    private func componentConfigure() {
        liveLabel.textAlignment = .center
        liveLabel.text = "LIVE"
        liveLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }

    func setUpLiveLabelRadius(to: CGFloat) {
        self.layer.cornerRadius = to
    }
    
    func liveMarkColorActive(to active: Bool) {
        let currentColor = backgroundColor
        var targetColor: UIColor? = currentColor
        
        if active {
            targetColor = UIColor(rgb: 0xE17481)
        } else {
            targetColor = UIColor.lightGray
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = targetColor
        })
    }
}
