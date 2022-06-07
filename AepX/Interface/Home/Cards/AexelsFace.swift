//
//  AexelsFace.swift
//  AepX
//
//  Created by Joe Charlier on 5/23/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class AexelsFace: Face {
	let imageView: UIImageView = UIImageView()

	init() {
		super.init(frame: .zero)

		imageView.image = UIImage(named: "Aexels")
		addSubview(imageView)

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
	}
	required init?(coder: NSCoder) { fatalError() }

// Events ==========================================================================================
	@objc func onTap() {
		if let url = URL(string: "itms-apps://apple.com/app/id935727868") {
			UIApplication.shared.open(url)
		}
	}

// Face ============================================================================================
	override var faceHeight: CGFloat { 150*s * AepX.window.width/(375*s) }

// UIView ==========================================================================================
	override func layoutSubviews() {
		imageView.frame = bounds
	}
}
