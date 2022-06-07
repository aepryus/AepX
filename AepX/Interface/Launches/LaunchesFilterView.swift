//
//  LaunchesFilterView.swift
//  AepX
//
//  Created by Joe Charlier on 5/15/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class LaunchesFilterView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {

	private let line: UIView = UIView()

	let rocketsView: UIPickerView = UIPickerView()
	let missionsView: UIPickerView = UIPickerView()
	let landingsView: UIPickerView = UIPickerView()

	private let rocketsSpecifier: Specifier = Specifier(text: "rockets")
	private let missionsSpecifier: Specifier = Specifier(text: "mission")
	private let landingsSpecifier: Specifier = Specifier(text: "landing")

	let rockets: [String] = ["All", "Falcon 1", "Falcon 9", "Falcon Heavy"]
	let missions: [String] = ["All", "Planned", "Succeeded", "Failed"]
	let landings: [String] = ["All", "Landed", "Lost", "Expended"]

	init() {
		super.init(frame: .zero)
		backgroundColor = UIColor.axBackgroundColor.tone(-0.7).tint(0.2).alpha(0.7)

		line.backgroundColor = .white
		addSubview(line)

		rocketsView.dataSource = self
		rocketsView.delegate = self
		rocketsView.tintColor = .white
		addSubview(rocketsView)
		addSubview(rocketsSpecifier)

		missionsView.dataSource = self
		missionsView.delegate = self
		missionsView.tintColor = .white
		addSubview(missionsView)
		addSubview(missionsSpecifier)

		landingsView.dataSource = self
		landingsView.delegate = self
		landingsView.tintColor = .white
		addSubview(landingsView)
		addSubview(landingsSpecifier)
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		line.top(width: width, height: 1*s)

		let paddingWidth: CGFloat = 12*s
		let specifierWidth: CGFloat = 123*s
		let specifierHeight: CGFloat = 120*s
		let pickerWidth = width - specifierWidth - paddingWidth

		rocketsSpecifier.topRight(dy: 2*s, width: specifierWidth, height: specifierHeight)
		rocketsView.topLeft(dx: paddingWidth, dy: rocketsSpecifier.top, width: pickerWidth, height: specifierHeight)

		missionsSpecifier.topRight(dy: rocketsSpecifier.bottom, width: specifierWidth, height: specifierHeight)
		missionsView.topLeft(dx: paddingWidth, dy: missionsSpecifier.top, width: pickerWidth, height: specifierHeight)

		landingsSpecifier.topRight(dy: missionsSpecifier.bottom, width: specifierWidth, height: specifierHeight)
		landingsView.topLeft(dx: paddingWidth, dy: landingsSpecifier.top, width: pickerWidth, height: specifierHeight)
	}

// UIPickerViewDataSource ==========================================================================
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		switch pickerView {
			case rocketsView: return rockets.count
			case missionsView: return missions.count
			case landingsView: return landings.count
			default: fatalError()
		}
	}

// UIPickerViewDelegate ============================================================================
	func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
		let text: String
		switch pickerView {
			case rocketsView: text = rockets[row]
			case missionsView: text = missions[row]
			case landingsView: text = landings[row]
			default: fatalError()
		}
		return text.attributed(pen: .axLabel)
	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		guard pickerView == missionsView else { return }
		if missionsView.selectedRow(inComponent: 0) == 0 || missionsView.selectedRow(inComponent: 0) == 2 {
			landingsView.isUserInteractionEnabled = true
			landingsView.alpha = 1
			landingsSpecifier.alpha = 1
		} else {
			landingsView.isUserInteractionEnabled = false
			landingsView.alpha = 0.3
			landingsSpecifier.alpha = 0.3
		}
	}
}
