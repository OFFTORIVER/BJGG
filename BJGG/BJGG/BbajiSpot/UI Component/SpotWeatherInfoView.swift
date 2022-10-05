//
//  SpotInfoUIView.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/18.
//

import UIKit

final class SpotWeatherInfoView: UIView {
    
    let currentWeatherIcon = UIImageView()
    private let currentTemperatureLabel = UILabel()
    
    private let currentWeatherIconAndLabel = UIView()
    private let currentWeatherIcon = UIImageView()
    private let spotWeatherInfoViewDivideLine = UIView()
    
    var rainInfoLabel = UILabel()
    private var spotTodayWeatherCollectionView: SpotTodayWeatherCollectionView!
    private var currentWeatherInfo: [(time: String, iconName: String, temp: String, probability: String)]!
    
    private var spotWeatherAPIInfoView: SpotWeatherAPIInfoView!

    required init(weatherInfo: [(time: String, iconName: String, temp: String, probability: String)]) {
        
        super.init(frame: CGRect.zero)
        
        layoutConfigure()
        
        registerCollectionView()
        setupCollectionViewDelegate()
        
        // currentTimeNTemperatureInfo = timeNTempInfo
        
        spotWeatherInfoViewComponentHidden(isHidden: true)
        currentWeatherInfo = weatherInfo
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
        
        labelSetting(label: weatherAddressLabel, text: BbajiInfo().getCompactAddress(), font: .bbajiFont(.body1), alignment: .left)
        weatherAddressLabel.textColor = .bbagaGray2
        
        self.addSubview(currentWeatherIconAndLabel)
        
        currentWeatherIconAndLabel.snp.makeConstraints({ make in
            make.top.equalTo(weatherAddressLabel.snp.bottom).offset(defaultMargin2)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(160)
            make.height.equalTo(64)
        })
        
        [currentWeatherIcon, currentTemperatureLabel].forEach({
            currentWeatherIconAndLabel.addSubview($0)
        })
        
        currentWeatherIcon.snp.makeConstraints({ make in
            make.leading.equalTo(currentWeatherIconAndLabel.snp.leading)
            make.top.equalTo(currentWeatherIconAndLabel.snp.top)
            make.centerY.equalTo(currentWeatherIconAndLabel.snp.centerY)
            make.width.height.equalTo(64)
        })
        
        currentTemperatureLabel.snp.makeConstraints({ make in
            make.leading.equalTo(currentWeatherIcon.snp.trailing).offset(CGFloat.iconOffset)
            make.centerY.equalTo(currentWeatherIcon.snp.centerY)
            make.width.equalTo(100)
        })
        
        labelSetting(label: currentTemperatureLabel, text: "--°", font: .bbajiFont(.heading1), alignment: .center)
        
        currentTemperatureLabel.textColor = .bbagaGray1
        
        self.addSubview(rainInfoLabel)
        
        rainInfoLabel.snp.makeConstraints({ make in
            make.top.equalTo(currentWeatherIconAndLabel.snp.bottom).offset(defaultMargin2)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(18)
        })
        
        labelSetting(label: rainInfoLabel, text: "", font: .bbajiFont(.body1), alignment: .center)
        
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
        
        spotTodayWeatherCollectionView.layer.cornerRadius = 16
        spotTodayWeatherCollectionView.backgroundColor = .bbagaGray4
        
        spotWeatherAPIInfoView = SpotWeatherAPIInfoView()
        self.addSubview(spotWeatherAPIInfoView)
        
        spotWeatherAPIInfoView.snp.makeConstraints({ make in
            make.left.right.top.bottom.equalTo(self)
        })
        
        spotWeatherAPIInfoView.setCurrentUI(apiStatus: APIStatus.loading)
    }
    
    private func registerCollectionView() {
        spotTodayWeatherCollectionView.register(SpotTodayWeatherCollectionViewCell.self, forCellWithReuseIdentifier: SpotTodayWeatherCollectionViewCell.id)
    }
    
    private func setupCollectionViewDelegate() {
        spotTodayWeatherCollectionView.dataSource = self
        spotTodayWeatherCollectionView.delegate = self
    }
    
    func reloadWeatherData(apiStatus: APIStatus, timeNTempInfo: [(time: String, temperature: String)]) {
        
        currentTimeNTemperatureInfo = timeNTempInfo
        spotTodayWeatherCollectionView.reloadData()
        spotTodayWeatherCollectionView.reloadItems(at: spotTodayWeatherCollectionView.indexPathsForVisibleItems)
        if apiStatus == .success {
            UIView.animate(withDuration: 0.1, delay: 0.2, animations: {
                self.spotWeatherInfoViewComponentHidden(isHidden: false)
            })
        }
        spotWeatherAPIInfoView.setCurrentUI(apiStatus: apiStatus)
    }
    
    func setCurrentTemperatureLabelValue(temperatureStr: String) {
        currentTemperatureLabel.text = "\(temperatureStr)°"
    }
    
    func setRainInfoLabelTextAndColor(text: String) {
        rainInfoLabel.text = text
        let rainInfoLabelSplitText = rainInfoLabel.text?.components(separatedBy: "시")
        guard let timeDataStr = rainInfoLabelSplitText?[0] else { return }
        makeTimeAsBlackColor(label: rainInfoLabel, timeStr: timeDataStr)
    }
    
    func spotWeatherInfoViewComponentHidden(isHidden: Bool) {
        [currentTemperatureLabel, currentWeatherIconAndLabel,
         rainInfoLabel,currentWeatherIcon, spotWeatherInfoViewDivideLine,  spotTodayWeatherCollectionView].forEach({ $0?.isHidden = isHidden})
    }
}

extension SpotWeatherInfoView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 58, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpotTodayWeatherCollectionViewCell.id, for: indexPath) as! SpotTodayWeatherCollectionViewCell
        
        let idx = indexPath.row
        
        let currentRainPercent = currentWeatherInfo[idx].probability
        if currentRainPercent == "0" {
            cell.layoutConfigure(isRain: false)
        } else {
            cell.layoutConfigure(isRain: true)
            let currentRainPercentStr = currentWeatherInfo[idx].probability
            labelSetting(label: cell.currentRainPercentLabel, text: currentRainPercentStr, font: .bbajiFont(.rainyCaption), alignment: .center)
            cell.currentRainPercentLabel.textColor = .bbagaRain
        }
        
        let currentWeatherImgName = "\(currentWeatherInfo[idx].iconName)"
        cell.currentWeatherImgView.image = UIImage(named: currentWeatherImgName)
        
        var temperatureStr: String = ""
        var timeStr: String = ""
        if currentTimeNTemperatureInfo.count > 0 {
            temperatureStr = "\(currentTimeNTemperatureInfo[idx].temperature)°"
            timeStr = currentTimeNTemperatureInfo[idx].time
        } else {
            temperatureStr = "--°"
            timeStr = "--"
        }
        
        labelSetting(label: cell.temperatureLabel, text: temperatureStr, font: .bbajiFont(.heading5), alignment: .center)
        labelSetting(label: cell.timeLabel, text: timeStr, font: .bbajiFont(.body1), alignment: .center)
        if idx == 0 {
            cell.temperatureLabel.font = UIFont(name: UIFont.Pretendard.bold.rawValue, size: 20.0) ?? UIFont()
            cell.timeLabel.font = UIFont(name: UIFont.Pretendard.bold.rawValue, size: 15.0) ?? UIFont()
            cell.temperatureLabel.textColor = .bbagaGray1
            cell.timeLabel.textColor = .bbagaGray1
        } else {
            cell.temperatureLabel.textColor = .bbagaGray2
            cell.timeLabel.textColor = .bbagaGray2
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("CLICKED!")
    }
}

extension SpotWeatherInfoView {
    func makeTimeAsBlackColor(label: UILabel, timeStr: String) {
        // label 전체 텍스트의 기본 컬러를 bbagaGray2로 설정
        label.textColor = .bbagaGray2
        guard let text = label.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        
        // label 일부분에 입힐 컬러를 bbagaGray1으로 설정
        attributedString.addAttribute(.foregroundColor, value: UIColor.bbagaGray1, range: (text as NSString).range(of: "\(timeStr)시"))
        let currentWeatherImgName = "\(currentWeatherInfo[0].iconName)"
        currentWeatherIcon.image = UIImage(named: currentWeatherImgName)
        // label에 Color 입히기
        label.attributedText = attributedString
    }
    
    func setCurrentWeatherImg() {
        let currentWeatherImgName = "\(currentWeatherInfo[0].iconName)"
        currentWeatherIcon.image = UIImage(named: currentWeatherImgName)
    }
}

