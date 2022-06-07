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
	let patchesView: PatchesView = PatchesView(size: 27*Screen.s)
	let patchesContent: UIView = UIView()
	let lineView: UIView = UIView()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: nil)
		backgroundColor = UIColor.axBackgroundColor.shade(0.5)

		nameLabel.pen = Pen(font: .axDemiBold(size: 29*s), color: .white, alignment: .left)
		addSubview(nameLabel)

		statusLabel.pen = Pen(font: .axMedium(size: 15*s), color: .white, alignment: .left)
		addSubview(statusLabel)

		boosterLabel.pen = Pen(font: .axMedium(size: 17*s), color: .white, alignment: .right)
		addSubview(boosterLabel)

		versionLabel.pen = Pen(font: .axMedium(size: 15*s), color: .white, alignment: .right)
		addSubview(versionLabel)

//		patchesContent.layer.cornerRadius = 12*s
		patchesContent.backgroundColor = UIColor.axBackgroundColor.shade(0.2)
//		patchesContent.layer.borderWidth = 0.5*s
//		patchesContent.layer.borderColor = UIColor.axBorderColor.shade(0.5).tint(0.2).cgColor
		patchesContent.addSubview(patchesView)

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
		boosterLabel.text = core.booster.name
		versionLabel.text = core.version
		statusLabel.text = core.state
		//  (core.launches.count != 1 ? "\(core.launches.count) " + "flights".localized : "1 " + "flight".localized)
		patchesView.load(core: core)
		if core.launches.count == 0 { patchesContent.removeFromSuperview() }
		else { addSubview(patchesContent) }
	}

// Events ==========================================================================================
	@objc func onTap() {
		delegate?.onRocketCellTapped(core: core)
	}

// UITableViewCell =================================================================================
	override func layoutSubviews() {
		super.layoutSubviews()
		nameLabel.topLeft(dx: 9*s, dy: 6*s, width: 300*s, height: 30*s)
		statusLabel.topLeft(dx: nameLabel.left+6*s, dy: nameLabel.bottom-8*s, width: 300*s, height: 30*s)
		boosterLabel.topRight(dx: -6*s, dy: 4*s, width: 200*s, height: 30*s)
		versionLabel.topLeft(dx: boosterLabel.left-2*s, dy: boosterLabel.bottom-9*s, width: 200*s, height: 30*s)
		patchesContent.bottom(dy: -1*s, width: width, height: 33*s)
		patchesView.right(dx: -9*s)
		lineView.bottom(width: width, height: 1*s)
	}
}
