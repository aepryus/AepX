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

	var launches: [Launch] = []

	func loadData() {
		launches = Loom.selectAll().sorted(by: { (a: Launch, b: Launch) in
			return a.flightNo > b.flightNo
		})

		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
	func scrollToLatest() {
		if let row: Int = self.launches.firstIndex(where: { $0.completed }) {
			self.tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .top, animated: false)
			self.tableView.scrollRectToVisible(self.tableView.rectForRow(at: IndexPath(row: row, section: 0)), animated: false)
		}
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
	func expandableTableView(_ tableView: ExpandableTableView, baseHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80*s
	}
	func expandableTableView(_ tableView: ExpandableTableView, expansionHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 270*s
	}
	func expandableTableView(_ tableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
		return launches.count
	}
	func expandableTableView(_ tableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> ExpandableCell {
		let cell: LaunchCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LaunchCell
		cell.load(launch: launches[indexPath.row])
		return cell
	}
	func expandableTableView(_ tableView: ExpandableTableView, expansionForRowAt indexPath: IndexPath) -> UIView {
		return LaunchExpansion(launch: launches[indexPath.row])
	}
}
