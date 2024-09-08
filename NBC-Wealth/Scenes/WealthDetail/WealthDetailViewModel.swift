//
//  WealthDetailViewModel.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import Foundation
import Combine
import Domain
import UIKit

final class WealthDetailViewModel {
    // Subjects
    private(set) var viewState = CurrentValueSubject<WealthDetailViewState, Never>(.loading)
    
    // Dependencies
    private var orderItem: WealthProductOrderItem
    
    init(wealth: Wealth) {
        orderItem = .init(wealth: wealth)
    }
}

// MARK: - Internal Functionality
extension WealthDetailViewModel {
    /// Sets a specified value on a given key path within the `WealthProductOrderItem` instance.
    ///
    /// - Parameters:
    ///   - path: The key path to the property of `WealthProductOrderItem` where the value should be set.
    ///   - value: The value to set at the specified key path.
    func setValue<T>(_ path: WritableKeyPath<WealthProductOrderItem, T>, value: T) {
        orderItem[keyPath: path] = value
    }
}

// MARK: - Private Functionality
private extension WealthDetailViewModel {
    
}

// MARK: - Snapshot Functionality
extension WealthDetailViewModel {
    typealias Snapshot = NSDiffableDataSourceSnapshot<WealthDetailSection, WealthDetailItem>
    
    /// Builds a snapshot for displaying wealth detail data.
    ///
    ///  - Returns: A 'Snapshot' containing the sections and items to be displayed.
    func buildSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.info(orderItem.product), .deposit, .miscellaneous])
        snapshot.appendItems([.info(orderItem)], toSection: .info(orderItem.product))
        snapshot.appendItems([.inputDeposit(orderItem)], toSection: .deposit)
        
        appendMaturityDateItem(to: &snapshot)
        appendEstimatedInterestItem(to: &snapshot)
        appendRolloverOptionsItem(to: &snapshot)
        appendCouponItem(to: &snapshot)
        appendCoinItem(to: &snapshot)
        
        return snapshot
    }
    
    func appendMaturityDateItem(to snapshot: inout Snapshot) {
        let description = orderItem.parsed.maturityDateDescription
        snapshot.appendItems([.maturityDate(description)], toSection: .deposit)
    }
    
    func appendEstimatedInterestItem(to snapshot: inout Snapshot) {
        let interest = orderItem.calculateInterest().toIDR()
        snapshot.appendItems([.estimatedInterest(interest)], toSection: .deposit)
    }
    
    func appendRolloverOptionsItem(to snapshot: inout Snapshot) {
        guard orderItem.product.hasRolloverOptions else {
            return
        }
        
        let currentOption = orderItem.rolloverOption.name
        snapshot.appendItems([.rolloverOption(currentOption)], toSection: .miscellaneous)
    }
    
    func appendCouponItem(to snapshot: inout Snapshot) {
        let text = "Dapat dilihat setelah login"
        snapshot.appendItems([.coupon(text)], toSection: .miscellaneous)
    }
    
    func appendCoinItem(to snapshot: inout Snapshot) {
        snapshot.appendItems([.coins("+1000")], toSection: .miscellaneous)
    }
}
