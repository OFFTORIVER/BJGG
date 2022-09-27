//
//  SpotInfoUIView.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/18.
//

import UIKit

final class SpotWeatherInfoView: UIView {
    private var spotTodayWeatherCollectionView: SpotTodayWeatherCollectionView!
    
    required override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        layoutConfigure()
        
        registerCollectionView()
        setupCollectionViewDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutConfigure() {
        let defaultMargin: CGFloat = .viewInset
        let defaultMargin2: CGFloat = .componentOffset
        
        let weatherAddressLabel = UILabel()
        
        self.addSubview(weatherAddressLabel)
        
        weatherAddressLabel.snp.makeConstraints({ make in
            make.leading.equalTo(self.snp.leading).inset(defaultMargin)
            make.top.equalTo(self.snp.top).inset(defaultMargin)
            make.height.equalTo(18)
        })
        
        labelSetting(label: weatherAddressLabel, text: "땡땡구 댕댕동", font: .bbajiFont(.body1), alignment: .left)
        weatherAddressLabel.textColor = .bbagaGray2
        
        let currentWeatherIconAndLabel = UIView()
        self.addSubview(currentWeatherIconAndLabel)
        
        currentWeatherIconAndLabel.snp.makeConstraints({ make in
            make.top.equalTo(weatherAddressLabel.snp.bottom).offset(defaultMargin2)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(160)
            make.height.equalTo(64)
        })
        
        let currentWeatherIcon = UIImageView()
        let currentWeatherLabel = UILabel()
        
        [currentWeatherIcon, currentWeatherLabel].forEach({
            currentWeatherIconAndLabel.addSubview($0)
        })
        
        currentWeatherIcon.snp.makeConstraints({ make in
            make.leading.equalTo(currentWeatherIconAndLabel.snp.leading)
            make.top.equalTo(currentWeatherIconAndLabel.snp.top)
            make.centerY.equalTo(currentWeatherIconAndLabel.snp.centerY)
            make.width.height.equalTo(64)
        })
        
        currentWeatherLabel.snp.makeConstraints({ make in
            make.trailing.equalTo(currentWeatherIconAndLabel.snp.trailing)
            make.centerY.equalTo(currentWeatherIcon.snp.centerY)
            make.width.equalTo(160 - 64)
        })
        
        labelSetting(label: currentWeatherLabel, text: "23°", font: .bbajiFont(.heading1), alignment: .center)
        
        currentWeatherLabel.textColor = .bbagaGray1
        
        let rainInfoLabel = UILabel()
        self.addSubview(rainInfoLabel)
        
        rainInfoLabel.snp.makeConstraints({ make in
            make.top.equalTo(currentWeatherIconAndLabel.snp.bottom).offset(defaultMargin2)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(18)
        })
        
        labelSetting(label: rainInfoLabel, text: "오후 12시 경에 비가 올 예정이에요!", font: .bbajiFont(.body1), alignment: .center)
        
        let spotWeatherInfoViewDivideLine = UIView()
        self.addSubview(spotWeatherInfoViewDivideLine)
        spotWeatherInfoViewDivideLine.snp.makeConstraints({ make in
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(rainInfoLabel.snp.bottom).offset(defaultMargin)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(2)
        })
        
        spotWeatherInfoViewDivideLine.backgroundColor = .bbagaBack
        
        self.layer.cornerRadius = 16
        
        let collectionViewLayer = UICollectionViewFlowLayout()
        collectionViewLayer.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        collectionViewLayer.scrollDirection = .horizontal
        
        spotTodayWeatherCollectionView = SpotTodayWeatherCollectionView(frame: .zero, collectionViewLayout: collectionViewLayer)
        
        self.addSubview(spotTodayWeatherCollectionView)
        spotTodayWeatherCollectionView.snp.makeConstraints({ make in
            make.top.equalTo(spotWeatherInfoViewDivideLine.snp.bottom)
            make.bottom.equalTo(self.snp.bottom)
            make.leading.equalTo(self.snp.leading)
            make.centerX.equalTo(self.snp.centerX)
        })
    }
    
    private func registerCollectionView() {
        spotTodayWeatherCollectionView.register(SpotTodayWeatherCollectionViewCell.self, forCellWithReuseIdentifier: SpotTodayWeatherCollectionViewCell.id)
    }
    
    private func setupCollectionViewDelegate() {
        spotTodayWeatherCollectionView.dataSource = self
        spotTodayWeatherCollectionView.delegate = self
    }
}

extension SpotWeatherInfoView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpotTodayWeatherCollectionViewCell.id, for: indexPath) as! SpotTodayWeatherCollectionViewCell
        
        let idx = indexPath.row
        cell.currentWeatherImgView = UIImageView()
        labelSetting(label: cell.temperatureLabel, text: "23°", font: .bbajiFont(.heading5), alignment: .center)
        labelSetting(label: cell.timeLabel, text: "오후12시", font: .bbajiFont(.body1), alignment: .center)
        if idx == 0 {
            cell.temperatureLabel.font = UIFont(name: UIFont.Pretendard.bold.rawValue, size: 20.0) ?? UIFont()
            cell.timeLabel.font = UIFont(name: UIFont.Pretendard.bold.rawValue, size: 15.0) ?? UIFont()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("CLICKED!")
    }
}

