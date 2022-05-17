//
//  LinkView.swift
//  AepX
//
//  Created by Joe Charlier on 5/17/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit

class LinkView: UIImageView {
	var urlString: String? = nil

	init() {
		super.init(frame: .zero)
		isUserInteractionEnabled = true
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
	}
	required init?(coder: NSCoder) { fatalError() }

// Events ==========================================================================================
	@objc func onTap() {
		if let urlString = urlString, let url = URL(string: urlString) { UIApplication.shared.open(url) }
	}
}
