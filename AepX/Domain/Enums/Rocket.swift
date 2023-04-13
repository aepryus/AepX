//
//  Rocket.swift
//  AepX
//
//  Created by Joe Charlier on 6/18/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit

enum Rocket {
	case falcon1
	case falcon9v10
	case falcon9v11Dragon, falcon9v11, falcon9v11NoLegs
	case falcon9v12Dragon, falcon9v12, falcon9v12NoLegs
	case falcon9b5Dragon, falcon9b5, falcon9b5NoLegs
	case falconHeavy, falconHeavyb5
    case starship

	var height: Double {
		let height: Double
		switch self {
			case .falcon1:
				height = 59.6
			case .falcon9v10:
				height = 142.9
			case .falcon9v11Dragon:
				height = 185
			case .falcon9v11, .falcon9v11NoLegs:
				height = 203.4
			case .falcon9v12Dragon:
				height = 190.7
			case .falcon9b5Dragon:
				height = 192.8
            case .starship:
                height = 354.3 // 119 * 208.4 / 70
			default:
				height = 208.4
		}
		return height/354.3
	}

	var isFalcon1: Bool { self == .falcon1 }
	var isFalcon9: Bool {
		[	Rocket.falcon9v10,
			Rocket.falcon9v11,
			Rocket.falcon9v11Dragon,
			Rocket.falcon9v11NoLegs,
			Rocket.falcon9v12,
			Rocket.falcon9v12Dragon,
			Rocket.falcon9v12NoLegs,
			Rocket.falcon9b5,
			Rocket.falcon9b5Dragon,
			Rocket.falcon9b5NoLegs
		].contains(self)
	}
	var isFalconHeavy: Bool {
		[	Rocket.falconHeavy,
			Rocket.falconHeavyb5
		].contains(self)
	}
    var isStarship: Bool { self == .starship }

	var image: UIImage {
		switch self {
			case .falcon1:			return UIImage(named: "Falcon1")!
			case .falcon9v10:		return UIImage(named: "Falcon9v10")!
			case .falcon9v11Dragon:	return UIImage(named: "Falcon9v11Dragon")!
			case .falcon9v11:		return UIImage(named: "Falcon9v11")!
			case .falcon9v11NoLegs:	return UIImage(named: "Falcon9v11NoLegs")!
			case .falcon9v12Dragon:	return UIImage(named: "Falcon9v12Dragon")!
			case .falcon9v12:		return UIImage(named: "Falcon9v12")!
			case .falcon9v12NoLegs:	return UIImage(named: "Falcon9v12NoLegs")!
			case .falcon9b5Dragon:	return UIImage(named: "Falcon9b5Dragon")!
			case .falcon9b5:		return UIImage(named: "Falcon9b5")!
			case .falcon9b5NoLegs:	return UIImage(named: "Falcon9b5NoLegs")!
			case .falconHeavy:		return UIImage(named: "FalconHeavy")!
			case .falconHeavyb5:	return UIImage(named: "FalconHeavyb5")!
            case .starship:         return UIImage(named: "Starship")!
		}
	}
}
