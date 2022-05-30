//
//  LaunchesFooterCell.swift
//  AepX
//
//  Created by Joe Charlier on 5/30/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class LaunchesFooterCell: ExpandableCell {
	let label: UILabel = UILabel()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		label.pen = .axValue
		addSubview(label)

		backgroundColor = .axBackgroundColor.shade(0.5)
	}
	required init?(coder: NSCoder) { fatalError() }

	var numberOfLaunches: Int {
		set { label.text = "[\(newValue)] launches queried" }
		get { fatalError() }
	}

// UIView ==========================================================================================
	override func layoutSubviews() {
		super.layoutSubviews()
		label.left(dx: 12*s, width: 320*s, height: 50*s)
	}
}
