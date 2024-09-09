//
//  PaymentMethodType.swift
//  Domain
//
//  Created by Ghani's Mac Mini on 09/09/2024.
//

import Foundation
import NeoBase

/// Represents the type of payment methods available.
public enum PaymentMethodType: String, Decodable {
    /// Virtual Account payment method type.
    case va
    
    /// Virtual Account Minimart payment method type.
    case vam
    
    /// Balance payment method type, representing a pre-loaded balance.
    case balance
}

// MARK: - Public Functionality
public extension PaymentMethodType {
    /// Represents the title of the payment method
    var title: String {
        switch self {
        case .va:
            "Virtual Account"
        case .vam:
            "Virtual Account Minimart"
        case .balance:
            "Tabungan Reguler"
        }
    }
    
    /// Represent the priority order
    var priority: Int {
        switch self {
        case .va:
            2
        case .vam:
            1
        case .balance:
            0
        }
    }
    
    /// Represents the info for each case when it's selected as selected payment method
    var info: String {
        switch self {
        case .va:
            "No: 8241002201150001"
        case .vam:
            "No: 413268412"
        case .balance:
            "Saldo Aktif : \(150000.toIDR())"
        }
    }
    
    /// Represent the description for each methods
    var description: String {
        switch self {
        case .va:
            """
            Kamu bisa bayar dengan kode virtual account dari salah satu bank dibawah. Jika nominal pembayaran lebih besar dari limit transfer satu kali bank yang dipilih, kamu dapat melakukan beberapa kali top up saldo ke rekening Tabungan Reguler atau rekening Tabungan NOW kamu dan melanjutkan pembayaran menggunakan saldomu setelahnya.
            """
        case .vam:
            """
            Kamu bisa bayar dengan kode virtual account dari salah satu minimarket yang terdaftar di bawah ini. Jika nominal pembayaran lebih besar dari batas transfer satu kali minimarket yang dipilih, kamu dapat melakukan beberapa kali top up saldo ke akun pembayaran minimarket atau menggunakan metode pembayaran lain setelahnya untuk melanjutkan pembayaran
            """
        case .balance:
            """
            Kamu bisa bayar menggunakan saldo dari akun "Saldo Ku". Jika nominal pembayaran melebihi saldo yang tersedia, kamu dapat melakukan top up saldo terlebih dahulu sebelum melanjutkan pembayaran. Pastikan saldo mencukupi untuk menyelesaikan transaksi.
            """
        }
    }
}
