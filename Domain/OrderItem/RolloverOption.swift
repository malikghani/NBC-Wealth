//
//  RolloverOption.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 08/09/2024.
//

import Foundation

/// An enumeration representing the different rollover options for a financial instrument.
public enum RollOverOption {
    /// Represents principal option.
    case principal
    
    /// Represents principal and interest option.
    case principalWithInterest
    
    /// Represents matured option.
    case matured
}

// MARK: - Internal Functionality
public extension RollOverOption {
    /// Provides a name for the rollover option.
    var name: String {
        switch self {
        case .principal:
            "Pokok"
        case .principalWithInterest:
            "Pokok + Bunga"
        case .matured:
            "Tidak Diperpanjang"
        }
    }
    
    /// Provides a description for the rollover option.
    var title: String {
        switch self {
        case .principal:
            "Bunga dikirim ke saldo aktif setelah jatuh tempo. Nilai pokok otomatis diperpanjang dengan jangka waktu deposito yang sama."
        case .principalWithInterest:
            "Nilai pokok + bunga otomatis diperpanjang dengan jangka waktu deposito yang sama."
        case .matured:
            "Nilai pokok & bunga otomatis masuk ke saldo aktif setelah lewat jatuh tempo."
        }
    }
    
    /// Provides additional information or notes about the rollover option.
    var subtitle: String? {
        switch self {
        case .principal, .principalWithInterest:
            "Suku bunga saat ini akan dihitung berdasarkan \"suku bunga dasar + suku bunga tambahan\" dan suku bunga saat roll-over akan dihitung berdasarkan suku bunga yang berlaku di tanggal roll-over."
        case .matured:
            nil
        }
    }
}
