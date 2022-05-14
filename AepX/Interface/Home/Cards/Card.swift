//
//  Card.swift
//  AepX
//
//  Created by Joe Charlier on 5/1/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class Face: UIView {
	var faceHeight: CGFloat { 80*s }
}

class Card: UITableViewCell {
	let face: Face
	var cardHeight: CGFloat { face.faceHeight + 20*s }
	let faceView: UIView = UIView()

	init(face: Face) {
		self.face = face
		super.init(style: .default, reuseIdentifier: nil)

		faceView.backgroundColor = UIColor.axBackgroundColor.shade(0.5)
		faceView.layer.cornerRadius = 12*s
		faceView.layer.masksToBounds = true
		faceView.layer.borderColor = UIColor.blue.tone(0.85).tint(0.1).cgColor
		faceView.layer.borderWidth = 2*s

		faceView.addSubview(self.face)
		contentView.addSubview(faceView)
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		faceView.frame = bounds.insetBy(dx: 10*s, dy: 12*s)
		face.frame = faceView.bounds
	}
}
