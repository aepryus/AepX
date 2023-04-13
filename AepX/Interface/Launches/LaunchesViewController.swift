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

	func scrollToLatest() {
		guard tableView.numberOfSections(in: tableView) == 3, tableView.tableView(tableView, numberOfRowsInSection: 1) > 0 else { return }
		tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: false)
		tableView.scrollRectToVisible(tableView.rectForRow(at: IndexPath(row: 0, section: 1)), animated: false)
	}

	static let filterHeight: CGFloat = 120*3*Screen.s + 12*Screen.s + Screen.navBottom + 16*Screen.s
	func invokeFilter() {
		view.addSubview(shield)
		view.addSubview(filter)
		filter.bottom(dy: LaunchesViewController.filterHeight, width: view.width, height: LaunchesViewController.filterHeight)
		shield.alpha = 0
		UIView.animate(withDuration: 0.2) {
			self.filter.bottom(width: self.view.width, height: LaunchesViewController.filterHeight)
			self.shield.alpha = 1
		}
	}
	func dismissFilter() {
		UIView.animate(withDuration: 0.2) {
            self.tableView.collapseSilent()
			self.filter.bottom(dy: LaunchesViewController.filterHeight, width: self.view.width, height: LaunchesViewController.filterHeight)
			self.shield.alpha = 0
            self.controller.loadData()
		} completion: { (completed: Bool) in
			self.filter.removeFromSuperview()
			self.shield.removeFromSuperview()
		}
	}
	func toggleFilter() {
		if filter.superview == nil { invokeFilter() }
		else { dismissFilter() }
	}

	class HeaderView: UIView {
		let label: UILabel = UILabel()
		let line: UIView = UIView()

		init(_ title: String) {
			super.init(frame: .zero)

			backgroundColor = .axBorder

			line.backgroundColor = .axBorder.tint(0.3)
			addSubview(line)

			label.text = title
			label.pen = Pen(font: .axDemiBold(size: 19*s), color: .white)
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
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .axBackground

		navigationController?.navigationBar.tintColor = .white
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: controller, action: #selector(LaunchesController.onFilterTapped))
		navigationItem.backButtonDisplayMode = .minimal

		backView.image = UIImage(named: "Background")
		view.addSubview(backView)

		tableView.backgroundColor = UIColor.clear
		tableView.register(LaunchCell.self, forCellReuseIdentifier: "cell")
		if Screen.mac {
			tableView.showsVerticalScrollIndicator = true
			tableView.perform(NSSelectorFromString("_setSupportsPointerDragScrolling:"), with: true)
		}
		view.addSubview(tableView)

		shield.backgroundColor = .black.alpha(0.8)
		shield.addGestureRecognizer(UITapGestureRecognizer(target: controller, action: #selector(LaunchesController.onFilterTapped)))

		filter.doneButton.addAction { self.controller.onFilterTapped() }

        controller.loadData()

		DispatchQueue.main.async { self.scrollToLatest() }
	}
	override func viewWillLayoutSubviews() {
		backView.frame = view.bounds
		tableView.frame = view.bounds
		shield.frame = view.bounds
		tableView.reloadData()
		if filter.superview != nil { filter.bottom(width: self.view.width, height: LaunchesViewController.filterHeight) }
	}

// ExpandableTableViewDelegate =====================================================================
	func numberOfSections(in tableView: ExpandableTableView) -> Int { 3 }
	func expandableTableView(_ tableView: ExpandableTableView, baseHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80*s
	}
	func expandableTableView(_ tableView: ExpandableTableView, expansionHeightForRowAt indexPath: IndexPath) -> CGFloat { 90*s + 180*s*AepX.widthScale }
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
		let expansion: LaunchExpansion = tableView.dequeueExpansionView() as? LaunchExpansion
				?? LaunchExpansion(delegate: controller)
		expansion.load(launch: indexPath.section == 0 ? planned[indexPath.row] : completed[indexPath.row])
		return expansion
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
