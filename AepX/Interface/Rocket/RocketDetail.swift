//
//  RocketDetail.swift
//  AepX
//
//  Created by Joe Charlier on 5/5/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

fileprivate class FlightsHeader: UIView {
	let label: UILabel = UILabel()
	let line: UIView = UIView()

	var flights: Int = 0 {
		didSet { label.text = (flights != 1 ? "\(flights) " + "flights".localized : "1 " + "flight".localized) }
	}

	init() {
		super.init(frame: .zero)

		backgroundColor = .axBorder

		label.pen = Pen(font: .axDemiBold(size: 19*s), color: .white)
		addSubview(label)

		line.backgroundColor = .axBorder.tint(0.3)
		addSubview(line)
	}
	required init?(coder: NSCoder) { fatalError() }


// UIView ==========================================================================================
	override func layoutSubviews() {
		label.left(dx: 12*s, width: 200*s, height: 30*s)
		line.top(width: width, height: 1*s)
	}
}

class RocketDetail: ExpandableCell {
	let core: Core
	let rocket: Rocket

	let serialLabel: UILabel = UILabel()
	let boosterLabel: UILabel = UILabel()
	let versionLabel: UILabel = UILabel()

	let statusLabel: UILabel = UILabel()

	let noteLabel: UILabel = UILabel()
	let rocketView: UIImageView = UIImageView()
	private let flightsHeader: FlightsHeader = FlightsHeader()

	init(core: Core) {
		self.core = core

		if let rocket = core.launches.first?.rocket { self.rocket = rocket }
		else { rocket = .falcon9b5 }

		super.init(style: .default, reuseIdentifier: nil)
		backgroundColor = .axBackground

		serialLabel.text = core.serial
		serialLabel.pen = Pen(font: .axDemiBold(size: 29*s), color: .white)
		addSubview(serialLabel)

		statusLabel.text = core.state
		statusLabel.pen = Pen(font: .axMedium(size: 15*s), color: .white)
		addSubview(statusLabel)

		boosterLabel.text = core.booster.name
		boosterLabel.pen = Pen(font: .axMedium(size: 17*s), color: .white, alignment: .right)
		addSubview(boosterLabel)

		versionLabel.text = core.version
		versionLabel.pen = Pen(font: .axMedium(size: 15*s), color: .white, alignment: .right)
		addSubview(versionLabel)

		noteLabel.text = core.note
		noteLabel.pen = Pen(font: .axMedium(size: 18*s), color: .white)
		noteLabel.numberOfLines = 0
		addSubview(noteLabel)

		rocketView.image = rocket.image
		addSubview(rocketView)

		flightsHeader.flights = core.launches.count
		addSubview(flightsHeader)
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		super.layoutSubviews()
		serialLabel.topLeft(dx: 12*s, dy: 12*s, width: 300*s, height: 30*s)
		statusLabel.topLeft(dx: 18*s, dy: serialLabel.bottom-8*s, width: 300*s, height: 30*s)
		if let image = rocketView.image {
			let maxHeight: CGFloat = height*0.8
			let height: CGFloat = maxHeight*rocket.height
			rocketView.bottomRight(dx: -18*s, dy: -(self.height-36*s-maxHeight)/2-36*s, width: image.size.width*height/image.size.height, height: height)
		}
		noteLabel.topLeft(width: rocketView.left-48*s, height: 200*s)
		noteLabel.sizeToFit()
		noteLabel.topLeft(dx: 12*s, dy: statusLabel.bottom+8*s)
		boosterLabel.topLeft(dx: rocketView.left-209*s, dy: height-110*s, width: 200*s, height: 30*s)
		versionLabel.topLeft(dx: boosterLabel.left-2*s, dy: boosterLabel.bottom-9*s, width: 200*s, height: 30*s)
		flightsHeader.bottom(width: width, height: 36*s)
	}
}
