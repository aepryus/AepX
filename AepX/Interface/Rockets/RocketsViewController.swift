//
//  RocketsViewController.swift
//  AepX
//
//  Created by Joe Charlier on 4/29/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class RocketsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	lazy var controller: RocketsController = { RocketsController(vc: self) }()

	let backView: UIImageView = UIImageView()
	let tableView: UITableView = UITableView()
	let footerCell: RocketsFooterCell = RocketsFooterCell()

	let shield: UIView = UIView()
	let filter: RocketsFilterView = RocketsFilterView()

	var activeCores: [Core] = []
	var inactiveCores: [Core] = []

	func loadData() {
		activeCores = []
		inactiveCores = []

		let cores: [Core] = Loom.selectAll().filter { (core: Core) in
			var result: Bool = true
			switch filter.statesView.selectedRow(inComponent: 0) {
				case 1: if core.state != "active" { result = false }
				case 2: if core.state != "retired" { result = false }
				case 3: if core.state != "expended" { result = false }
				case 4: if core.state != "lost" && core.state != "oops" { result = false }
				case 5: if core.state != "destroyed" { result = false }
				default: break
			}
			switch filter.shipsView.selectedRow(inComponent: 0) {
				case 1: if core.booster != .falcon1 { result = false }
				case 2: if core.booster != .falcon9 { result = false }
				default: break
			}
			return result
		}


		if filter.sortsView.selectedRow(inComponent: 0) == 0 {
			cores.forEach {
				if $0.coreStatus == "active" { activeCores.append($0) }
				else { inactiveCores.append($0) }
			}
			activeCores.sort(by: { (a: Core, b: Core) in
				if a.launches.count != b.launches.count { return a.launches.count > b.launches.count }
				return a.serial < b.serial
			})
			inactiveCores.sort(by: { (a: Core, b: Core) in
				if a.launches.count != b.launches.count { return a.launches.count > b.launches.count }
				if let aLast = a.launches.last, let bLast = b.launches.last {
					return aLast.date > bLast.date
				}
				return a.serial < b.serial
			})
		} else {
			activeCores = cores
			activeCores.sort(by:  { (a: Core, b: Core) in
				if a.booster.generation == b.booster.generation { return a.serial > b.serial }
				return a.booster.generation > b.booster.generation
			})
		}

		tableView.reloadData()
	}

	func toggleFilter() {
		let filterHeight: CGFloat = 500*s
		if filter.superview == nil {
			view.addSubview(shield)
			view.addSubview(filter)
			filter.bottom(dy: filterHeight, width: view.width, height: filterHeight)
			shield.alpha = 0
			UIView.animate(withDuration: 0.2) {
				self.filter.bottom(width: self.view.width, height: filterHeight)
				self.shield.alpha = 1
			}
		} else {
			UIView.animate(withDuration: 0.2) {
				self.filter.bottom(dy: filterHeight, width: self.view.width, height: filterHeight)
				self.shield.alpha = 0
//				self.filter.unload()
				self.loadData()
			} completion: { (completed: Bool) in
				self.filter.removeFromSuperview()
				self.shield.removeFromSuperview()
			}
		}
	}

// UIViewController ================================================================================
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.axBackgroundColor

		navigationController?.navigationBar.tintColor = .white
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: controller, action: #selector(RocketsController.onFilterTapped))

		backView.image = UIImage(named: "Starship")
		view.addSubview(backView)

		tableView.backgroundColor = UIColor.clear
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(RocketCell.self, forCellReuseIdentifier: "cell")
		tableView.allowsSelection = false
		tableView.rowHeight = 70*s
		tableView.sectionHeaderTopPadding = 0
		if Screen.mac { tableView.perform(NSSelectorFromString("_setSupportsPointerDragScrolling:"), with: true) }
		view.addSubview(tableView)

		shield.backgroundColor = .black.alpha(0.8)
		shield.addGestureRecognizer(UITapGestureRecognizer(target: controller, action: #selector(RocketsController.onFilterTapped)))

		loadData()
	}
	override func viewWillLayoutSubviews() {
		backView.frame = view.bounds
		tableView.frame = view.bounds
		shield.frame = view.bounds
	}

// UITableViewDataSource ===========================================================================
	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
			case 0: return activeCores.count
			case 1: return inactiveCores.count
			case 2: return 1
			default: fatalError()
		}
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section < 2 {
			let cell: RocketCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RocketCell
			cell.load(delegate: controller, core: indexPath.section == 0 && activeCores.count > 0 ? activeCores[indexPath.row] : inactiveCores[indexPath.row])
			return cell
		} else {
			footerCell.numberOfRockets = activeCores.count + inactiveCores.count
			return footerCell
		}

	}

// UITableViewDelegate =============================================================================
	class HeaderView: UIView {
		let label: UILabel = UILabel()
		let line: UIView = UIView()

		init(_ title: String) {
			super.init(frame: .zero)

			backgroundColor = UIColor.axBackgroundColor

			line.backgroundColor = .axBackgroundColor.tint(0.5)
			addSubview(line)

			label.text = title
			label.pen = Pen.axValue
			addSubview(label)
		}
		required init?(coder: NSCoder) { fatalError() }

	// UIView ======================================================================================
		override func layoutSubviews() {
			line.top(width: width, height: 2*s)
			label.left(dx: 12*s, width: 300*s, height: 30*s)
		}
	}

	let activeView: HeaderView = HeaderView("Active".localized)
	let notActiveView: HeaderView = HeaderView("Not Active".localized)

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		switch section {
			case 0: return activeView
			case 1: return notActiveView
			case 2: return nil
			default: fatalError()
		}
	}
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		guard filter.sortsView.selectedRow(inComponent: 0) != 1 else { return 0 }
		switch section {
			case 0: return activeCores.count > 0 ? 36*s : 0
			case 1: return inactiveCores.count > 0 ? 36*s : 0
			case 2: return 0
			default: fatalError()
		}
	}
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0
	}
}
