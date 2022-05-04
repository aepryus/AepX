//
//  LaunchExpansion.swift
//  AepX
//
//  Created by Joe Charlier on 5/4/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit
import YouTubeiOSPlayerHelper

class LaunchExpansion: UIView {
	let launch: Launch

	let player: YTPlayerView = YTPlayerView()

	init(launch: Launch) {
		self.launch = launch

		super.init(frame: .zero)

		backgroundColor = UIColor.aepXbackgroundColor

		player.layer.cornerRadius = 12*s
		player.layer.masksToBounds = true
		addSubview(player)

		if let youtubeID = launch.links?.youtubeId {
			player.load(withVideoId: youtubeID)
		}
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		player.center(width: 360*s, height: 180*s)
	}
}
