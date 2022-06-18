//
//  LaunchCore.swift
//  AepX
//
//  Created by Joe Charlier on 5/9/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class LaunchCore: Domain {
	@objc dynamic var apiid: String = ""
	@objc dynamic var resultString: String = ""

	var result: Result {
		set { resultString = newValue.toString() }
		get { Result.from(string: resultString) ?? .planned }
	}

// Domain ==========================================================================================
	override var properties: [String] {
		super.properties + ["apiid", "resultString"]
	}
}
