//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Rafif Kalantan on 04/09/2020.
//  Copyright © 2020 Rafif Kalantan. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: Add Location action
    @IBAction func addLocation(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addLocation", sender: sender)
    }
    
    // MARK: Displaying Alerts
    func showAlert(message: String, title: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    
    // MARK: Enabled and disabled states for buttons
    func buttonEnabled(_ enabled: Bool, button: UIButton) {
        if enabled {
            button.isEnabled = true
            button.alpha = 1.0
        } else {
            button.isEnabled = false
            button.alpha = 0.5
        }
    }
    
    // MARK: Open Links in Safari
    func openLink(_ url: String) {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
            showAlert(message: "Cannot open link.", title: "Invalid Link")
            return
        }
        UIApplication.shared.open(url, options: [:])
    }

}
