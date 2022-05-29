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

	let shield: UIView = UIView()
	let filter: LaunchesFilterView = LaunchesFilterView()

	var planned: [Launch] = []
	var completed: [Launch] = []

	func loadData() {
		let launches: [Launch] = Loom.selectAll().sorted(by: { (a: Launch, b: Launch) in
			return a.flightNo > b.flightNo
		})

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
		if Screen.mac { tableView.perform(NSSelectorFromString("_setSupportsPointerDragScrolling:"), with: true) }
		view.addSubview(tableView)

		shield.backgroundColor = .black.alpha(0.8)
		shield.addGestureRecognizer(UITapGestureRecognizer(target: controller, action: #selector(LaunchesController.onFilterTapped)))

		backView.frame = view.bounds
		tableView.frame = view.bounds
		shield.frame = view.bounds

		loadData()

		DispatchQueue.main.async { self.scrollToLatest() }
	}

// ExpandableTableViewDelegate =====================================================================
	func numberOfSections(in tableView: ExpandableTableView) -> Int { 2 }
	func expandableTableView(_ tableView: ExpandableTableView, baseHeightForRowAt indexPath: IndexPath) -> CGFloat { 80*s }
	func expandableTableView(_ tableView: ExpandableTableView, expansionHeightForRowAt indexPath: IndexPath) -> CGFloat { 270*s }
	func expandableTableView(_ tableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? planned.count : completed.count
	}
	func expandableTableView(_ tableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> ExpandableCell {
		let cell: LaunchCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LaunchCell
		cell.load(launch: indexPath.section == 0 ? planned[indexPath.row] : completed[indexPath.row])
		return cell
	}
	func expandableTableView(_ tableView: ExpandableTableView, expansionForRowAt indexPath: IndexPath) -> UIView {
		return LaunchExpansion(launch: indexPath.section == 0 ? planned[indexPath.row] : completed[indexPath.row])
	}
	func expandableTableView(_ tableView: ExpandableTableView, viewForHeaderInSection section: Int) -> UIView? {
		return section == 0 ? futureView : pastView
	}
	func expandableTableView(_ tableView: ExpandableTableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 36*s
	}
}
