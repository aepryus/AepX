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
	let line: UIView = UIView()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		backgroundColor = .axDarkBack

		label.pen = Pen(font: .axDemiBold(size: 19*s), color: .white, alignment: .center)
		addSubview(label)

		line.backgroundColor = .axBorder.tint(0.3)
		addSubview(line)
	}
	required init?(coder: NSCoder) { fatalError() }

	var numberOfLaunches: Int {
		set { label.text = "\(newValue) launches queried" }
		get { fatalError() }
	}

// UIView ==========================================================================================
	override func layoutSubviews() {
		super.layoutSubviews()
		label.center(width: 320*s, height: 50*s)
		line.bottom(width: width, height: 1*s)
	}
}
