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
	let container: UIView = UIView()
	let doneButton: DoneButton = DoneButton()

	private let sortsSpecifier: Specifier = Specifier(text: "sort by")
	private let shipsSpecifier: Specifier = Specifier(text: "boosters")
	private let statesSpecifier: Specifier = Specifier(text: "status")

	let sorts: [String] = ["Default", "Serial No."]
	let ships: [String] = ["All", "Falcon 9 block 5", "Falcon 9 block 4", "Falcon 9 FT", "Falcon 9 v1.1", "Falcon 9 v1.0", "Falcon 1"]
	let states: [String] = ["All", "Active", "Retired", "Expended", "Lost", "Destroyed"]

	init() {
		super.init(frame: .zero)

		line.backgroundColor = .white
		container.addSubview(line)

		sortsView.dataSource = self
		sortsView.delegate = self
		sortsView.tintColor = .white
		container.addSubview(sortsView)
		container.addSubview(sortsSpecifier)

		shipsView.dataSource = self
		shipsView.delegate = self
		shipsView.tintColor = .white
		container.addSubview(shipsView)
		container.addSubview(shipsSpecifier)

		statesView.dataSource = self
		statesView.delegate = self
		statesView.tintColor = .white
		container.addSubview(statesView)
		container.addSubview(statesSpecifier)

		container.backgroundColor = UIColor.axBackgroundColor.tone(-0.7).tint(0.2).alpha(0.7)
		addSubview(container)

		addSubview(doneButton)
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		let view: UIView? = super.hitTest(point, with: event)
		if view === self { return nil }
		return view
	}
	override func layoutSubviews() {
		container.bottom(width: width, height: 120*3*Screen.s + 12*Screen.s + Screen.navBottom)
		line.top(width: width, height: 1*s)

		let paddingWidth: CGFloat = 12*s
		let specifierWidth: CGFloat = 123*s
		let specifierHeight: CGFloat = 120*s
		let pickerWidth = width - specifierWidth - paddingWidth

		sortsSpecifier.topRight(dy: 2*s, width: specifierWidth, height: specifierHeight)
		sortsView.topLeft(dx: paddingWidth, dy: sortsSpecifier.top, width: pickerWidth, height: specifierHeight)

		shipsSpecifier.topRight(dy: sortsSpecifier.bottom, width: specifierWidth, height: specifierHeight)
		shipsView.topLeft(dx: paddingWidth, dy: shipsSpecifier.top, width: pickerWidth, height: specifierHeight)

		statesSpecifier.topRight(dy: shipsSpecifier.bottom, width: specifierWidth, height: specifierHeight)
		statesView.topLeft(dx: paddingWidth, dy: statesSpecifier.top, width: pickerWidth, height: specifierHeight)

		doneButton.topLeft(dx: 30*s, width: 132*s, height: 33*s)
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
