//
//  PaymentViewModel.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import Foundation
import Combine
import UIKit
import Domain
import Data

final class PaymentViewModel {
    // Subjects
    private(set) var viewState = CurrentValueSubject<PaymentViewState, Never>(.loading)
    
    // Dependencies
    private var orderItem: WealthProductOrderItem
    private var paymentMethods: PaymentMethods = []
    private var groupedMethods: [PaymentMethods] = []
    var selectedPaymentMethod: PaymentMethod?
    private var paymentEndDate: Date
    
    // Repositories
    private let paymentRepository: any PaymentRepository
    
    init(
        paymentRepository: any PaymentRepository = PaymentRepositoryImplementation(),
        orderItem: WealthProductOrderItem
    ) {
        self.paymentRepository = paymentRepository
        self.orderItem = orderItem
        self.paymentEndDate = Date().addingTimeInterval(24 * 60 * 60)
    }
}

// MARK: - Public Functionality
extension PaymentViewModel {
    /// Fetches product groups from the repository and updates the view state.
    func fetchPaymentMethods() {
        Task {
            do {
                viewState.send(.loading)
                paymentMethods = try await paymentRepository.fetchPaymentMethods()
                getGroupedPaymentMethods()
                viewState.send(.methodReceived)
            } catch {
                viewState.send(.error(message: error.localizedDescription))
            }
        }
    }
}

// MARK: - Private Functionality
private extension PaymentViewModel {
    func getGroupedPaymentMethods() {
        let sortedMethods = paymentMethods.sorted { $0.type.priority > $1.type.priority }
        let groupedMethods = Dictionary(grouping: paymentMethods, by: { $0.type })
        
        self.groupedMethods = groupedMethods.values.map { $0 }
    }
}

// MARK: - Snapshot Functionality
extension PaymentViewModel {
    typealias Snapshot = NSDiffableDataSourceSnapshot<PaymentSection, PaymentItem>
    
    /// Builds a snapshot for displaying payment data.
    ///
    ///  - Returns: A 'Snapshot' containing the sections and items to be displayed.
    func buildSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        
        let hasSelectedPaymentMethod = selectedPaymentMethod != nil
        let otherPaymentMethodSection = PaymentSection.otherPaymentMethods(isSelected: hasSelectedPaymentMethod)
        snapshot.appendSections([.countdown, .selectedPaymentMethod, otherPaymentMethodSection])
        snapshot.appendItems([.countdown(orderItem, paymentEndDate)], toSection: .countdown)
        
        if let selectedPaymentMethod {
            snapshot.appendItems([.selectedMethod(selectedPaymentMethod)], toSection: .selectedPaymentMethod)
        }
        
        for methods in groupedMethods {
            snapshot.appendItems([.methodList(methods)], toSection: otherPaymentMethodSection)
        }
        
        return snapshot
    }
}
