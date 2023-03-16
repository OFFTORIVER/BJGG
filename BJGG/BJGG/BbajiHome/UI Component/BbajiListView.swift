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

typealias ListInfo = (locationName: String, name: String, backgroundImageName: String)
typealias ListWeather = (iconName: String, temp: String)

final class BbajiListView: UICollectionView {
    var bbajiListViewDelegate: BbajiListViewDelegate?
    
    private var listWeatherArray: [ListWeather] = []
    private var listInfoArray: [ListInfo] = []
    
    func configure(_ listWeatherArray: [ListWeather], listInfoArray: [ListInfo]) {
        configureStyle()
        configureWeatherArray(listWeatherArray)
        configureInfoArray(listInfoArray)
        reloadData()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
        register(BbajiListCell.self, forCellWithReuseIdentifier: BbajiListCell.id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
            bbajiListViewDelegate?.pushBbajiSpotViewController()
        }
    }
}

extension BbajiListView {
    func configureWeatherArray(_ listWeatherArray: [(ListWeather)]) {
        self.listWeatherArray = listWeatherArray
    }
    
    func configureInfoArray(_ infoArray: [ListInfo]) {
        self.listInfoArray = infoArray
    }
    
    private func configureStyle() {
        layer.cornerRadius = 10.0
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true
        showsVerticalScrollIndicator = false
        
        backgroundColor = .bbagaGray4
    }
}
