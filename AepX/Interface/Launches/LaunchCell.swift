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

	let pen: Pen = Pen(font: UIFont(name: "AvenirNext-Medium", size: 16*Screen.s)!, color: .white, alignment: .left)

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		flightNoLabel.pen = Pen(font: UIFont(name: "AvenirNext-Bold", size: 40*Screen.s)!, color: .axBackgroundColor, alignment: .right)
		addSubview(flightNoLabel)

		nameLabel.textColor = .white
		nameLabel.font = UIFont(name: "AvenirNext-Bold", size: 19*s)
		nameLabel.adjustsFontSizeToFitWidth = true
		addSubview(nameLabel)

		dateLabel.pen = pen
		addSubview(dateLabel)

		addSubview(patchView)
		addSubview(resultView)

		lineView.backgroundColor = UIColor.blue.tone(0.85).tint(0.1)
		addSubview(lineView)
	}
	required init?(coder: NSCoder) { fatalError() }

	func load(launch: Launch) {
		backgroundColor = launch.completed ? UIColor.axBackgroundColor.shade(0.5) : UIColor.axBackgroundColor.shade(0.2)

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
//		patchView.left(dx: 8*s, width: 48*s, height: 48*s)
//		nameLabel.left(dx: patchView.right+12*s, dy: -12*s, width: width-(patchView.right+12*s)-12*s-16*s, height: 40*s)
//		dateLabel.left(dx: nameLabel.left, dy: 12*s, width: 300*s, height: 48*s)
//		resultView.right(dx: -7*s, width: 6*s, height: 36*s)
//		flightNoLabel.left(dx: resultView.left-109*s, width: 100*s, height: 60*s)
//		lineView.bottom(width: width, height: 1)
		patchView.left(dx: 9*s, width: 48*s, height: 48*s)
		nameLabel.left(dx: patchView.right+12*s, dy: -12*s, width: width-(patchView.right+12*s)-12*s, height: 40*s)
		dateLabel.left(dx: nameLabel.left, dy: 12*s, width: 300*s, height: 48*s)
		flightNoLabel.right(dx: -9*s, width: 1000*s, height: 60*s)
		lineView.bottom(width: width, height: 1)
		resultView.topRight(dx: 13*s, dy: -13*s, width: 27*s, height: 27*s)
	}
}
