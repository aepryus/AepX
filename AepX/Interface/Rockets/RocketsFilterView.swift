//
//  RocketsFilterView.swift
//  AepX
//
//  Created by Joe Charlier on 5/15/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

struct RocketFilter {
	var active: Bool
	var before: Bool
	var after: Bool
	var retired: Bool
	var expended: Bool
}

class RocketsFilterView: UIView {
	let line: UIView = UIView()

	let activeSwitch: UISwitch = UISwitch()
	let retiredSwitch: UISwitch = UISwitch()
	let expendedSwitch: UISwitch = UISwitch()
	let afterSwitch: UISwitch = UISwitch()
	let beforeSwitch: UISwitch = UISwitch()

	let activeLabel: UILabel = UILabel()
	let retiredLabel: UILabel = UILabel()
	let expendedLabel: UILabel = UILabel()
	let afterLabel: UILabel = UILabel()
	let beforeLabel: UILabel = UILabel()

	var filter: RocketFilter = RocketFilter(active: true, before: true, after: true, retired: true, expended: true)

	init() {
		super.init(frame: .zero)
		backgroundColor = UIColor.axBackgroundColor.tone(-0.7).tint(0.2).alpha(0.7)

		line.backgroundColor = .white
		addSubview(line)

		addSubview(activeSwitch)
		addSubview(retiredSwitch)
		addSubview(expendedSwitch)
		addSubview(afterSwitch)
		addSubview(beforeSwitch)

		activeLabel.text = "Still Active".localized
		activeLabel.pen = Pen.axLabel
		addSubview(activeLabel)

		retiredLabel.text = "Retired".localized
		retiredLabel.pen = Pen.axLabel
		addSubview(retiredLabel)

		expendedLabel.text = "Intentionally Expended".localized
		expendedLabel.pen = Pen.axLabel
		addSubview(expendedLabel)

		afterLabel.text = "Destroyed After Success".localized
		afterLabel.pen = Pen.axLabel
		addSubview(afterLabel)

		beforeLabel.text = "Destroyed Before Success".localized
		beforeLabel.pen = Pen.axLabel
		addSubview(beforeLabel)

		load()
	}
	required init?(coder: NSCoder) { fatalError() }

	func unload() {
		filter.active = activeSwitch.isOn
		filter.retired = retiredSwitch.isOn
		filter.expended = expendedSwitch.isOn
		filter.after = afterSwitch.isOn
		filter.before = beforeSwitch.isOn
	}
	func load() {
		activeSwitch.isOn = filter.active
		retiredSwitch.isOn = filter.retired
		expendedSwitch.isOn = filter.expended
		afterSwitch.isOn = filter.after
		beforeSwitch.isOn = filter.before
	}

// UIView ==========================================================================================
	override func layoutSubviews() {
		line.top(width: width, height: 1*s)

		let dx: CGFloat = 12*s
		var dy: CGFloat = 100*s
		let rh: CGFloat = 60*s			// row height
		let pw: CGFloat = 24*s			// padding with
		let lw: CGFloat = 240*s			// label width

		activeLabel.topLeft(dx: dx, dy: dy, width: lw, height: 30*s)
		activeSwitch.topLeft(dx: activeLabel.right+pw, dy: dy)
		dy += rh

		retiredLabel.topLeft(dx: dx, dy: dy, width: lw, height: 30*s)
		retiredSwitch.topLeft(dx: activeLabel.right+pw, dy: dy)
		dy += rh

		expendedLabel.topLeft(dx: dx, dy: dy, width: lw, height: 30*s)
		expendedSwitch.topLeft(dx: activeLabel.right+pw, dy: dy)
		dy += rh

		afterLabel.topLeft(dx: dx, dy: dy, width: lw, height: 30*s)
		afterSwitch.topLeft(dx: activeLabel.right+pw, dy: dy)
		dy += rh

		beforeLabel.topLeft(dx: dx, dy: dy, width: lw, height: 30*s)
		beforeSwitch.topLeft(dx: activeLabel.right+pw, dy: dy)
	}
}
