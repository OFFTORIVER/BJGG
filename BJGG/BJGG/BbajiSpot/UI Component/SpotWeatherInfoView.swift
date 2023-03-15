//
//  SpotInfoUIView.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/18.
//

import UIKit

// MARK: 비상. 코드 짱 더러움
final class SpotWeatherInfoView: UIView {
    
    private let currentTemperatureLabel = UILabel()
    private let currentWeatherIconAndLabel = UIView()
    private let currentWeatherIcon = UIImageView()
    private let spotWeatherInfoViewDivideLine = UIView()
    
    var rainInfoLabel = UILabel()
    private let weatherAddressLabel = UILabel()
    private var spotTodayWeatherCollectionView: SpotTodayWeatherCollectionView!
    private var currentWeatherInfo: [(time: String, iconName: String, temp: String, probability: String)] = []
    
    private var spotWeatherAPIInfoView: SpotWeatherAPIInfoView!

    required init() {
        
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
    
    private func configureComponent() {
        self.layer.cornerRadius = 16
        
        weatherAddressLabel.text = BbajiInfo().getCompactAddress()
        weatherAddressLabel.textColor = .bbagaGray2
        
        currentTemperatureLabel.text =  "--°"
        currentTemperatureLabel.textColor = .bbagaGray1
        
        spotWeatherInfoViewDivideLine.backgroundColor = .bbagaBack
    }
    
    private func configureStyle() {
        weatherAddressLabel.configureLabelStyle(font: .bbajiFont(.body1), alignment: .left)
        currentTemperatureLabel.configureLabelStyle(font: .bbajiFont(.heading1), alignment: .center)
        rainInfoLabel.configureLabelStyle( font: .bbajiFont(.body1), alignment: .center)
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
        
        spotWeatherAPIInfoView.setDefaultUI()
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
        
        if currentRainPercentStr == "0%" {
            cell.configureLayout(isRain: false)
            cell.currentRainPercentLabel.text = ""
        } else {
            cell.configureLayout(isRain: true)
            
            cell.currentRainPercentLabel.configureLabelStyle(font: .bbajiFont(.rainyCaption), alignment: .center)
            cell.currentRainPercentLabel.text = currentRainPercentStr
            cell.currentRainPercentLabel.textColor = .bbagaRain
            
        }
        
        if currentWeatherImgName != "" {
            cell.currentWeatherImgView.image = UIImage(named: currentWeatherImgName)
        }
        
        cell.temperatureLabel.configureLabelStyle(font: .bbajiFont(.heading5), alignment: .center)
        cell.temperatureLabel.text = temperatureStr
        cell.timeLabel.configureLabelStyle(font: .bbajiFont(.body1), alignment: .center)
        cell.timeLabel.text = timeStr

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

