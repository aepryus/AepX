//
//  NextFace.swift
//  AepX
//
//  Created by Joe Charlier on 5/1/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class NextFace: Face {
	var launch: Launch? = nil {
		didSet {
			guard let launch = launch else { return }
			nameLabel.text = launch.name
			if let url = launch.patch {
				patchView.loadImage(url: url)
			}
			if launch.hasVideo, let youtubeID = launch.youtubeID {
				youTubeView.load(id: youtubeID)
				addSubview(youTubeView)
			} else {
				youTubeView.removeFromSuperview()
			}
		}
	}

	let titleLabel: UILabel = UILabel()
	let nameLabel: UILabel = UILabel()
	let patchView: UIImageView = UIImageView()
	let countDownView: CountDownView = CountDownView()
	let youTubeView: YouTubeView = YouTubeView()

	let timer: AETimer = AETimer()

	init() {
		super.init(frame: .zero)

		titleLabel.text = "Next Launch".localized
		titleLabel.textColor = .white
		titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 23*s)
		addSubview(titleLabel)

		nameLabel.textColor = .white
		nameLabel.font = UIFont(name: "AvenirNext-Medium", size: 18*s)
		addSubview(nameLabel)

		addSubview(countDownView)
		
		addSubview(patchView)

		timer.configure(interval: 1) { [weak self] in
			DispatchQueue.main.async {
				guard let launch = self?.launch else { return }
				self?.countDownView.dateComponents = launch.relativeDateComponents
			}
		}
		timer.start()
	}
	required init?(coder: NSCoder) { fatalError() }

// Face ============================================================================================
	override var faceHeight: CGFloat { 150*s + (launch?.hasVideo ?? false ? 190*s : 0) }

// UIView ==========================================================================================
	override func layoutSubviews() {
		titleLabel.topLeft(dx: 12*s, dy: 10*s, width: 300*s, height: 30*s)
		nameLabel.topLeft(dx: 12*s, dy: titleLabel.bottom, width: 300*s, height: 30*s)
		patchView.topRight(dx: -12*s, dy: 10*s, width: 70*s, height: 70*s)
		countDownView.topRight(dx: -8*s, dy: patchView.bottom+8*s, width: 200*s, height: 43*s)
		youTubeView.top(dy: countDownView.bottom+10*s, width: 320*s, height: 180*s)
	}
}
