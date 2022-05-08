//
//  LaunchCell.swift
//  AepX
//
//  Created by Joe Charlier on 4/29/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class LaunchCell: ExpandableCell {
	var launch: Launch!

	let nameLabel: UILabel = UILabel()
	let lineView: UIView = UIView()
	let patchView: UIImageView = UIImageView()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		backgroundColor = UIColor.aepXbackgroundColor.shade(0.5)

		nameLabel.textColor = .white
		nameLabel.font = UIFont(name: "AvenirNext-Medium", size: 18*s)
		addSubview(nameLabel)

		addSubview(patchView)

		lineView.backgroundColor = UIColor.blue.tone(0.85).tint(0.1)
		addSubview(lineView)
	}
	required init?(coder: NSCoder) { fatalError() }

	func load(launch: Launch) {
		self.launch = launch

		nameLabel.text = launch.name
		if let urlString = launch.patch {
			patchView.loadImage(url: urlString)
		} else {
			patchView.image = nil
		}
	}

// UITableViewCell =================================================================================
	override func layoutSubviews() {
		super.layoutSubviews()
		nameLabel.left(dx: 10*s, width: 300*s, height: 30*s)
		patchView.right(dx: -10*s, width: 48*s, height: 48*s)
		lineView.bottom(width: width, height: 1)
	}
}
