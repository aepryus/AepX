//
//  CreditsFace.swift
//  AepX
//
//  Created by Joe Charlier on 5/5/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class CreditsFace: Face {
	let titleLabel: UILabel = UILabel()
	let imageView: UIImageView = UIImageView()

	var creditRoll: [UIView] = []
	var crI: Int = 0

	init() {
		super.init(frame: .zero)

		titleLabel.text = "Credits".localized
		titleLabel.textColor = .white
		titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 23*s)
		addSubview(titleLabel)

		imageView.image = UIImage(named: "Banner")
		addSubview(imageView)

		creditRoll.append(RollView(text: "by\nAepryus\nSoftware"))
		creditRoll.append(RollView(text: "maker of\nthe math\nsandbox:"))
		creditRoll.append(RollView(text: "...Oovium"))
		creditRoll.append(RollView(text: "and the\nrelativity\nthought\nexperiment:"))
		creditRoll.append(RollView(text: "...Aexels"))
		creditRoll.append(RollView(text: "Also sincere\nthanks to\nE.M."))
	}
	required init?(coder: NSCoder) { fatalError() }

	func startRoll() {
		guard crI < creditRoll.count else { crI = 0; return }
		let view: UIView = creditRoll[crI]
		crI += 1
		addSubview(view)
		view.alpha = 0
		UIView.animate(withDuration: 0.5, delay: 1) {
			view.alpha = 1
		} completion: { (completed: Bool) in
			UIView.animate(withDuration: 0.5, delay: 4) {
				view.alpha = 0
			} completion: { (completed: Bool) in
				view.removeFromSuperview()
				self.startRoll()
			}
		}
	}

// Face ============================================================================================
	override var faceHeight: CGFloat { 150*s }

// UIView ==========================================================================================
	override func layoutSubviews() {
		titleLabel.topLeft(dx: 12*s, dy: 10*s, width: 300*s, height: 30*s)
		imageView.frame = bounds
		creditRoll.forEach { $0.frame = bounds }
	}
}
