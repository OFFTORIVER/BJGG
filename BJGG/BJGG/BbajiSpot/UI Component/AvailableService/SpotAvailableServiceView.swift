//
//  SpotAvailableServiceView.swift
//  BJGG
//
//  Created by 황정현 on 2023/05/10.
//

import UIKit

final class SpotAvailableServiceView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: UIFont.Pretendard.bold.rawValue, size: 14.0) ?? UIFont()
        label.textAlignment = .left
        label.textColor = .bbagaGray1
        label.text = "이용 가능한 서비스"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureLayout()
        configureStyle()
        bind()
    }
    
    private func configureLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ make in
            make.top.equalTo(self.snp.top).offset(BbajiConstraints.viewInset)
            make.leading.equalTo(self.snp.leading).offset(BbajiConstraints.viewInset)
            make.trailing.equalTo(self.snp.trailing).offset(BbajiConstraints.viewInset)
            make.width.equalTo(17)
        })
    }
    
    private func configureStyle() {
        backgroundColor = .bbagaGray4
    }
    
    private func configureComponent(serviceInfoList: [BbajiServiceInfo]) {
        
        var standardView: ServiceInfoDescriptionView?
        for serviceInfo in serviceInfoList {
            let view = ServiceInfoDescriptionView()
            
            addSubview(view)
            view.snp.makeConstraints({ make in
                make.bottom.equalTo(self.snp.bottom).offset(-BbajiConstraints.viewInset)
                make.width.equalTo(32)
                make.height.equalTo(50)
            })
            
            if let standardView = standardView {
                view.snp.makeConstraints({
                    $0.leading.equalTo(standardView.snp.trailing).offset(BbajiConstraints.viewInset)
                })
            }
            else {
                view.snp.makeConstraints({
                    $0.leading.equalTo(self.snp.leading).offset(BbajiConstraints.viewInset)
                })
            }
            
            view.configureComponent(serviceInfo: serviceInfo)
            standardView = view
        }
        
    }
    func bind() {
        
        // TODO: Networking Result Receive
        let providedServiceInfoList: [BbajiServiceInfo] = [
            BbajiServiceInfo.lockerRoom,
            BbajiServiceInfo.buoy,
        ]
        
        configureComponent(serviceInfoList: providedServiceInfoList)
    }
}
