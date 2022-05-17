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
	let nameLabel: UILabel = UILabel()
	let dateLabel: UILabel = UILabel()
	let lineView: UIView = UIView()
	let patchView: UIImageView = UIImageView()

	let pen: Pen = Pen(font: UIFont(name: "AvenirNext-Medium", size: 16*Screen.s)!, color: .white, alignment: .left)

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		nameLabel.textColor = .white
		nameLabel.font = UIFont(name: "AvenirNext-Bold", size: 19*s)
		nameLabel.adjustsFontSizeToFitWidth = true
		addSubview(nameLabel)

		dateLabel.pen = pen
		addSubview(dateLabel)

		addSubview(patchView)

		lineView.backgroundColor = UIColor.blue.tone(0.85).tint(0.1)
		addSubview(lineView)
	}
	required init?(coder: NSCoder) { fatalError() }

	func load(launch: Launch) {
		backgroundColor = launch.completed ? UIColor.axBackgroundColor.shade(0.5) : UIColor.axBackgroundColor.shade(0.2)

		nameLabel.text = launch.name
		dateLabel.text = "\(launch.date.format("MMM d, yyyy"))"

		patchView.image = nil
		if let urlString = launch.patch {
			patchView.loadImage(url: urlString)
		}
	}

// UITableViewCell =================================================================================
	override func layoutSubviews() {
		super.layoutSubviews()
		patchView.left(dx: 9*s, width: 48*s, height: 48*s)
		nameLabel.left(dx: patchView.right+12*s, dy: -12*s, width: width-(patchView.right+12*s)-12*s, height: 40*s)
		dateLabel.left(dx: nameLabel.left, dy: 12*s, width: 300*s, height: 48*s)
		lineView.bottom(width: width, height: 1)
	}
}
