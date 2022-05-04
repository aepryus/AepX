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

	var launches: [Launch] = []

// UIViewController ================================================================================
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.aepXbackgroundColor

		backView.image = UIImage(named: "Starship")
		view.addSubview(backView)

		tableView.backgroundColor = UIColor.clear
		tableView.register(LaunchCell.self, forCellReuseIdentifier: "cell")
		view.addSubview(tableView)

		backView.frame = view.bounds
		tableView.frame = view.bounds

		SpaceX.launches { (launches: [Launch]) in
			DispatchQueue.main.async {
				self.launches = launches
				self.tableView.reloadData()
			}
		} failure: {
			print("failure")
		}
	}

// ExpandableTableViewDelegate =====================================================================
	func expandableTableView(_ tableView: ExpandableTableView, baseHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80*s
	}
	func expandableTableView(_ tableView: ExpandableTableView, expansionHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 220*s
	}
	func expandableTableView(_ tableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
		return launches.count
	}
	func expandableTableView(_ tableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> ExpandableCell {
		let cell: LaunchCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LaunchCell
		cell.load(delegate: controller, launch: launches[indexPath.row])
		return cell
	}
	func expandableTableView(_ tableView: ExpandableTableView, expansionForRowAt indexPath: IndexPath) -> UIView {
		return LaunchExpansion(launch: launches[indexPath.row])
	}
}
