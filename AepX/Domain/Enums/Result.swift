//
//  Result.swift
//  AepX
//
//  Created by Joe Charlier on 6/18/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit

enum Result: CaseIterable {
	case planned, landed, partial, lost, expended, failed, tested

	var color: UIColor {
		let tonePercent: CGFloat = 0.6
		switch self {
			case .planned:	return .white.tone(tonePercent)
			case .landed:	return .blue.tone(tonePercent)
			case .partial:	return .purple.tone(tonePercent)
			case .lost:		return .orange.tone(tonePercent)
			case .expended:	return .cyan.tone(tonePercent)
			case .failed:	return .red.tone(tonePercent)
            case .tested:   return .yellow.tone(tonePercent)
		}
	}
}
