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
	init() {
		super.init(style: .default, reuseIdentifier: nil)
		backgroundColor = UIColor.red
	}
	required init?(coder: NSCoder) { fatalError() }

}
