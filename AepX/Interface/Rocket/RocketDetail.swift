//
//  RocketDetail.swift
//  AepX
//
//  Created by Joe Charlier on 5/5/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class RocketDetail: ExpandableCell {
	let core: Core
	let rocket: Rocket

	let serialLabel: UILabel = UILabel()
	let statusLabel: UILabel = UILabel()
	let reasonLabel: UILabel = UILabel()
	let blockLabel: UILabel = UILabel()
	let noteLabel: UILabel = UILabel()
	let rocketView: UIImageView = UIImageView()

	init(core: Core) {
		self.core = core

		if let rocket = core.launches.last?.rocket { self.rocket = rocket }
		else { rocket = .falcon9b5Dragon }

		super.init(style: .default, reuseIdentifier: nil)
		backgroundColor = UIColor.aepXbackgroundColor

		serialLabel.text = core.serial
		addSubview(serialLabel)

		statusLabel.text = core.disposition
		addSubview(statusLabel)

		reasonLabel.text = core.reason
		addSubview(reasonLabel)

		blockLabel.text = "\(core.block)"
		addSubview(blockLabel)

		noteLabel.text = core.note
		noteLabel.pen = Pen(font: UIFont(name: "AvenirNext-Medium", size: 18*s)!, color: .white)
		noteLabel.numberOfLines = 0
		addSubview(noteLabel)

		rocketView.image = rocket.image
		addSubview(rocketView)
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		super.layoutSubviews()
		serialLabel.topLeft(dx: 12*s, dy: 12*s, width: 300*s, height: 30*s)
		statusLabel.topLeft(dx: 12*s, dy: serialLabel.bottom, width: 300*s, height: 30*s)
		reasonLabel.topLeft(dx: 12*s, dy: statusLabel.bottom, width: 300*s, height: 30*s)
		blockLabel.topLeft(dx: 12*s, dy: reasonLabel.bottom, width: 300*s, height: 30*s)
		noteLabel.topLeft(dx: 12*s, dy: blockLabel.bottom, width: 300*s, height: 120*s)
		if let image = rocketView.image {
			let maxHeight: CGFloat = height*0.9
			let height: CGFloat = maxHeight*rocket.height
			rocketView.bottomRight(dx: -24*s, dy: -(self.height-maxHeight)/2, width: image.size.width*height/image.size.height, height: height)
		}
	}
}
