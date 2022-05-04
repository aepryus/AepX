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

	let label: UILabel = UILabel()
	let lineView: UIView = UIView()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: nil)

		backgroundColor = UIColor.cyan.tone(0.5).tint(0.5)

		label.backgroundColor = UIColor.green.tone(0.5).tint(0.1)
		addSubview(label)

		lineView.backgroundColor = UIColor.red.tone(0.7).shade(0.5)
		addSubview(lineView)

		label.left(dx: 10*s, width: 300*s, height: 30*s)
		lineView.bottom(width: width, height: 1*s)

		let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
		addGestureRecognizer(gesture)
	}
	required init?(coder: NSCoder) { fatalError() }

	func load(delegate: RocketCellDelegate, core: Core) {
		self.delegate = delegate
		self.core = core

		label.text = core.serial
	}

// Events ==========================================================================================
	@objc func onTap() {
		delegate?.onRocketCellTapped(core: core)
	}
}
