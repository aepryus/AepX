//
//  RocketViewController.swift
//  AepX
//
//  Created by Joe Charlier on 5/1/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit

class RocketViewController: UIViewController, UITableViewDataSource {
	lazy var controller: RocketController = { RocketController(vc: self) }()
	var core: Core { didSet {} }

	let tableView: UITableView = UITableView()

	init(core: Core) {
		self.core = core
		super.init(nibName: nil, bundle: nil)
	}
	required init?(coder: NSCoder) { fatalError() }

// UIViewController ================================================================================
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.aepXbackgroundColor

		tableView.register(LaunchCell.self, forCellReuseIdentifier: "cell")
		tableView.dataSource = self
		tableView.rowHeight = 50*s
		view.addSubview(tableView)

		tableView.top(dy: 300*s, width: view.width, height: Double(core.launches.count)*50*s)
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		controller.load(id: core.id)
	}

// UITableViewDataSource ===========================================================================
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return core.launches.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: LaunchCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LaunchCell
		cell.load(delegate: controller, launch: core.launches[indexPath.row])
		return cell
	}
}
