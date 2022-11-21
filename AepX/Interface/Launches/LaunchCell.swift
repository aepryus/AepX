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
	let flightNoLabel: UILabel = UILabel()
	let lineView: UIView = UIView()
	let patchView: UIImageView = UIImageView()
	let resultView: ResultView = ResultView()

	let pen: Pen = Pen(font: .axMedium(size: 16*Screen.s), color: .white)

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		flightNoLabel.pen = Pen(font: .axBold(size: 40*s), color: .axBackground, alignment: .right)
		addSubview(flightNoLabel)

		nameLabel.pen = Pen(font: .axBold(size: 19*s), color: .white)
		nameLabel.adjustsFontSizeToFitWidth = true
		addSubview(nameLabel)

		dateLabel.pen = pen
		addSubview(dateLabel)

        patchView.contentMode = .scaleAspectFit
		addSubview(patchView)
        
		addSubview(resultView)

		lineView.backgroundColor = UIColor.blue.tone(0.85).tint(0.1)
		addSubview(lineView)
	}
	required init?(coder: NSCoder) { fatalError() }

	func load(launch: Launch) {
		backgroundColor = launch.completed ? UIColor.axDarkBack : UIColor.axBackground.shade(0.2)

		nameLabel.text = launch.name
		dateLabel.text = "\(launch.date.format("MMM d, yyyy"))"
		flightNoLabel.text = "\(launch.flightNo)"

		if let urlString = launch.patch { patchView.loadImage(url: urlString) }
		else { patchView.cancelLoadImage() }

		resultView.result = launch.result
	}

// UITableViewCell =================================================================================
	override func layoutSubviews() {
		super.layoutSubviews()
		patchView.left(dx: 9*s, width: 48*s, height: 48*s)
		nameLabel.left(dx: patchView.right+12*s, dy: -12*s, width: width-(patchView.right+12*s)-12*s, height: 40*s)
		dateLabel.left(dx: nameLabel.left, dy: 12*s, width: 300*s, height: 48*s)
		flightNoLabel.right(dx: -12*s, width: 1000*s, height: 60*s)
		resultView.right(dx: -1*s, width: 4*s, height: baseHeight*0.6)
		lineView.bottom(width: width, height: 1)
	}
}
