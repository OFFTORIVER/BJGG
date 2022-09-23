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
        let defaultMargin: CGFloat = 20
        let defaultMargin2: CGFloat = 12
        
        let weatherAddressLabel = UILabel()
        
        self.addSubview(weatherAddressLabel)
        
        weatherAddressLabel.snp.makeConstraints({ make in
            make.leading.equalTo(self.snp.leading).inset(defaultMargin)
            make.top.equalTo(self.snp.top).inset(defaultMargin)
            make.height.equalTo(18)
        })
        
        labelSetting(label: weatherAddressLabel, text: "땡땡구 댕댕동", size: 15, weight: .medium, alignment: .left)
        
        let currentWeatherIconAndLabel = UIView()
        self.addSubview(currentWeatherIconAndLabel)
        
        currentWeatherIconAndLabel.snp.makeConstraints({ make in
            make.top.equalTo(weatherAddressLabel.snp.bottom).offset(defaultMargin2)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(160)
            make.height.equalTo(64)
        })
        
        currentWeatherIconAndLabel.backgroundColor = .black
        
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
        
        labelSetting(label: currentWeatherLabel, text: "23°", size: 48, weight: .heavy, alignment: .center)
        
        currentWeatherLabel.backgroundColor = .yellow
        currentWeatherIcon.backgroundColor = .cyan
        
        let rainInfoLabel = UILabel()
        self.addSubview(rainInfoLabel)
        
        rainInfoLabel.snp.makeConstraints({ make in
            make.top.equalTo(currentWeatherIconAndLabel.snp.bottom).offset(defaultMargin2)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(18)
        })
        
        labelSetting(label: rainInfoLabel, text: "오후 12시 경에 비가 올 예정이에요!", size: 15, weight: .medium, alignment: .center)
        
        let spotWeatherInfoViewDivideLine = UIView()
        self.addSubview(spotWeatherInfoViewDivideLine)
        spotWeatherInfoViewDivideLine.snp.makeConstraints({ make in
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(rainInfoLabel.snp.bottom).offset(defaultMargin)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(2)
        })
        
        spotWeatherInfoViewDivideLine.backgroundColor = .black
        
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
        spotTodayWeatherCollectionView.backgroundColor = .green
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
        cell.temperatureLabel.text = "23°"
        cell.timeLabel.text = "오후12시"
        
        if idx == 0 {
            cell.temperatureLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            cell.temperatureLabel.textAlignment = .center
            cell.timeLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            cell.timeLabel.textAlignment = .center
        } else {
            cell.temperatureLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            cell.temperatureLabel.textAlignment = .center
            cell.timeLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            cell.timeLabel.textAlignment = .center
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("CLICKED!")
    }
}

