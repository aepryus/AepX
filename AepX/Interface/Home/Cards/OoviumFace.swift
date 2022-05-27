//
//  OoviumFace.swift
//  AepX
//
//  Created by Joe Charlier on 5/23/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit

class OoviumFace: Face {
	let imageView: UIImageView = UIImageView()

	init() {
		super.init(frame: .zero)

		imageView.image = UIImage(named: "Oovium")
		addSubview(imageView)

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
	}
	required init?(coder: NSCoder) { fatalError() }

// Events ==========================================================================================
	@objc func onTap() {
		if let url = URL(string: "itms-apps://apple.com/app/id336573328") {
			UIApplication.shared.open(url)
		}
	}

// Face ============================================================================================
	override var faceHeight: CGFloat { 150*s }

// UIView ==========================================================================================
	override func layoutSubviews() {
		imageView.frame = bounds
	}
}
