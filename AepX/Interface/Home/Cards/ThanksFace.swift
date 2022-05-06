//
//  ThanksFace.swift
//  AepX
//
//  Created by Joe Charlier on 5/5/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class ThanksFace: Face {
	let titleLabel: UILabel = UILabel()

	init() {
		super.init(frame: .zero)

		titleLabel.text = "Thanks".localized
		titleLabel.textColor = .white
		titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 23*s)
		addSubview(titleLabel)
	}
	required init?(coder: NSCoder) { fatalError() }

// Face ============================================================================================
	override var faceHeight: CGFloat { 120*s }

// UIView ==========================================================================================
	override func layoutSubviews() {
		titleLabel.topLeft(dx: 12*s, dy: 10*s, width: 300*s, height: 30*s)
	}
}
