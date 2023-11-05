//
//  SpotViewController.swift
//  BJGG
//
//  Created by 황정현 on 2022/09/18.
//

import Combine
import UIKit
import SnapKit

final class BbajiSpotViewController: UIViewController {
    
    lazy var liveCameraView = SpotLiveCameraView(spotViewModel: spotViewModel ?? SpotViewModel(), liveCameraViewModel: liveCameraViewModel ?? SpotLiveCameraViewModel())
    private let infoScrollView = UIScrollView()
    private let infoScrollContentView = UIView()
    private lazy var spotInfoView: SpotInfoView = {
        let view = SpotInfoView(infoViewModel: SpotInfoViewModel(info: BbajiInfo()))
        view.backgroundColor = .bbagaGray4
        return view
    }()
    
    private lazy var spotAvailableServiceView: SpotAvailableServiceView = {
        let view = SpotAvailableServiceView()
        return view
    }()
    
    private var spotWeatherInfoView: SpotWeatherInfoView = {
        let view = SpotWeatherInfoView()
        view.backgroundColor = .bbagaGray4
        return view
    }()
    
    private lazy var liveMarkView: LiveMarkView = {
        let view = LiveMarkView(liveCameraViewModel: liveCameraViewModel ?? SpotLiveCameraViewModel())
        view.setUpLiveLabelRadius(to: screenWidth / 36)
        return view
    }()
    
    private var screenWidth: CGFloat = CGFloat()
    private var firstAttempt: Bool = true
    
    private var infoViewModel: SpotInfoViewModel?
    var weatherViewModel: SpotWeatherViewModel?
    private var spotViewModel: SpotViewModel?
    private var liveCameraViewModel: SpotLiveCameraViewModel?
    
    private var cancellables = Set<AnyCancellable>()

    init(
        infoViewModel: SpotInfoViewModel,
        weatherViewModel: SpotWeatherViewModel = SpotWeatherViewModel(),
        spotViewModel: SpotViewModel = SpotViewModel(),
        liveCameraViewModel: SpotLiveCameraViewModel = SpotLiveCameraViewModel()
    ) {
        super.init(nibName: nil, bundle: nil)
        self.infoViewModel = infoViewModel
        self.weatherViewModel = weatherViewModel
        self.spotViewModel = spotViewModel
        self.liveCameraViewModel = liveCameraViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        liveCameraView.stanbyView.stopLoadingAnimation()
    }
    
    override var prefersStatusBarHidden: Bool {
        var isStatusBarHidden = false
        liveCameraViewModel?.$screenSizeStatus.sink { status in
            switch status {
            case .full:
                isStatusBarHidden = true
            case .normal, .origin:
                isStatusBarHidden = false
            }
        }.store(in: &cancellables)
        return isStatusBarHidden
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        var isHomeIndicatorAutoHidden = false
        liveCameraViewModel?.$screenSizeStatus.sink { status in
            switch status {
            case .full:
                isHomeIndicatorAutoHidden = true
            case .normal, .origin:
                isHomeIndicatorAutoHidden = false
            }
        }.store(in: &cancellables)
       return isHomeIndicatorAutoHidden
    }
    
    private func configure() {
        configureLayout()
        configureStyle()
        configureComponent()
        bind()
    }
    
    private func configureLayout() {
        
        let safeArea = view.safeAreaLayoutGuide
        let viewWidth = UIScreen.main.bounds.width
        let liveCameraViewHeight = viewWidth * 9 / 16
        screenWidth = viewWidth

        view.addSubview(liveCameraView)
        liveCameraView.snp.makeConstraints { make in
            make.centerX.equalTo(safeArea.snp.centerX)
            make.top.equalTo(safeArea.snp.top)
            make.width.equalTo(safeArea.snp.width)
            make.height.equalTo(liveCameraViewHeight)
        }
        
        view.addSubview(liveMarkView)
        liveMarkView.snp.makeConstraints { make in
            make.leading.equalTo(liveCameraView.snp.leading).inset(8)
            make.top.equalTo(liveCameraView.snp.top).inset(8)
            make.width.equalTo(screenWidth / 8)
            make.height.equalTo(screenWidth / 18)
        }
        
        view.addSubview(infoScrollView)
        infoScrollView.snp.makeConstraints { make in
            make.top.equalTo(liveCameraView.snp.bottom)
            make.leading.equalTo(safeArea.snp.leading)
            make.trailing.equalTo(safeArea.snp.trailing)
            make.bottom.equalTo(safeArea.snp.bottom)
        }
        
        infoScrollView.addSubview(infoScrollContentView)
        infoScrollContentView.snp.makeConstraints { make in
            make.top.equalTo(infoScrollView.snp.top)
            make.bottom.equalTo(infoScrollView.snp.bottom)
            make.centerX.equalTo(safeArea.snp.centerX)
            make.width.equalTo(safeArea.snp.width)
            make.height.equalTo(UIDevice.current.hasNotch ? 631 : 631 - 32)
        }
        infoScrollView.showsVerticalScrollIndicator = false
        
        [
            spotInfoView,
            spotAvailableServiceView,
            spotWeatherInfoView
        ].forEach { infoScrollContentView.addSubview($0) }

        spotInfoView.snp.makeConstraints { make in
            make.top.equalTo(infoScrollContentView.snp.top)
            make.leading.equalTo(infoScrollContentView.snp.leading)
            make.trailing.equalTo(infoScrollContentView.snp.trailing)
            make.height.equalTo(108 + BbajiConstraints.viewInset * 4)
        }

        spotAvailableServiceView.snp.makeConstraints { make in
                make.top.equalTo(spotInfoView.snp.bottom).offset(BbajiConstraints.space6)
                make.leading.equalTo(infoScrollContentView.snp.leading)
                make.trailing.equalTo(infoScrollContentView.snp.trailing)
                make.height.equalTo(123)
        }
        spotWeatherInfoView.snp.makeConstraints { make in
            make.top.equalTo(spotAvailableServiceView.snp.bottom).offset(BbajiConstraints.space6)
            make.leading.equalTo(infoScrollContentView.snp.leading)
            make.trailing.equalTo(infoScrollContentView.snp.trailing)
            make.height.equalTo(UIDevice.current.hasNotch ? 311 : 295)
        }
    }
    
    private func configureStyle() {
        view.backgroundColor = .bbagaBack
    }
    
    func configureComponent() {
        liveMarkView.liveMarkActive(to: false)
        setUpLiveCameraViewConstraints(screenStatus: .normal)
    }
    
    private func bind() {
        weatherViewModel?.$weatherData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weatherData in
                guard let self = self,
                      let weatherData = weatherData else { return }
                self.spotWeatherInfoView.reloadWeatherData(weatherAPIIsSuccess: true, weatherData: weatherData)
                self.spotWeatherInfoView.setCurrentTemperatureLabelValue(temperatureStr: weatherData[0].temp)
            }.store(in: &cancellables)
        
        weatherViewModel?.$rainData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rainData in
                guard let self = self,
                let rainData = rainData else { return }
                self.spotWeatherInfoView.setRainInfoLabelTextAndColor(text: rainData)
            }.store(in: &cancellables)
        
        liveCameraViewModel?.$screenSizeStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                if status == .origin { return }
                self?.changeScreenSize(screenSizeStatus: status)
        }.store(in: &cancellables)
        
        let input = SpotViewModel.Input(
            willEnterForeground: NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification), didEnterBackground: NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
        )
        
        guard let output = spotViewModel?.transform(input: input) else { return }
        
        output.willEnterForeground
            .receive(on: DispatchQueue.main)
            .sink { [weak self] willEnterForeground in
                if willEnterForeground {
                    self?.liveCameraView.changePlayStatus(as: .origin)
                } else {
                    self?.liveMarkView.liveMarkActive(to: false)
                    self?.liveCameraView.stanbyView.stopLoadingAnimation()
                }
            }.store(in: &cancellables)
        
        spotViewModel?.isNetworkConnected()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isNetworkConnected in
                guard let isNetworkConnected = isNetworkConnected else { return }
                if isNetworkConnected {
                    self?.dismissPresentedAlert()
                    self?.weatherViewModel?.receiveBbajiWeatherData()
                } else {
                    self?.showNetworkStatusAlert()
                }
            }.store(in: &cancellables)
    }
    
    private func setUpLiveCameraViewConstraints(screenStatus: ScreenSizeStatus) {
        
        let safeArea = view.safeAreaLayoutGuide
        liveCameraView.snp.removeConstraints()
        liveMarkView.snp.removeConstraints()
        
        switch screenStatus {
        case .normal, .origin:
            let liveCameraViewHeight = screenWidth * 9 / 16
            
            liveCameraView.snp.makeConstraints { make in
                make.centerX.equalTo(safeArea.snp.centerX)
                make.top.equalTo(safeArea.snp.top)
                make.width.equalTo(safeArea.snp.width)
                make.height.equalTo(liveCameraViewHeight)
            }
            
            liveMarkView.snp.makeConstraints { make in
                make.leading.equalTo(liveCameraView.snp.leading).offset(8)
                make.top.equalTo(liveCameraView.snp.top).offset(8)
                make.width.equalTo(screenWidth / 8)
                make.height.equalTo(screenWidth / 18)
            }
        case .full:
            let liveCameraviewHeight = UIScreen.main.bounds.width
            let liveCameraViewWidth = liveCameraviewHeight * 16 / 9
            
            liveCameraView.snp.makeConstraints { make in
                make.top.equalTo(view.snp.top)
                make.bottom.equalTo(view.snp.bottom)
                make.centerX.equalTo(safeArea.snp.centerX)
                make.width.equalTo(liveCameraViewWidth)
            }
            
            liveMarkView.snp.makeConstraints { make in
                make.leading.equalTo(liveCameraView.snp.leading).offset(16)
                make.top.equalTo(liveCameraView.snp.top).offset(16)
                make.width.equalTo(screenWidth / 8)
                make.height.equalTo(screenWidth / 18)
            }
        }
    }
}

extension BbajiSpotViewController
{
    func changeScreenSize(screenSizeStatus: ScreenSizeStatus) {
        var infoViewAlphaValue: CGFloat = 1.0
        var backgroundColor: UIColor = .bbagaBack
        var orientationValue: String = "portrait"
        var navigationBarHiddenStatus: Bool = false
        switch screenSizeStatus {
        case .normal, .origin:
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = .portrait
            }
        case .full:
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = .landscapeRight
            }
            
            infoViewAlphaValue = 0.0
            orientationValue = "landscapeRight"
            backgroundColor = .black
            navigationBarHiddenStatus = true
        }
        
        if #available(iOS 16.0, *) {
            self.setNeedsUpdateOfSupportedInterfaceOrientations()
        } else {
            UIDevice.current.setValue(orientationValue, forKey: "orientation")
        }
        
        navigationController?.setNavigationBarHidden(navigationBarHiddenStatus, animated: true)
        
        setUpLiveCameraViewConstraints(screenStatus: screenSizeStatus)
        UIView.animate(withDuration: 0.3, delay: TimeInterval(0.0), animations: { [self] in
            infoScrollView.alpha = infoViewAlphaValue
            view.backgroundColor = backgroundColor
            view.layoutIfNeeded()
        })
    }
}
