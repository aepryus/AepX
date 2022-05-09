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
	let coreLabel: UILabel = UILabel()
	let flightLabel: UILabel = UILabel()
	let dateLabel: UILabel = UILabel()
	let lineView: UIView = UIView()
	let patchView: UIImageView = UIImageView()

	let pen: Pen = Pen(font: UIFont(name: "AvenirNext-Medium", size: 16*Screen.s)!, color: .white)

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		backgroundColor = UIColor.aepXbackgroundColor.shade(0.5)

		nameLabel.textColor = .white
		nameLabel.font = UIFont(name: "AvenirNext-Medium", size: 18*s)
		addSubview(nameLabel)

		coreLabel.pen = pen
		addSubview(coreLabel)

		flightLabel.pen = pen
		addSubview(flightLabel)

		dateLabel.pen = pen
//		addSubview(dateLabel)

		addSubview(patchView)

		lineView.backgroundColor = UIColor.blue.tone(0.85).tint(0.1)
		addSubview(lineView)
	}
	required init?(coder: NSCoder) { fatalError() }

	func load(launch: Launch) {
		self.launch = launch

		nameLabel.text = launch.name
		flightLabel.text = "[\(launch.flightNo)] \(launch.date.format("MMM d, yyyy h:mm a"))"
//		dateLabel.text =

		let serials: [String] = launch.cores.compactMap {
			let core: Core? = Loom.selectBy(only: $0.appid)
			return core?.serial
		}
		if serials.count > 1 {
			var sb: String = ""
			serials.forEach { sb += "\($0), " }
			sb.removeLast(2)
			coreLabel.text = sb
		} else if serials.count == 1 { coreLabel.text = serials[0]
		} else { coreLabel.text = "" }

		patchView.image = nil
		if let urlString = launch.patch {
			patchView.loadImage(url: urlString)
		}
	}

// UITableViewCell =================================================================================
	override func layoutSubviews() {
		super.layoutSubviews()
		nameLabel.topLeft(dx: 10*s, dy: 5*s, width: 300*s, height: 24*s)
		flightLabel.topLeft(dx: 18*s, dy: nameLabel.bottom, width: 300*s, height: 24*s)
		dateLabel.topLeft(dx: flightLabel.right, dy: flightLabel.top, width: 200*s, height: 24*s)
		coreLabel.topLeft(dx: flightLabel.left, dy: flightLabel.bottom, width: 300*s, height: 24*s)
		patchView.right(dx: -10*s, width: 48*s, height: 48*s)
		lineView.bottom(width: width, height: 1)
	}
}
