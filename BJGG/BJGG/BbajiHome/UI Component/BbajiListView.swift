//
//  BbajiListView.swift
//  BJGG
//
//  Created by 이재웅 on 2022/09/29.
//

import UIKit

protocol BbajiListViewDelegate {
    func pushBbajiSpotViewController()
}

class BbajiListView: UIView {
    var delegate: BbajiListViewDelegate?
    
    private var listWeatherArray: [ListWeather] = []
    private var listInfoArray: [ListInfo] = []
    
    func configure(_ listWeatherArray: [ListWeather], listInfoArray: [ListInfo]) {
        configureLayout()
        
        configureWeatherArray(listWeatherArray)
        configureInfoArray(listInfoArray)
        bbajiListCollectionView.reloadData()
    }
    
    private lazy var bbajiListCollectionView: BbajiListCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = BbajiListCollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BbajiListCell.self, forCellWithReuseIdentifier: BbajiListCell.id)
        
        collectionView.layer.cornerRadius = 10.0
        collectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        collectionView.layer.masksToBounds = true
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.backgroundColor = .bbagaGray4
        
        return collectionView
    }()
}

extension BbajiListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = UIDevice.current.hasNotch ? 201.38 : 196.0
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: BbajiConstraints.componentOffset, right: 0)
    }
    
}

extension BbajiListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UIDevice.current.hasNotch ? 2 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BbajiListCell.id, for: indexPath) as? BbajiListCell else { return UICollectionViewCell() }
        
        if indexPath.row < listWeatherArray.count && indexPath.row < listInfoArray.count {
            let weatherData = listWeatherArray[indexPath.row]
            let info = listInfoArray[indexPath.row]
            
            cell.configure(indexPath.row, locationName: info.locationName, bbajiName: info.name, backgroundImageName: info.backgroundImageName, iconName: weatherData.iconName, temp: weatherData.temp)
        } else {
            cell.configure(indexPath.row)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idx = indexPath.row
        if idx == 0 {
            delegate?.pushBbajiSpotViewController()
        }
    }
}

extension BbajiListView {
    func reloadCollectionView() {
        bbajiListCollectionView.reloadData()
    }
    
    private func configureLayout() {
        addSubview(bbajiListCollectionView)
        
        bbajiListCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureWeatherArray(_ listWeatherArray: [(ListWeather)]) {
        self.listWeatherArray = listWeatherArray
    }
    
    private func configureInfoArray(_ infoArray: [ListInfo]) {
        self.listInfoArray = infoArray
    }
}

typealias ListInfo = (locationName: String, name: String, backgroundImageName: String)
typealias ListWeather = (iconName: String, temp: String)
