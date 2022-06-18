//
//  Booster.swift
//  AepX
//
//  Created by Joe Charlier on 6/18/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation

enum Booster {
	case falcon1, falcon9

	var generation: Int { self == .falcon1 ? 1 : 2 }
	var name: String {
		switch self {
			case .falcon1: return "Falcon 1"
			case .falcon9: return "Falcon 9"
		}
	}
}
