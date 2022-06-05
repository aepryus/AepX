//
//  LaunchesViewController.swift
//  AepX
//
//  Created by Joe Charlier on 4/29/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit
import Acheron

class LaunchesViewController: UIViewController, ExpandableTableViewDelegate {
	lazy var controller: LaunchesController = { LaunchesController(vc: self) }()

	let backView: UIImageView = UIImageView()
	lazy var tableView: ExpandableTableView = { ExpandableTableView(delegate: self) }()
	let footerCell: LaunchesFooterCell = LaunchesFooterCell()

	let shield: UIView = UIView()
	let filter: LaunchesFilterView = LaunchesFilterView()

	var planned: [Launch] = []
	var completed: [Launch] = []

	func loadData() {
		let launches: [Launch] = Loom.selectAll().sorted(by: { (a: Launch, b: Launch) in
			return a.flightNo > b.flightNo
		}).filter {
			if filter.rocketsView.selectedRow(inComponent: 0) != 0 {
				if $0.rocket.isFalcon1 && filter.rocketsView.selectedRow(inComponent: 0) != 1 { return false }
				if $0.rocket.isFalcon9 && filter.rocketsView.selectedRow(inComponent: 0) != 2 { return false }
				if $0.rocket.isFalconHeavy && filter.rocketsView.selectedRow(inComponent: 0) != 3 { return false }
			}

			if filter.missionsView.selectedRow(inComponent: 0) != 0 {
				if filter.missionsView.selectedRow(inComponent: 0) == 1 { return !$0.completed }
				if filter.missionsView.selectedRow(inComponent: 0) == 3 { return $0.completed && !$0.successful }
				if filter.missionsView.selectedRow(inComponent: 0) == 2 && (!$0.completed || !$0.successful) { return false }
			}

			if filter.landingsView.selectedRow(inComponent: 0) != 0 {
				if filter.landingsView.selectedRow(inComponent: 0) == 1 && !$0.hasLandedCores { return false }
				if filter.landingsView.selectedRow(inComponent: 0) == 2 && !$0.hasLostCores { return false }
				if filter.landingsView.selectedRow(inComponent: 0) == 3 && !$0.hasExpendedCores { return false }
			}

			return true
		}

		planned = launches.filter { !$0.completed }
		completed = launches.filter { $0.completed }

		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
	func scrollToLatest() {
		self.tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: false)
		self.tableView.scrollRectToVisible(self.tableView.rectForRow(at: IndexPath(row: 0, section: 1)), animated: false)
	}

	func toggleFilter() {
		let filterHeight: CGFloat = 120*3*s + 12*s + Screen.navBottom
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
				self.loadData()
			} completion: { (completed: Bool) in
				self.filter.removeFromSuperview()
				self.shield.removeFromSuperview()
			}
		}
	}

	class HeaderView: UIView {
		let label: UILabel = UILabel()
		let line: UIView = UIView()

		init(_ title: String) {
			super.init(frame: .zero)

			backgroundColor = .axBorderColor

			line.backgroundColor = .axBorderColor.tint(0.3)
			addSubview(line)

			label.text = title
			label.pen = Pen(font: .axDemiBold(size: 19*s), color: .white, alignment: .left)
			addSubview(label)
		}
		required init?(coder: NSCoder) { fatalError() }

	// UIView ======================================================================================
		override func layoutSubviews() {
			line.top(width: width, height: 2*s)
			label.left(dx: 12*s, width: 300*s, height: 30*s)
		}
	}

	let futureView: HeaderView = HeaderView("Planned".localized)
	let pastView: HeaderView = HeaderView("Completed".localized)

// UIViewController ================================================================================
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.axBackgroundColor

		navigationController?.navigationBar.tintColor = .white
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: controller, action: #selector(LaunchesController.onFilterTapped))

		backView.image = UIImage(named: "Starship")
		view.addSubview(backView)

		tableView.backgroundColor = UIColor.clear
		tableView.register(LaunchCell.self, forCellReuseIdentifier: "cell")
		tableView.showsVerticalScrollIndicator = true
		if Screen.mac { tableView.perform(NSSelectorFromString("_setSupportsPointerDragScrolling:"), with: true) }
		view.addSubview(tableView)

		shield.backgroundColor = .black.alpha(0.8)
		shield.addGestureRecognizer(UITapGestureRecognizer(target: controller, action: #selector(LaunchesController.onFilterTapped)))

		loadData()

//		DispatchQueue.main.async { self.scrollToLatest() }
	}
	override func viewWillLayoutSubviews() {
		backView.frame = view.bounds
		tableView.frame = view.bounds
		shield.frame = view.bounds
	}

// ExpandableTableViewDelegate =====================================================================
	func numberOfSections(in tableView: ExpandableTableView) -> Int { 3 }
	func expandableTableView(_ tableView: ExpandableTableView, baseHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80*s
	}
	func expandableTableView(_ tableView: ExpandableTableView, expansionHeightForRowAt indexPath: IndexPath) -> CGFloat { 270*s }
	func expandableTableView(_ tableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
			case 0: return planned.count
			case 1: return completed.count
			case 2: return 1
			default: fatalError()
		}
	}
	func expandableTableView(_ tableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> ExpandableCell {
		if indexPath.section < 2 {
			let cell: LaunchCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LaunchCell
			cell.load(launch: indexPath.section == 0 ? planned[indexPath.row] : completed[indexPath.row])
			return cell
		} else {
			footerCell.numberOfLaunches = planned.count + completed.count
			return footerCell
		}
	}
	func expandableTableView(_ tableView: ExpandableTableView, expansionForRowAt indexPath: IndexPath) -> UIView {
		if indexPath.section == 2 { fatalError() }
		return LaunchExpansion(launch: indexPath.section == 0 ? planned[indexPath.row] : completed[indexPath.row])
	}
	func expandableTableView(_ tableView: ExpandableTableView, viewForHeaderInSection section: Int) -> UIView? {
		switch section {
			case 0: return futureView
			case 1: return pastView
			case 2: return nil
			default: fatalError()
		}
	}
	func expandableTableView(_ tableView: ExpandableTableView, heightForHeaderInSection section: Int) -> CGFloat {
		switch section {
			case 0: return planned.count > 0 ? 36*s : 0
			case 1: return completed.count > 0 ? 36*s : 0
			case 2: return 0
			default: fatalError()
		}
	}
	func expandableTableView(_ tableView: ExpandableTableView, expandableRowAt indexPath: IndexPath) -> Bool {
		return indexPath.section != 2
	}
}
