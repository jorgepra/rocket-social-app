//
//  HudMessages.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 13/08/21.
//

import UIKit
import JGProgressHUD

class NotificationHUD {
    
    private let hud : JGProgressHUD
    
    init( style: JGProgressHUDStyle) {
        self.hud = JGProgressHUD(style: style)
    }
    
    func show(view: UIView, text : String, isError: Bool) {
        
        if isError{
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
        } else{
            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        }
        
        hud.textLabel.text = text
        hud.show(in: view)
        hud.dismiss(afterDelay: 3.0)
    }
    
    
}
