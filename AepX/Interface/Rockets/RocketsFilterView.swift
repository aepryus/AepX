//
//  RocketsFilterView.swift
//  AepX
//
//  Created by Joe Charlier on 5/15/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class Specifier: UIView {
	let label: UILabel = UILabel()
	let line: UIView = UIView()

	init(text: String) {
		super.init(frame: .zero)

		label.text = text
		label.pen = .axLabel.clone(alignment: .left)
		addSubview(label)

		line.backgroundColor = .white
		addSubview(line)
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		line.left(width: 2*s, height: height*0.7)
		label.left(dx: 18*s, width: width-18*s, height: 30*s)
	}
}

class RocketsFilterView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
	let line: UIView = UIView()

	let sortsView: UIPickerView = UIPickerView()
	let shipsView: UIPickerView = UIPickerView()
	let statesView: UIPickerView = UIPickerView()

	private let sortsSpecifier: Specifier = Specifier(text: "sort by")
	private let shipsSpecifier: Specifier = Specifier(text: "boosters")
	private let statesSpecifier: Specifier = Specifier(text: "status")

	let sorts: [String] = ["Default", "Serial No."]
	let ships: [String] = ["All", "Falcon 1", "Falcon 9"]
	let states: [String] = ["All", "Active", "Retired", "Expended", "Lost", "Destroyed"]

	init() {
		super.init(frame: .zero)
		backgroundColor = UIColor.axBackgroundColor.tone(-0.7).tint(0.2).alpha(0.7)

		line.backgroundColor = .white
		addSubview(line)

		sortsView.dataSource = self
		sortsView.delegate = self
		sortsView.tintColor = .white
		addSubview(sortsView)
		addSubview(sortsSpecifier)

		shipsView.dataSource = self
		shipsView.delegate = self
		shipsView.tintColor = .white
		addSubview(shipsView)
		addSubview(shipsSpecifier)

		statesView.dataSource = self
		statesView.delegate = self
		statesView.tintColor = .white
		addSubview(statesView)
		addSubview(statesSpecifier)
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		line.top(width: width, height: 1*s)

		sortsView.topLeft(dx: 12*s, dy: 12*s, width: 240*s, height: 120*s)
		sortsSpecifier.topLeft(dx: sortsView.right, dy: sortsView.top, width: width-sortsView.right, height: sortsView.height)

		shipsView.topLeft(dx: 12*s, dy: sortsView.bottom, width: 240*s, height: 120*s)
		shipsSpecifier.topLeft(dx: shipsView.right, dy: shipsView.top, width: width-shipsView.right, height: shipsView.height)

		statesView.topLeft(dx: 12*s, dy: shipsView.bottom, width: 240*s, height: 120*s)
		statesSpecifier.topLeft(dx: statesView.right, dy: statesView.top, width: width-statesView.right, height: statesView.height)
	}

// UIPickerViewDataSource ==========================================================================
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		switch pickerView {
			case sortsView: return sorts.count
			case shipsView: return ships.count
			case pickerView: return states.count
			default: fatalError()
		}
	}

// UIPickerViewDelegate ============================================================================
	func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
		let text: String
		switch pickerView {
			case sortsView: text = sorts[row]
			case shipsView: text = ships[row]
			case pickerView: text = states[row]
			default: fatalError()
		}
		return text.attributed(pen: .axLabel)
	}
}
