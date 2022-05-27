//
//  RocketsFilterView.swift
//  AepX
//
//  Created by Joe Charlier on 5/15/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class RocketsFilterView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
	let line: UIView = UIView()

	let pickerView: UIPickerView = UIPickerView()

	init() {
		super.init(frame: .zero)
		backgroundColor = UIColor.axBackgroundColor.tone(-0.7).tint(0.2).alpha(0.7)

		line.backgroundColor = .white
		addSubview(line)

		pickerView.dataSource = self
		pickerView.delegate = self
		pickerView.tintColor = .white
		addSubview(pickerView)
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		line.top(width: width, height: 1*s)
		pickerView.top(dy: 100*s)
	}

// UIPickerViewDataSource ==========================================================================
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 6
	}

// UIPickerViewDelegate ============================================================================
	func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
		return ["All", "Active", "Retired", "Expended", "Destroyed after Success", "Destroyed before Success"][row].attributed(pen: Pen.axLabel)
	}
}
