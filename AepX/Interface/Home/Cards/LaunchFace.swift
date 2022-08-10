//
//  LaunchFace.swift
//  AepX
//
//  Created by Joe Charlier on 6/12/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class LaunchFace: Face {
	private var controller: HomeController?
	private var launch: Launch?

	let titleLabel: UILabel = UILabel()
	let nameLabel: UILabel = UILabel()
	let patchView: UIImageView = UIImageView()
	let countDownView: CountDownView = CountDownView()
	var boosterViews: [BoosterView] = []
	let patchesView: PatchesView = PatchesView(size: 27*Screen.s)
	let youTubeView: YouTubeView = YouTubeView()

	let timer: AETimer = AETimer()

	init(title: String) {
		super.init(frame: .zero)

		titleLabel.text = title
		titleLabel.pen = Pen(font: .axMedium(size: 15*s), color: .white)
		addSubview(titleLabel)

		nameLabel.pen = Pen(font: .axHeavy(size: 20*s), color: .white)
		addSubview(nameLabel)

		addSubview(patchView)
		addSubview(countDownView)
		addSubview(patchesView)

		timer.configure(interval: 1) { [weak self] in
			DispatchQueue.main.async {
				guard let launch = self?.launch else { return }
				self?.countDownView.dateComponents = launch.relativeDateComponents
			}
		}
		timer.start()

	}
	required init?(coder: NSCoder) { fatalError() }

	func load(controller: HomeController, launch: Launch) {
		self.controller = controller
		self.launch = launch

		nameLabel.text = launch.name
		if let url = launch.patch {
			patchView.loadImage(url: url)
        } else {
            patchView.cancelLoadImage()
        }

		if launch.hasVideo, let youtubeID = launch.youtubeID {
			youTubeView.load(id: youtubeID)
			addSubview(youTubeView)
		} else { youTubeView.removeFromSuperview() }

        boosterViews.forEach { $0.removeFromSuperview() }
		if launch.hasCores {
			boosterViews = launch.launchCores.compactMap {
				let boosterView: BoosterView = BoosterView()
				boosterView.load(delegate: controller, launchCore: $0)
				addSubview(boosterView)
				return boosterView
			}
		}
	}

// Face ============================================================================================
	override var faceHeight: CGFloat {
		var height: CGFloat = 72*s
		let p: CGFloat = 12*s
		if let launch = launch {
			if launch.hasVideo { height += 180*s * AepX.widthScale + p }
			if launch.hasCores { height += 30*s*CGFloat(launch.launchCores.count) + p }
			if launch.date >= Date.now { height += 43*s + p }
			height += 6*s
		}
		return height
	}

// UIView ==========================================================================================
	override func layoutSubviews() {
		guard let launch = launch else { return }

		var dy: CGFloat = 10*s

		titleLabel.topLeft(dx: 18*s, dy: dy, width: 300*s, height: 18*s)
		nameLabel.topLeft(dx: 12*s, dy: titleLabel.bottom, width: width-75*s, height: 30*s)

		patchView.topRight(dx: -12*s, dy: dy, width: 48*s, height: 48*s)

		dy = patchView.bottom + 12*s

		if launch.hasVideo {
			youTubeView.top(dy: dy, width: 320*s * AepX.widthScale, height: 180*s * AepX.widthScale)
			dy += youTubeView.height + 12*s
		}

		if launch.hasCores {
			boosterViews.forEach {
				$0.topLeft(dx: 12*s, dy: dy, width: width-24*s, height: 30*s)
				dy += 30*s
			}
			dy += 12*s
		}

		if launch.date >= Date.now {
			countDownView.topRight(dx: -8*s, dy: dy, width: 200*s, height: 43*s)
		}
	}
}
