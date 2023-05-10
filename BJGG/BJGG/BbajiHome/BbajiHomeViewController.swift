//
//  BbajiHomeViewController.swift
//  BJGG
//
//  Created by 이재웅 on 2022/08/28.
//

import UIKit
import SnapKit
import Combine

final class BbajiHomeViewController: UIViewController {
    private lazy var bbajiTitleView = BbajiTitleView()
    private lazy var bbajiListView = BbajiListView()
    private lazy var backgroundImageView = BbajiHomeBackgroundImageView()
    
    private let viewModel: BbajiHomeViewModel
    private var cancellable = Set<AnyCancellable>()
    
    init(viewMdoel: BbajiHomeViewModel = BbajiHomeViewModel()) {
        self.viewModel = viewMdoel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        configure()
        
        viewModel.$weatherNows
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
            guard let self = self else { return }
            self.bbajiListView.reloadData()
        }.store(in: &cancellable)
    }
    
    private func configure() {
        configureLayout()
        configureDelegate()
        configureComponent()
    }
}

extension BbajiHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UIDevice.current.hasNotch ? 2 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BbajiListCell.id, for: indexPath) as? BbajiListCell else { return UICollectionViewCell() }
        
        if indexPath.row < viewModel.weatherNows.count {
            let weatherNow = viewModel.weatherNows[indexPath.row]
            
            cell.configure(indexPath.row, locationName: weatherNow.locationName, bbajiName: weatherNow.name, backgroundImageName: weatherNow.backgroundImageName, iconName: weatherNow.iconName, temp: weatherNow.temp)
        } else {
            cell.configure(indexPath.row)
        }
        
        return cell
    }
}


extension BbajiHomeViewController: BbajiListViewDelegate {
    func pushBbajiSpotViewController() {
        self.navigationController?.pushViewController(BbajiSpotViewController(), animated: true)
    }
}

extension BbajiHomeViewController {
    func configureComponent() {

    }
}

private extension BbajiHomeViewController {
    func configureDelegate() {
        bbajiListView.bbajiListViewDelegate = self
        bbajiListView.dataSource = self
    }
    
    func configureLayout() {
        [
            backgroundImageView,
            bbajiTitleView,
            bbajiListView
        ].forEach { view.addSubview($0) }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bbajiTitleView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(51.0)
            $0.leading.equalToSuperview().inset(BbajiConstraints.superViewInset)
            $0.trailing.equalToSuperview().inset(BbajiConstraints.superViewInset)
            $0.height.equalTo(90.0)
        }
        
        bbajiListView.snp.makeConstraints {
            $0.top.equalTo(bbajiTitleView.snp.bottom).offset(198.0)
            $0.leading.equalToSuperview().inset(BbajiConstraints.superViewInset)
            $0.trailing.equalToSuperview().inset(BbajiConstraints.superViewInset)
            $0.bottom.equalToSuperview()
        }
        
        if !UIDevice.current.hasNotch {
            configureLayoutForNotNotch()
        }
    }
    
    func configureLayoutForNotNotch() {
        let noticeLabel: UILabel = {
            let label = UILabel()
            label.text = "다음 빠지는 어디로 가까?"
            label.font = .bbajiFont(.heading4)
            label.textColor = .bbagaBlue
            
            return label
        }()
        
        let logoImageView: UIImageView = {
            let imageView = UIImageView()
            
            imageView.image = UIImage(named: "subLogo")
            
            return imageView
        }()
        
        [
            noticeLabel,
            logoImageView
        ].forEach { view.addSubview($0) }
        
        noticeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(42.0)
        }
        
        logoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(63.0)
            $0.width.equalTo(71.0)
            $0.height.equalTo(24.0)
            $0.bottom.equalTo(noticeLabel.snp.top)
        }
    }
}
