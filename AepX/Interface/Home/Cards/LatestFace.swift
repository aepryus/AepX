//
//  LatestFace.swift
//  AepX
//
//  Created by Joe Charlier on 5/1/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit
import YouTubeiOSPlayerHelper

class LatestFace: Face {
	var launch: Launch? = nil {
		didSet {
			guard let launch = launch else { return }
			nameLabel.text = launch.name
			if let url = launch.patch {
				patchView.loadImage(url: url)
			}
			if let youtubeID = launch.youtubeID {
				youTubeView.load(id: youtubeID)
			}
		}
	}

	let titleLabel: UILabel = UILabel()
	let nameLabel: UILabel = UILabel()
	let patchView: UIImageView = UIImageView()
	let youTubeView: YouTubeView = YouTubeView()

	init() {
		super.init(frame: .zero)

		titleLabel.text = "Latest Launch".localized
		titleLabel.textColor = .white
		titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 23*s)
		addSubview(titleLabel)

		nameLabel.textColor = .white
		nameLabel.font = UIFont(name: "AvenirNext-Medium", size: 18*s)
		addSubview(nameLabel)

		addSubview(patchView)

		addSubview(youTubeView)
	}
	required init?(coder: NSCoder) { fatalError() }

// Face ============================================================================================
	override var faceHeight: CGFloat { 300*s }

// UIView ==========================================================================================
	override func layoutSubviews() {
		titleLabel.topLeft(dx: 12*s, dy: 10*s, width: 300*s, height: 30*s)
		nameLabel.topLeft(dx: 12*s, dy: titleLabel.bottom, width: 300*s, height: 30*s)
		patchView.topRight(dx: -12*s, dy: 10*s, width: 70*s, height: 70*s)
		youTubeView.top(dy: 98*s, width: 320*s, height: 180*s)
	}
}
