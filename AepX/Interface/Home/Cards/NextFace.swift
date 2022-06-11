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
	var controller: HomeController?
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

			let core: Core? = Loom.selectOne(where: "serial", is: "B1060")
			guard let core = core else { return }
			coreLabel.text = core.serial
			patchesView.load(core: core)
		}
	}

	let titleLabel: UILabel = UILabel()
	let nameLabel: UILabel = UILabel()
	let patchView: UIImageView = UIImageView()
	let countDownView: CountDownView = CountDownView()
	let coreLabel: UILabel = UILabel()
	let patchesView: PatchesView = PatchesView(size: 27*Screen.s)
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

		coreLabel.pen = Pen(font: .axMedium(size: 19*s), color: .white, alignment: .left)
		addSubview(coreLabel)

		addSubview(patchesView)

		timer.configure(interval: 1) { [weak self] in
			DispatchQueue.main.async {
				guard let launch = self?.launch else { return }
				self?.countDownView.dateComponents = launch.relativeDateComponents
			}
		}
		timer.start()

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
	}
	required init?(coder: NSCoder) { fatalError() }

// Events ==========================================================================================
	@objc func onTap() {
		controller?.onNextFaceTapped()
	}

// Face ============================================================================================
	override var faceHeight: CGFloat { 150*s + (true/*launches.core != nil*/ ? 42*s : 0) + (launch?.hasVideo ?? false ? 190*s : 0) }

// UIView ==========================================================================================
	override func layoutSubviews() {
		var dy: CGFloat = 10*s

		titleLabel.topLeft(dx: 12*s, dy: dy, width: 300*s, height: 30*s)
		nameLabel.topLeft(dx: 12*s, dy: titleLabel.bottom, width: 300*s, height: 30*s)

		patchView.topRight(dx: -12*s, dy: dy, width: 70*s, height: 70*s)
		dy = patchView.bottom+8*s

		if true/*launch?.cores.count ?? 0 > 0*/ {
			coreLabel.topLeft(dx: 12*s, dy: dy, width: 150*s, height: 30*s)
			patchesView.topRight(dx: -20*s, dy: dy, width: patchesView.patchesWidth, height: 30*s)
			dy += 42*s
		}

		countDownView.topRight(dx: -8*s, dy: dy, width: 200*s, height: 43*s)
		youTubeView.top(dy: countDownView.bottom+10*s, width: 320*s, height: 180*s)
	}
}
