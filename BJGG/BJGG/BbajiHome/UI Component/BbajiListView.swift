//
//  BbajiListView.swift
//  BJGG
//
//  Created by 이재웅 on 2022/09/29.
//

import UIKit

class BbajiListView: UIView {
    private lazy var bbajiListCollectionView: BbajiListCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = BbajiListCollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BbajiListCollectionViewCell.self, forCellWithReuseIdentifier: BbajiListCollectionViewCell.id)
        
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
    
}

extension BbajiListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BbajiListCollectionViewCell.id, for: indexPath) as? BbajiListCollectionViewCell
        
        cell?.configure()
        
        return cell ?? UICollectionViewCell()
    }
    
    
}
