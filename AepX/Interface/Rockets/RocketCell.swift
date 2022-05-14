//
//  RocketCell.swift
//  AepX
//
//  Created by Joe Charlier on 4/29/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit

protocol RocketCellDelegate: AnyObject {
	func onRocketCellTapped(core: Core)
}

class RocketCell: UITableViewCell {
	weak var delegate: RocketCellDelegate?
	var core: Core!

	let nameLabel: UILabel = UILabel()
	let blockLabel: UILabel = UILabel()
	let countLabel: UILabel = UILabel()
	let statusLabel: UILabel = UILabel()
	let reasonLabel: UILabel = UILabel()
	let patchesView: PatchesView = PatchesView()
	let lineView: UIView = UIView()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: nil)
		backgroundColor = UIColor.axBackgroundColor.shade(0.5)

		nameLabel.textColor = .white
		nameLabel.font = UIFont(name: "AvenirNext-Medium", size: 18*s)
		addSubview(nameLabel)

		blockLabel.textColor = .white
		blockLabel.textAlignment = .center
		blockLabel.font = UIFont(name: "AvenirNext-Medium", size: 18*s)
		addSubview(blockLabel)

		countLabel.textColor = .white
		countLabel.textAlignment = .center
		countLabel.font = UIFont(name: "AvenirNext-Medium", size: 18*s)
		addSubview(countLabel)

		statusLabel.textColor = .white
		statusLabel.textAlignment = .center
		statusLabel.font = UIFont(name: "AvenirNext-Medium", size: 18*s)
		addSubview(statusLabel)

		reasonLabel.textColor = .white
		reasonLabel.textAlignment = .center
		reasonLabel.font = UIFont(name: "AvenirNext-Medium", size: 18*s)
		addSubview(reasonLabel)

		addSubview(patchesView)

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
		blockLabel.text = core.block != 0 ? "\(core.block)" : ""
		countLabel.text = "\(core.launches.count)"
		statusLabel.text = core.disposition
		reasonLabel.text = core.reason
		patchesView.load(core: core)
	}

// Events ==========================================================================================
	@objc func onTap() {
		delegate?.onRocketCellTapped(core: core)
	}

// UITableViewCell =================================================================================
	override func layoutSubviews() {
		super.layoutSubviews()
		nameLabel.topLeft(dx: 10*s, dy: 2*s, width: 300*s, height: 30*s)
		blockLabel.topRight(dx: -170*s, dy: nameLabel.top, width: 40*s, height: 30*s)
		countLabel.topRight(dx: -120*s, dy: nameLabel.top, width: 40*s, height: 30*s)
		statusLabel.topRight(dx: -10*s, dy: nameLabel.top, width: 100*s, height: 30*s)
		reasonLabel.topRight(dx: -10*s, dy: statusLabel.bottom, width: 100*s, height: 30*s)
		patchesView.topLeft(dx: 20*s, dy: nameLabel.bottom+3*s, width: 300*s, height: 27*s)
		lineView.bottom(width: width, height: 1)
	}
}
