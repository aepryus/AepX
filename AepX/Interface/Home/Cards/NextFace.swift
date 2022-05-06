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
			blastOffLabel.text = launch.relative
			if let url = launch.links?.patch?.small {
				patchView.loadImage(url: url)
			}
		}
	}

	let titleLabel: UILabel = UILabel()
	let nameLabel: UILabel = UILabel()
	let patchView: UIImageView = UIImageView()
	let blastOffLabel: UILabel = UILabel()

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

		blastOffLabel.textColor = .white
		blastOffLabel.font = UIFont(name: "AvenirNext-Medium", size: 18*s)
		addSubview(blastOffLabel)
		
		addSubview(patchView)

		timer.configure(interval: 1) { [weak self] in
			DispatchQueue.main.async {
				self?.blastOffLabel.text = self?.launch?.relative
			}
		}
		timer.start()
	}
	required init?(coder: NSCoder) { fatalError() }

// Face ============================================================================================
	override var faceHeight: CGFloat { 120*s }

// UIView ==========================================================================================
	override func layoutSubviews() {
		titleLabel.topLeft(dx: 12*s, dy: 10*s, width: 300*s, height: 30*s)
		nameLabel.topLeft(dx: 12*s, dy: titleLabel.bottom, width: 300*s, height: 30*s)
		blastOffLabel.topLeft(dx: 12*s, dy: nameLabel.bottom, width: 300*s, height: 30*s)
		patchView.topRight(dx: -12*s, dy: 10*s, width: 70*s, height: 70*s)
	}
}
