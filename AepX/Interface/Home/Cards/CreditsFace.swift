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
	let imageView: UIImageView = UIImageView()

	var creditRoll: [UIView] = []
	var rolling: Bool = false
	var crI: Int = 0

	init() {
		super.init(frame: .zero)

		imageView.image = UIImage(named: "Banner")
		addSubview(imageView)

		let pen18: Pen = Pen(font: UIFont(name: "Copperplate", size: 18*s)!, color: .red.tone(0.3).shade(0.5), alignment: .center)
		let pen24: Pen = pen18.clone(font: UIFont(name: "Copperplate", size: 24*s)!)
		let pen36: Pen = pen18.clone(font: UIFont(name: "Copperplate", size: 36*s)!)
		let pen48: Pen = pen18.clone(font: UIFont(name: "Copperplate", size: 48*s)!)

		creditRoll.append(RollView(attributed: "AepX".attributed(pen: pen48).append("\nv1.0", pen: pen24)))
		creditRoll.append(RollView(attributed: "by\n".attributed(pen: pen24).append("Aepryus", pen: pen36).append("\nSoftware", pen: pen24)))
		creditRoll.append(RollView(attributed: "written using\n".attributed(pen: pen18).append("Acheron\n", pen: pen36).append("Aepryus'\niOS toolkit", pen: pen18)))
		creditRoll.append(RollView(attributed: "both\n".attributed(pen: pen18).append("AepX and Acheron's\n", pen: pen24).append("source code are\navailable at ", pen: pen18).append("github", pen: pen24)))
		creditRoll.append(RollView(attributed: "Data driven by\nr/spacex's\n".attributed(pen: pen18).append("SpaceX-API", pen: pen24)))
		creditRoll.append(RollView(attributed: "Much\nthanks to\n".attributed(pen: pen24).append("E.M.", pen: pen36)))

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
	}
	required init?(coder: NSCoder) { fatalError() }

	func startRoll() {
		guard !rolling else { return }
		rolling = true
		roll()
	}
	private func roll() {
		guard crI < creditRoll.count else {
			rolling = false
			crI = 0
			return
		}
		let view: UIView = creditRoll[crI]
		crI += 1
		addSubview(view)
		view.alpha = 0
		UIView.animate(withDuration: 0.5, delay: 1) {
			view.alpha = 1
		} completion: { (completed: Bool) in
			UIView.animate(withDuration: 0.5, delay: 3) {
				view.alpha = 0
			} completion: { (completed: Bool) in
				view.removeFromSuperview()
				self.roll()
			}
		}
	}

// Events ==========================================================================================
	@objc func onTap() {
		if let url = URL(string: "https://github.com/aepryus/Acheron") {
			UIApplication.shared.open(url)
		}
	}

// Face ============================================================================================
	override var faceHeight: CGFloat { 150*s }

// UIView ==========================================================================================
	override func layoutSubviews() {
		imageView.frame = bounds
		creditRoll.forEach { $0.frame = bounds }
	}
}
