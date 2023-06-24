//
//  SpotInfoActionViewModel.swift
//  BJGG
//
//  Created by 황정현 on 2023/06/24.
//

import Combine
import UIKit

protocol ActionViewModelType {
    associatedtype Input
    
    func transform(input: Input)
}

final class SpotInfoViewModel: ActionViewModelType {
    private let bbajiInfo: BbajiInfo
    private var cancellables = Set<AnyCancellable>()
    
    struct Input {
        let contactTapGesture: AnyPublisher<UITapGestureRecognizer, Never>?
    }
    
    func transform(input: Input) {
        input.contactTapGesture?.sink {[weak self] _ in
            self?.openContact()
        }.store(in: &cancellables)
    }
    
    init(info: BbajiInfo) {
        self.bbajiInfo = info
    }
    
    private func openContact() {
        guard let phoneNumber:Int = Int(bbajiInfo.getContact().components(separatedBy: ["-"]).joined()) else { return }
        if let url = NSURL(string: "tel://0" + "\(phoneNumber)"),
           UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}
