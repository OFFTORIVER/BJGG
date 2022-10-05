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
    
    private var weatherData: [(iconName: String?, temp: String?)]?
    private var bbajiInfo: [BbajiInfo]?
    
    private lazy var bbajiListCollectionView: BbajiListCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = BbajiListCollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BbajiListCollectionViewCell.self, forCellWithReuseIdentifier: BbajiListCollectionViewCell.id)
        
        collectionView.layer.cornerRadius = 10.0
        collectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        collectionView.layer.masksToBounds = true
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bbajiListCollectionView)
        
        bbajiListCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BbajiListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 201.38)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: .componentOffset, right: 0)
    }
    
}

extension BbajiListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BbajiListCollectionViewCell.id, for: indexPath) as? BbajiListCollectionViewCell
        if indexPath.row < weatherData?.count ?? 0 && indexPath.row < bbajiInfo?.count ?? 0 {
            let data = weatherData?[indexPath.row]
            let bbaji = bbajiInfo?[indexPath.row]
            
            cell?.configure(indexPath.row, bbajiInfo: bbaji, iconName: data?.iconName, temp: data?.temp)
        } else {
            cell?.configure(indexPath.row, bbajiInfo: nil, iconName: nil, temp: nil)
        }
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idx = indexPath.row
        if idx == 0 {
            delegate?.pushBbajiSpotViewController()
        }
    }
}

extension BbajiListView {
    func updateWeatherData(_ weatherData: [(time: String, iconName: String, temp: String, probability: String)]) {
        var sortedTupleArray = [(iconName: String?, temp: String?)]()
        
        weatherData.forEach {
            var tuple: (iconName: String?, temp: String?)
            tuple.iconName = $0.iconName
            tuple.temp = $0.temp
            sortedTupleArray.append(tuple)
        }
        
        self.weatherData = sortedTupleArray
    }
    
    func updateBbajiInfo(_ bbajiInfo: [BbajiInfo]) {
        self.bbajiInfo = bbajiInfo
    }
    
    func reloadCollectionView() {
        bbajiListCollectionView.reloadData()
    }
}
