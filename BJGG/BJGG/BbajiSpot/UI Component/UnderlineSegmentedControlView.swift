//
//  UnderlineSegmentedControlView.swift
//  BJGG
//
//  Created by 황정현 on 11/16/23.
//

import Combine
import CombineCocoa
import SnapKit
import UIKit

final class UnderlineSegmentedControlView: UIView {
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = stackViewSpacing
        return stackView
    }()
    
    private var underlineBackgroundView : UIView = {
        let view = UIView()
        view.backgroundColor = .bbagaBack
        return view
    }()
    
    private lazy var underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .bbagaBlue
        return view
    }()
    
    private var segmentButtons: [UIButton] = []
    private var segmentButtonsCenterXPositions: [CGFloat] = []
    
    private let underlineWidth: CGFloat = 28.0
    private let underlineHeight: CGFloat = 2.0
    private let stackViewSpacing: CGFloat = BbajiConstraints.space32
    private let superViewInset = BbajiConstraints.space20
    private var currentTotalItemWidth: CGFloat = 0
    
    private var selectedSegmentIndex = 0 {
        didSet {
            selectedSegmentPublisher.send(selectedSegmentIndex)
        }
    }
    
    private var selectedSegmentPublisher: PassthroughSubject<Int, Never> = PassthroughSubject<Int, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var segmentTapPublisher: AnyPublisher<Int, Never> {
        return selectedSegmentPublisher.eraseToAnyPublisher()
    }
    
    init(titleList: [String]?) {
        super.init(frame: .zero)
        configure()
        configureSegments(titleList: titleList)
        bind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureLayout()
        configureStyle()
    }
    
    private func configureLayout() {
        addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(BbajiConstraints.space12)
            make.leading.equalToSuperview().offset(BbajiConstraints.space20)
            make.height.equalTo(17)
        }
        buttonStackView.sizeToFit()
        
        addSubview(underlineBackgroundView)
        underlineBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(BbajiConstraints.space12)
            make.horizontalEdges.equalToSuperview()

            make.height.equalTo(underlineHeight)
        }
        
        addSubview(underlineView)
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(BbajiConstraints.space12)
            make.leading.equalToSuperview().offset(superViewInset + 13)
            make.width.equalTo(underlineWidth)
            make.height.equalTo(underlineHeight)
        }
    }
    
    private func configureStyle() {
        self.backgroundColor = .bbagaGray4
    }
    
    private func configureSegments(titleList: [String]?) {
        titleList?.forEach { title in
            let button = UIButton()
            buttonStackView.addArrangedSubview(button)
            configureButtonStyle(title: title, button: button)
            configureUnderlineViewXPosition(button: button)
            segmentButtons.append(button)
        }
    }
    
    private func configureButtonStyle(title: String, button: UIButton) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.bbagaGray2, for: .normal)
        button.setTitleColor(.bbagaGray1, for: .selected)
        button.titleLabel?.font = .bbajiFont(.body2)
        button.sizeToFit()
        
        button.snp.makeConstraints { make in
            make.centerY.equalTo(buttonStackView.snp.centerY)
        }
    }
    
    private func configureUnderlineViewXPosition(button: UIButton) {
        let underlineDefaultX = (button.bounds.width - underlineWidth) / 2
        var xPosition: CGFloat = superViewInset
        if segmentButtonsCenterXPositions.isEmpty {
            xPosition += underlineDefaultX
        } else {
            xPosition += currentTotalItemWidth + stackViewSpacing * CGFloat(segmentButtons.count) + underlineDefaultX
        }
        
        currentTotalItemWidth += button.bounds.width
        segmentButtonsCenterXPositions.append(xPosition)
    }
    
    private func bind() {
        Publishers.MergeMany(
            segmentButtons.enumerated().map { (index, button) in
                button.controlEventPublisher(for: .touchUpInside)
                    .map { index }
            }
        ).sink { [weak self] index in
            self?.selectedSegmentIndex = index
            self?.changeButtonStyle(selectedSegmentIndex: index)
            self?.animateUnderline(to: index)
        }
        .store(in: &cancellables)
    }
    
    private func changeButtonStyle(selectedSegmentIndex: Int) {
        segmentButtons.forEach { [weak self] button in
            let isSelected = (button == self?.segmentButtons[selectedSegmentIndex])
            button.titleLabel?.font = isSelected ? .bbajiFont(.body2) : .bbajiFont(.heading9)
            button.isSelected = isSelected
        }
    }
    
    private func animateUnderline(to index: Int) {
        UIView.animate(
            withDuration: 0.1,
            animations: { [weak self] in
                guard let buttonsCenterXPositions = self?.segmentButtonsCenterXPositions else { return }
                self?.underlineView.frame.origin.x = buttonsCenterXPositions[index]
            }
        )
    }
}
