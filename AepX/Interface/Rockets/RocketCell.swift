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
	let lineView: UIView = UIView()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: nil)
		backgroundColor = UIColor.aepXbackgroundColor.shade(0.5)

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
		blockLabel.text = core.block != nil ? "\(core.block!)" : ""
		countLabel.text = "\(core.launches.count)"
		statusLabel.text = core.status
	}

// Events ==========================================================================================
	@objc func onTap() {
		delegate?.onRocketCellTapped(core: core)
	}

// UITableViewCell =================================================================================
	override func layoutSubviews() {
		super.layoutSubviews()
		nameLabel.left(dx: 10*s, width: 300*s, height: 30*s)
		blockLabel.right(dx: -170*s, width: 40*s, height: 30*s)
		countLabel.right(dx: -120*s, width: 40*s, height: 30*s)
		statusLabel.right(dx: -10*s, width: 100*s, height: 30*s)
		lineView.bottom(width: width, height: 1)
	}
}
