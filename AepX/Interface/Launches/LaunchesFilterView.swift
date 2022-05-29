//
//  LaunchesFilterView.swift
//  AepX
//
//  Created by Joe Charlier on 5/15/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

struct LaunchFilter {
	var falcon1: Bool
	var falcon9: Bool
	var falconHeavy: Bool
	var succeeded: Bool
	var failed: Bool
	var expended: Bool
	var landed: Bool
	var lost: Bool
}

private class OptionView: UIView {
	var label: UILabel = UILabel()
	var toggle: UISwitch = UISwitch()

	init(title: String) {
		label.text = title
		label.pen = .axLabel
		super.init(frame: .zero)
		addSubview(label)
		addSubview(toggle)
	}
	required init?(coder: NSCoder) { fatalError() }

	var isOn: Bool {
		set { toggle.isOn = newValue }
		get { toggle.isOn }
	}

// UIView ==========================================================================================
	override func layoutSubviews() {
		label.left(dx: 10*s, width: 220*s, height: 30*s)
		toggle.left(dx: label.right+24*s)
	}
}

private class OrView: UIView {
	var views: [OptionView] = []

	init(views: [OptionView]) {
		self.views = views
		super.init(frame: .zero)
		self.views.forEach { addSubview($0) }
	}
	required init?(coder: NSCoder) { fatalError() }
// UIView ==========================================================================================
	override func layoutSubviews() {
		views.enumerated().forEach { $1.top(dy: CGFloat($0)*39*s, width: 320*s, height: 30*s) }
	}
}

private class AndView: UIView {
	var views: [OrView] = []

	init(views: [OrView]) {
		self.views = views
		super.init(frame: .zero)
		self.views.forEach { addSubview($0) }
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		var dy: CGFloat = 24*s
		views.forEach {
			$0.top(dy: dy, width: 320*s, height: CGFloat($0.views.count)*39*s+20*s)
			dy += $0.height+10*s
		}
	}
}

class LaunchesFilterView: UIView {

	private let line: UIView = UIView()

	private let andView: AndView

	private let falcon1View: OptionView = OptionView(title: "Falcon 1".localized)
	private let falcon9View: OptionView = OptionView(title: "Falcon 9".localized)
	private let falconHeavyView: OptionView = OptionView(title: "Falcon Heavy".localized)

	private let succeededView: OptionView = OptionView(title: "Succeeded".localized)
	private let failedView: OptionView = OptionView(title: "Failed".localized)

	private let expendedView: OptionView = OptionView(title: "Expended".localized)
	private let landedView: OptionView = OptionView(title: "Landed".localized)
	private let lostView: OptionView = OptionView(title: "Lost".localized)

	var filter: LaunchFilter = LaunchFilter(falcon1: true, falcon9: true, falconHeavy: true, succeeded: true, failed: true, expended: true, landed: true, lost: true)

	init() {
		let shipsView: OrView = OrView(views: [falcon1View, falcon9View, falconHeavyView])
		let outcomesView: OrView = OrView(views: [succeededView, failedView])
		let boostersView: OrView = OrView(views: [expendedView, landedView, lostView])

		andView = AndView(views: [shipsView, outcomesView, boostersView])

		super.init(frame: .zero)
		backgroundColor = UIColor.axBackgroundColor.tone(-0.7).tint(0.2).alpha(0.7)

		line.backgroundColor = .white
		addSubview(line)

		addSubview(andView)

		load()
	}
	required init?(coder: NSCoder) { fatalError() }

	func unload() {
		filter.falcon1 = falcon1View.isOn
		filter.falcon9 = falcon9View.isOn
		filter.falconHeavy = falconHeavyView.isOn
		filter.succeeded = succeededView.isOn
		filter.failed = failedView.isOn
		filter.expended = expendedView.isOn
		filter.landed = landedView.isOn
		filter.lost = lostView.isOn
	}
	func load() {
		falcon1View.isOn = filter.falcon1
		falcon9View.isOn = filter.falcon9
		falconHeavyView.isOn = filter.falconHeavy
		succeededView.isOn = filter.succeeded
		failedView.isOn = filter.failed
		expendedView.isOn = filter.expended
		landedView.isOn = filter.landed
		lostView.isOn = filter.lost
	}

// UIView ==========================================================================================
	override func layoutSubviews() {
		line.top(width: width, height: 1*s)
		andView.frame = bounds
	}
}
