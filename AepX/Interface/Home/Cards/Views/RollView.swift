//
//  RollView.swift
//  AepX
//
//  Created by Joe Charlier on 5/21/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class RollView: UIView {
	let label: UILabel = UILabel()

	init(text: String) {
		label.text = text
		label.pen = Pen(font: UIFont(name: "Copperplate", size: 24*Screen.s)!, color: .red.tone(0.5).tint(0.8), alignment: .center)
		label.numberOfLines = 0
		super.init(frame: .zero)
		addSubview(label)
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		label.center(dx: -28*s, width: 300*s, height: 120*s)
	}
}
