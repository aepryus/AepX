//
//  RocketsFooterCell.swift
//  AepX
//
//  Created by Joe Charlier on 5/30/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class RocketsFooterCell: UITableViewCell {
	let label: UILabel = UILabel()
	let line: UIView = UIView()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		backgroundColor = .axBackgroundColor.shade(0.5)

		label.pen = Pen(font: .axDemiBold(size: 19*s), color: .white, alignment: .center)
		addSubview(label)

		line.backgroundColor = .axBorderColor.tint(0.3)
		addSubview(line)
	}
	required init?(coder: NSCoder) { fatalError() }

	var numberOfRockets: Int {
		set { label.text = "\(newValue) rockets queried" }
		get { fatalError() }
	}

// UIView ==========================================================================================
	override func layoutSubviews() {
		super.layoutSubviews()
		label.center(width: 320*s, height: 50*s)
		line.bottom(width: width, height: 1*s)
	}
}
