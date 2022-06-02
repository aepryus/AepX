//
//  RocketViewController.swift
//  AepX
//
//  Created by Joe Charlier on 5/1/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class RocketViewController: UIViewController, ExpandableTableViewDelegate {
	lazy var controller: RocketController = { RocketController(vc: self) }()
	var core: Core { didSet {} }

	let backView: UIImageView = UIImageView()
	lazy var tableView: ExpandableTableView = { ExpandableTableView(delegate: self) }()
	lazy var rocketDetail: RocketDetail = { RocketDetail(core: core) }()

	init(core: Core) {
		self.core = core
		super.init(nibName: nil, bundle: nil)
		navigationItem.title = core.serial
	}
	required init?(coder: NSCoder) { fatalError() }

// UIViewController ================================================================================
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.axBackgroundColor

		backView.image = UIImage(named: "Starship")
		view.addSubview(backView)

		tableView.register(LaunchCell.self, forCellReuseIdentifier: "cell")
		tableView.expandableTableViewDelegate = self
		tableView.rowHeight = 50*s
		if Screen.mac { tableView.perform(NSSelectorFromString("_setSupportsPointerDragScrolling:"), with: true) }
		view.addSubview(tableView)

		backView.frame = view.bounds
		tableView.frame = view.bounds
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		controller.load(apiid: core.apiid)
	}

// ExpandableTableViewDelegate =====================================================================
	func expandableTableView(_ tableView: ExpandableTableView, baseHeightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 { return 400*s }
		return 80*s
	}
	func expandableTableView(_ tableView: ExpandableTableView, expandableRowAt indexPath: IndexPath) -> Bool {
		indexPath.row != 0
	}
	func expandableTableView(_ tableView: ExpandableTableView, expansionHeightForRowAt indexPath: IndexPath) -> CGFloat {
		270*s
	}
	func expandableTableView(_ tableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
		return core.launches.count+1
	}
	func expandableTableView(_ tableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> ExpandableCell {
		if indexPath.row == 0 { return rocketDetail }
		let cell: LaunchCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LaunchCell
		cell.load(launch: core.launches[indexPath.row - 1])
		return cell
	}
	func expandableTableView(_ tableView: ExpandableTableView, expansionForRowAt indexPath: IndexPath) -> UIView {
		return LaunchExpansion(launch: core.launches[indexPath.row-1])
	}
}
