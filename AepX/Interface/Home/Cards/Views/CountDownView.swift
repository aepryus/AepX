//
//  CountDownView.swift
//  AepX
//
//  Created by Joe Charlier on 5/12/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

fileprivate class Plaque: UIView {
	private let nameLabel: UILabel = UILabel()
	private let valueLabel: UILabel = UILabel()

	let namePen: Pen = Pen(font: UIFont(name: "AvenirNext-Medium", size: 11*Screen.s)!, color: .white, alignment: .center)
	let valuePen: Pen = Pen(font: UIFont(name: "AvenirNext-Bold", size: 18*Screen.s)!, color: .white, alignment: .center)

	init(name: String) {
		super.init(frame: .zero)

		layer.borderWidth = 0.5*s
		layer.borderColor = UIColor.white.cgColor
		layer.cornerRadius = 6*s
		layer.backgroundColor = UIColor.aepXbackgroundColor.cgColor

		nameLabel.text = name
		nameLabel.pen = namePen
		addSubview(nameLabel)

		valueLabel.pen = valuePen
		addSubview(valueLabel)
	}
	required init?(coder: NSCoder) { fatalError() }

	func load(value: String) {
		valueLabel.text = value
	}

// UIView ==========================================================================================
	override func layoutSubviews() {
		nameLabel.top(dy: 3*s, width: width, height: height/3)
		valueLabel.top(dy: nameLabel.bottom-2*s, width: width, height: height*2/3)
	}
}

class CountDownView: UIView {
	var dateComponents: DateComponents = DateComponents() {
		didSet {
			let days: Int = dateComponents.day ?? 0
			let hours: Int = dateComponents.hour ?? 0
			let minutes: Int = dateComponents.minute ?? 0
			let seconds: Int = dateComponents.second ?? 0

			if days > 0 {
				daysPlaque.load(value: "\(days)")
				addSubview(daysPlaque)
			} else { daysPlaque.removeFromSuperview() }

			if hours > 0 || days > 0 {
				if days > 0 { hoursPlaque.load(value: "\(String(format: "%02d", hours))") }
				else { hoursPlaque.load(value: "\(hours)") }
				addSubview(hoursPlaque)
			} else { hoursPlaque.removeFromSuperview() }

			if minutes > 0 || hours > 0 || days > 0 {
				if days > 0 || hours > 0 { minutesPlaque.load(value: "\(String(format: "%02d", minutes))") }
				else { minutesPlaque.load(value: "\(minutes)") }
				addSubview(minutesPlaque)
			} else { minutesPlaque.removeFromSuperview() }

			if days > 0 || hours > 0 || minutes > 0 { secondsPlaque.load(value: "\(String(format: "%02d", seconds))") }
			else { secondsPlaque.load(value: "\(seconds)") }
		}
	}

	private let daysPlaque: Plaque = Plaque(name: "days".localized)
	private let hoursPlaque: Plaque = Plaque(name: "hours".localized)
	private let minutesPlaque: Plaque = Plaque(name: "minutes".localized)
	private let secondsPlaque: Plaque = Plaque(name: "seconds".localized)

	init() {
		super.init(frame: .zero)
		addSubview(secondsPlaque)
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		let p: CGFloat = 9*s
		let pw: CGFloat = width/4-p
		daysPlaque.left(width: pw, height: height)
		hoursPlaque.left(dx: daysPlaque.right+p, width: pw, height: height)
		minutesPlaque.left(dx: hoursPlaque.right+p, width: pw, height: height)
		secondsPlaque.left(dx: minutesPlaque.right+p, width: pw, height: height)
	}
}
