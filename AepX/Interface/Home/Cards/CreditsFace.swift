//
//  CreditsFace.swift
//  AepX
//
//  Created by Joe Charlier on 5/5/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

fileprivate class CreditLabel: UIView {
    let label: UILabel = UILabel()

    private init(text: String? = nil, attributed: NSAttributedString? = nil, size: CGFloat? = nil) {
        if let text = text  {
            label.text = text
            label.pen = Pen(font: .axCopper(size: size ?? 24*Screen.s), color: .red.tone(0.3).shade(0.5), alignment: .center)
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


class CreditsFace: Face {
	let imageView: UIImageView = UIImageView()

	private var creditRoll: [CreditLabel] = []
	var rolling: Bool = false
	var crI: Int = 0

	init() {
		super.init(frame: .zero)

		imageView.image = UIImage(named: "Banner")
		addSubview(imageView)

		for _ in 0...5 { creditRoll.append(CreditLabel(text: "")) }
		renderCredits()

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
	}
	required init?(coder: NSCoder) { fatalError() }

	var pen18: Pen { Pen(font: .axCopper(size: 18*s * AepX.widthScale), color: .red.tone(0.3).shade(0.5), alignment: .center) }
	var pen24: Pen { pen18.clone(font: .axCopper(size: 24*s * AepX.widthScale)) }
	var pen36: Pen { pen18.clone(font: .axCopper(size: 36*s * AepX.widthScale)) }
	var pen48: Pen { pen18.clone(font: .axCopper(size: 48*s * AepX.widthScale)) }

	func renderCredits() {
		creditRoll[0].label.attributedText = "AepX".attributed(pen: pen48).append("\nv\(AepX.version)", pen: pen24)
		creditRoll[1].label.attributedText = "by\n".attributed(pen: pen24).append("Aepryus", pen: pen36).append("\nSoftware", pen: pen24)
		creditRoll[2].label.attributedText = "written using\n".attributed(pen: pen18).append("Acheron\n", pen: pen36).append("Aepryus'\niOS toolkit", pen: pen18)
		creditRoll[3].label.attributedText = "both\n".attributed(pen: pen18).append("AepX and Acheron's\n", pen: pen24).append("source code are\navailable at ", pen: pen18).append("github", pen: pen24)
		creditRoll[4].label.attributedText = "Much\nthanks to\n".attributed(pen: pen24).append("E.M.", pen: pen36)
	}

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
		if let url = URL(string: "https://github.com/aepryus/AepX") {
			UIApplication.shared.open(url)
		}
	}

// Face ============================================================================================
	override var faceHeight: CGFloat { 150*s * AepX.widthScale }

// UIView ==========================================================================================
	override func layoutSubviews() {
		imageView.frame = bounds
		creditRoll.forEach { $0.center(dx: -28*s * AepX.widthScale, width: width, height: height) }
	}
}
