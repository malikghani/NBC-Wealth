//
//  ViewController.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 04/09/2024.
//

import UIKit

final class ViewController: UIViewController {

    final lazy private var label: UILabel = {
        return UILabel()
    }()
    
    
    var box2 = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .Surface.subdued

        
        let box = UIView()
        view.addSubview(box)
        box.layer.cornerRadius = 12
        box.backgroundColor = .Surface.default
        
        box.translatesAutoresizingMaskIntoConstraints = false
        box.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        box.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        box.heightAnchor.constraint(equalToConstant: 150).isActive = true
        box.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        box.addSubview(box2)
        box2.layer.cornerRadius = 10
        box2.backgroundColor = .clear
        box2.layer.borderColor = UIColor.Border.default.cgColor
        box2.layer.borderWidth = 1
        
        box2.translatesAutoresizingMaskIntoConstraints = false
        box2.centerXAnchor.constraint(equalTo: box.centerXAnchor).isActive = true
        box2.centerYAnchor.constraint(equalTo: box.centerYAnchor).isActive = true
        box2.heightAnchor.constraint(equalToConstant: 140).isActive = true
        box2.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        box.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: box.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: box.centerYAnchor).isActive = true
        
        label.text = "testing"
        label.textColor = .Text.title
        
        let button = UIView()
        box.addSubview(button)
        button.layer.cornerRadius = 10
        button.backgroundColor = .Button.important
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.leadingAnchor.constraint(equalTo: box.leadingAnchor, constant: 12).isActive = true
        
        button.trailingAnchor.constraint(equalTo: box.trailingAnchor, constant: -12).isActive = true
        
        button.bottomAnchor.constraint(equalTo: box.bottomAnchor, constant: -12).isActive = true
        
        

    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            
            
            
            box2.layer.borderColor = UIColor.Border.default.cgColor
        }
    }
}
