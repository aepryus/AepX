//
//  RocketCell.swift
//  AepX
//
//  Created by Joe Charlier on 4/29/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

protocol RocketCellDelegate: AnyObject {
	func onRocketCellTapped(core: Core)
}

class RocketCell: UITableViewCell {
	weak var delegate: RocketCellDelegate?
	var core: Core!

	let nameLabel: UILabel = UILabel()
	let boosterLabel: UILabel = UILabel()
	let versionLabel: UILabel = UILabel()
	let statusLabel: UILabel = UILabel()
	let flightsLabel: UILabel = UILabel()
	let resultView: ResultView = ResultView()
	let lineView: UIView = UIView()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: nil)
		backgroundColor = UIColor.axDarkBack

		nameLabel.pen = Pen(font: .axDemiBold(size: 29*s), color: .white)
		addSubview(nameLabel)

		statusLabel.pen = Pen(font: .axMedium(size: 15*s), color: .white)
		addSubview(statusLabel)

		flightsLabel.pen = Pen(font: .axMedium(size: 15*s), color: .white, alignment: .center)
		addSubview(flightsLabel)

		boosterLabel.pen = Pen(font: .axMedium(size: 17*s), color: .white, alignment: .right)
		addSubview(boosterLabel)

		versionLabel.pen = Pen(font: .axMedium(size: 15*s), color: .white, alignment: .right)
		addSubview(versionLabel)

		addSubview(resultView)

		lineView.backgroundColor = UIColor.blue.tone(0.85).tint(0.1)
		addSubview(lineView)

		let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
		addGestureRecognizer(gesture)
	}
	required init?(coder: NSCoder) { fatalError() }

	func load(delegate: RocketCellDelegate, core: Core) {
		self.delegate = delegate
		self.core = core

		nameLabel.text = core.serial
		statusLabel.text = core.state
		flightsLabel.text = (core.launches.count != 1 ? "\(core.launches.count) " + "flights".localized : "1 " + "flight".localized)
		boosterLabel.text = core.booster.name
		versionLabel.text = core.version
		resultView.result = core.launches.first?.result ?? .planned
	}

// Events ==========================================================================================
	@objc func onTap() {
		delegate?.onRocketCellTapped(core: core)
	}

// UITableViewCell =================================================================================
	override func layoutSubviews() {
		nameLabel.topLeft(dx: 9*s, dy: 6*s, width: 300*s, height: 30*s)
		statusLabel.topLeft(dx: nameLabel.left+6*s, dy: nameLabel.bottom-8*s, width: 300*s, height: 30*s)
		flightsLabel.center(width: 180*s, height: 20*s)
		boosterLabel.topRight(dx: -9*s, dy: 4*s, width: 200*s, height: 30*s)
		versionLabel.topLeft(dx: boosterLabel.left-2*s, dy: boosterLabel.bottom-9*s, width: 200*s, height: 30*s)
		resultView.right(dx: -1*s, width: 4*s, height: height*0.6)
		lineView.bottom(width: width, height: 1*s)
	}
}
