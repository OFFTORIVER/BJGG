//
//  BbajiListView.swift
//  BJGG
//
//  Created by 이재웅 on 2022/09/29.
//

import UIKit

protocol BbajiListViewDelegate: AnyObject {
    func pushBbajiSpotViewController()
}

typealias BbajiListInfo = (locationName: String, name: String, backgroundImageName: String)
typealias BbajiListWeather = (iconName: String, temp: String)

final class BbajiListView: UICollectionView {
    weak var bbajiListViewDelegate: BbajiListViewDelegate?
    
    private var listWeatherArray: [BbajiListWeather] = []
    private var listInfoArray: [BbajiListInfo] = []
    
    func configure(_ listWeatherArray: [BbajiListWeather], listInfoArray: [BbajiListInfo]) {
        configureStyle()
        configureWeatherArray(listWeatherArray)
        configureInfoArray(listInfoArray)
        reloadData()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        
        delegate = self
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        bbajiListViewDelegate?.pushBbajiSpotViewController()
    }
}

extension BbajiListView {
    func configureWeatherArray(_ listWeatherArray: [(BbajiListWeather)]) {
        self.listWeatherArray = listWeatherArray
    }
    
    func configureInfoArray(_ infoArray: [BbajiListInfo]) {
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
