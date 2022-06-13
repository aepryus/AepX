//
//  ResultView.swift
//  AepX
//
//  Created by Joe Charlier on 6/6/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit

class ResultView: UIView {
	var result: Launch.Result? = nil {
		didSet { backgroundColor = result?.color }
	}

	init() {
		super.init(frame: .zero)
		layer.borderColor = UIColor.black.cgColor
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		let size: CGFloat = min(width, height)
		layer.cornerRadius = size/2
		layer.borderWidth = size/20
	}
}
