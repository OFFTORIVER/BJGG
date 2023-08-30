//
//  BbajiListView.swift
//  BJGG
//
//  Created by 이재웅 on 2022/09/29.
//

import UIKit

protocol BbajiListViewDelegate: AnyObject {
    func didSelectItem(index: Int)
}

final class BbajiListView: UICollectionView {
    weak var bbajiListViewDelegate: BbajiListViewDelegate?
    
    private func configure() {
        configureStyle()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        
        delegate = self
        register(BbajiListCell.self, forCellWithReuseIdentifier: BbajiListCell.id)
        
        configure()
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
        UIEdgeInsets(top: 0, left: 0, bottom: BbajiConstraints.space12, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idx = indexPath.row
        if idx == 0 {
            bbajiListViewDelegate?.didSelectItem(index: idx)
        }
    }
}

extension BbajiListView {
    private func configureStyle() {
        layer.cornerRadius = 10.0
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true
        showsVerticalScrollIndicator = false
        
        backgroundColor = .bbagaGray4
    }
}
