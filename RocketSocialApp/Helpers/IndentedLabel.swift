//
//  IdententLabel.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 28/08/21.
//

import UIKit

class IndentedLabel: UILabel {
    // padding left label
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 20, dy: 0))
    }
}
