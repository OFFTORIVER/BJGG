//
//  SpotInfoUIView.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/18.
//

import UIKit

final class SpotWeatherInfoView: UIView {
    
    private let currentTemperatureLabel = UILabel()
    private let currentWeatherIconAndLabel = UIView()
    private let currentWeatherIcon = UIImageView()
    private let spotWeatherInfoViewDivideLine = UIView()
    
    private var rainInfoLabel = UILabel()
    private let weatherAddressLabel = UILabel()
    private var spotTodayWeatherCollectionView: UICollectionView!
    private var currentWeatherInfo: [(time: String, iconName: String, temp: String, probability: String)] = []
    
    private var spotWeatherAPIInfoView: SpotWeatherAPIInfoView!

    override init(frame: CGRect) {
        
        super.init(frame: CGRect.zero)
        
        configure()
        
        registerCollectionView()
        setupCollectionViewDelegate()
        
        spotWeatherInfoViewComponentHidden(isHidden: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureLayout()
        configureStyle()
        configureComponent()
    }
    
    private func configureLayout() {
        
        self.addSubview(weatherAddressLabel)
        weatherAddressLabel.snp.makeConstraints({ make in
            make.leading.equalTo(self.snp.leading).inset(BbajiConstraints.viewInset)
            make.top.equalTo(self.snp.top).inset(BbajiConstraints.viewInset)
            make.height.equalTo(18)
        })
        
        self.addSubview(currentWeatherIconAndLabel)
        currentWeatherIconAndLabel.snp.makeConstraints({ make in
            make.top.equalTo(weatherAddressLabel.snp.bottom).offset(BbajiConstraints.componentOffset)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(160)
            make.height.equalTo(64)
        })
        
        [
            currentWeatherIcon,
            currentTemperatureLabel
        ].forEach {
            currentWeatherIconAndLabel.addSubview($0)
        }
        
        currentWeatherIcon.snp.makeConstraints({ make in
            make.leading.equalTo(currentWeatherIconAndLabel.snp.leading)
            make.top.equalTo(currentWeatherIconAndLabel.snp.top)
            make.centerY.equalTo(currentWeatherIconAndLabel.snp.centerY)
            make.width.height.equalTo(64)
        })
        
        currentTemperatureLabel.snp.makeConstraints({ make in
            make.leading.equalTo(currentWeatherIcon.snp.trailing).offset(BbajiConstraints.iconOffset)
            make.centerY.equalTo(currentWeatherIcon.snp.centerY)
            make.width.equalTo(100)
        })
        
        self.addSubview(rainInfoLabel)
        rainInfoLabel.snp.makeConstraints({ make in
            make.top.equalTo(currentWeatherIconAndLabel.snp.bottom).offset(BbajiConstraints.componentOffset)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(18)
        })
        
        self.addSubview(spotWeatherInfoViewDivideLine)
        spotWeatherInfoViewDivideLine.snp.makeConstraints({ make in
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(rainInfoLabel.snp.bottom).offset(BbajiConstraints.viewInset)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(2)
        })
        
        let collectionViewLayer = UICollectionViewFlowLayout()
        collectionViewLayer.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        collectionViewLayer.scrollDirection = .horizontal
        
        spotTodayWeatherCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayer)
        
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
        
        spotWeatherAPIInfoView.setDefaultUI()
    }
    
    private func configureComponent() {
        self.layer.cornerRadius = 16
        
        weatherAddressLabel.text = BbajiInfo().getCompactAddress()
        currentTemperatureLabel.text =  "--°"

    }
    
    private func configureStyle() {
        weatherAddressLabel.configureLabelStyle(font: .bbajiFont(.body1), alignment: .left)
        weatherAddressLabel.textColor = .bbagaGray2
        
        currentTemperatureLabel.configureLabelStyle(font: .bbajiFont(.heading1), alignment: .center)
        currentTemperatureLabel.textColor = .bbagaGray1
        
        rainInfoLabel.configureLabelStyle( font: .bbajiFont(.body1), alignment: .center)
        
        spotWeatherInfoViewDivideLine.backgroundColor = .bbagaBack
    }
    
    private func registerCollectionView() {
        spotTodayWeatherCollectionView.register(SpotTodayWeatherCollectionViewCell.self, forCellWithReuseIdentifier: SpotTodayWeatherCollectionViewCell.id)
    }
    
    private func setupCollectionViewDelegate() {
        spotTodayWeatherCollectionView.dataSource = self
        spotTodayWeatherCollectionView.delegate = self
    }
    
    func reloadWeatherData(weatherAPIIsSuccess: Bool, weatherInfoTuple:  [(time: String, iconName: String, temp: String, probability: String)]) {
        
        currentWeatherInfo = weatherInfoTuple
        if weatherAPIIsSuccess {
            UIView.animate(withDuration: 0.1, delay: 0.2, animations: {
                self.spotWeatherInfoViewComponentHidden(isHidden: false)
            })
            
            setCurrentWeatherImg()
            spotTodayWeatherCollectionView.reloadData()
        }
        spotWeatherAPIInfoView.setCurrentUI(weatherAPIIsSuccess: weatherAPIIsSuccess)
    }
    
    func setCurrentTemperatureLabelValue(temperatureStr: String) {
        currentTemperatureLabel.text = "\(temperatureStr)°"
    }
    
    func setRainInfoLabelTextAndColor(text: String) {
        let currentWeatherImgName = "\(currentWeatherInfo[0].iconName)"
        currentWeatherIcon.image = UIImage(named: currentWeatherImgName)
        
        rainInfoLabel.text = text
        let rainInfoLabelSplitText = rainInfoLabel.text?.components(separatedBy: "시")
        guard let timeDataStr = rainInfoLabelSplitText?[0] else { return }
        setRainInfoLabelColor(label: rainInfoLabel, timeStr: timeDataStr)
    }
    
    func spotWeatherInfoViewComponentHidden(isHidden: Bool) {
        [
            currentTemperatureLabel,
            currentWeatherIconAndLabel,
            rainInfoLabel,currentWeatherIcon,
            spotWeatherInfoViewDivideLine,
            spotTodayWeatherCollectionView
        ].forEach({
            $0?.isHidden = isHidden
        })
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
        
        var temperatureStr: String = ""
        var timeStr: String = ""
        var currentWeatherImgName: String = ""
        var currentRainPercentStr: String = ""

        if currentWeatherInfo.count > 0 {
            temperatureStr = "\(currentWeatherInfo[idx].temp)°"
            timeStr = currentWeatherInfo[idx].time
            currentRainPercentStr = currentWeatherInfo[idx].probability
            currentWeatherImgName = "\(currentWeatherInfo[idx].iconName)"
        } else {
            temperatureStr = "--°"
            timeStr = "--"
        }
        
        let isRain = currentRainPercentStr != "0%"
        let rainText = isRain ? currentRainPercentStr : ""
        cell.configureLayout(isRain: isRain)
        cell.componentConfigure(rainPercentText: rainText, tempText: temperatureStr, timeText: timeStr, weatherImage: currentWeatherImgName)
        cell.configureLabelStyle(index: idx)
        return cell
    }
}

extension SpotWeatherInfoView {
    func setRainInfoLabelColor(label: UILabel, timeStr: String) {
        
        label.textColor = .bbagaGray2
        guard let text = label.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttribute(.foregroundColor, value: UIColor.bbagaGray1, range: (text as NSString).range(of: "\(timeStr)시"))

        label.attributedText = attributedString
    }
    
    func setCurrentWeatherImg() {
        let currentWeatherImgName = "\(currentWeatherInfo[0].iconName)"
        currentWeatherIcon.image = UIImage(named: currentWeatherImgName)
    }
}

