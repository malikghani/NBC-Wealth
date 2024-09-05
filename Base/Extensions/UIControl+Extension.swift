//
//  UIControl+Extension.swift
//  Base
//
//  Created by Ghani's Mac Mini on 05/09/2024.
//

import UIKit

final class ClosureSleeve {
    let closure:()->()
    
    init(_ closure: @escaping()->()) {
        self.closure = closure
    }
    
    @objc func invoke() {
        closure()
    }
}

// MARK: - Action Functionality
public extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()-> Void) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
