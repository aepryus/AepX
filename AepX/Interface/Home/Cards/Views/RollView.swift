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

	private init(text: String? = nil, attributed: NSAttributedString? = nil, size: CGFloat? = nil) {
		if let text = text  {
			label.text = text
			label.pen = Pen(font: UIFont(name: "Copperplate", size: size ?? 24*Screen.s)!, color: .red.tone(0.3).shade(0.5), alignment: .center)
		} else if let attributed = attributed {
			label.attributedText = attributed
		}

		label.numberOfLines = 0
		label.layer.shadowColor = UIColor.yellow.tint(0.8).cgColor
		label.layer.shadowRadius = 7*Screen.s
		label.layer.shadowOpacity = 1
		label.layer.shadowOffset = CGSize(width: 0, height: 0)
		super.init(frame: .zero)
		isUserInteractionEnabled = false
		addSubview(label)
	}
	convenience init(text: String, size: CGFloat? = nil) {
		self.init(text: text, attributed: nil, size: size)
	}
	convenience init(attributed: NSAttributedString, size: CGFloat? = nil) {
		self.init(text: nil, attributed: attributed, size: size)
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		label.frame = bounds
	}
}
