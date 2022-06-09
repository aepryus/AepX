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
	let container: UIView = UIView()
	let doneButton: DoneButton = DoneButton()

	private let rocketsSpecifier: Specifier = Specifier(text: "rockets")
	private let missionsSpecifier: Specifier = Specifier(text: "mission")
	private let landingsSpecifier: Specifier = Specifier(text: "landing")

	let rockets: [String] = ["All", "Falcon 1", "Falcon 9", "Falcon Heavy"]
	let missions: [String] = ["All", "Planned", "Succeeded", "Failed"]
	let landings: [String] = ["All", "Landed", "Lost", "Expended"]

	init() {
		super.init(frame: .zero)

		line.backgroundColor = .white
		container.addSubview(line)

		rocketsView.dataSource = self
		rocketsView.delegate = self
		rocketsView.tintColor = .white
		container.addSubview(rocketsView)
		container.addSubview(rocketsSpecifier)

		missionsView.dataSource = self
		missionsView.delegate = self
		missionsView.tintColor = .white
		container.addSubview(missionsView)
		container.addSubview(missionsSpecifier)

		landingsView.dataSource = self
		landingsView.delegate = self
		landingsView.tintColor = .white
		container.addSubview(landingsView)
		container.addSubview(landingsSpecifier)

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

		rocketsSpecifier.topRight(dy: 2*s, width: specifierWidth, height: specifierHeight)
		rocketsView.topLeft(dx: paddingWidth, dy: rocketsSpecifier.top, width: pickerWidth, height: specifierHeight)

		missionsSpecifier.topRight(dy: rocketsSpecifier.bottom, width: specifierWidth, height: specifierHeight)
		missionsView.topLeft(dx: paddingWidth, dy: missionsSpecifier.top, width: pickerWidth, height: specifierHeight)

		landingsSpecifier.topRight(dy: missionsSpecifier.bottom, width: specifierWidth, height: specifierHeight)
		landingsView.topLeft(dx: paddingWidth, dy: landingsSpecifier.top, width: pickerWidth, height: specifierHeight)

		doneButton.topLeft(dx: 30*s, width: 132*s, height: 33*s)
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
