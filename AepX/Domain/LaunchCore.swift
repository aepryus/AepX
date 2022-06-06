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
	enum Result {
		case pending, destroyed, expended, landed, lost

		var color: UIColor {
			let tonePercent: CGFloat = 0.6
			switch self {
				case .pending:		return .white.tone(tonePercent)
				case .destroyed:	return .red.tone(tonePercent)
				case .landed:		return .blue.tone(tonePercent)
				case .lost:			return .orange.tone(tonePercent)
				case .expended:		return .cyan.tone(tonePercent)
			}
		}
	}

	@objc dynamic var apiid: String = ""
	@objc dynamic var pending: Bool = false
	@objc dynamic var destroyed: Bool = false
	@objc dynamic var landingAttempt: Bool = false
	@objc dynamic var landingSuccess: Bool = false

	var result: Result {
		if pending { return .pending }
		else if destroyed { return .destroyed }
		else if landingAttempt {
			if landingSuccess { return .landed }
			else { return .lost }
		} else { return .expended }
	}

// Domain ==========================================================================================
	override var properties: [String] {
		super.properties + ["apiid", "pending", "destroyed", "landingAttempt", "landingSuccess"]
	}
}
