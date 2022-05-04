//
//  RocketsViewController.swift
//  AepX
//
//  Created by Joe Charlier on 4/29/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class RocketsViewController: UIViewController, UITableViewDataSource {
	lazy var controller: RocketsController = { RocketsController(vc: self) }()

	let backView: UIImageView = UIImageView()
	let tableView: UITableView = UITableView()

	var cores: [Core] = []

// UIViewController ================================================================================
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.aepXbackgroundColor

		backView.image = UIImage(named: "Starship")
		view.addSubview(backView)

		tableView.backgroundColor = UIColor.clear
		tableView.dataSource = self
		tableView.register(RocketCell.self, forCellReuseIdentifier: "cell")
		view.addSubview(tableView)

		backView.frame = view.bounds
		tableView.frame = view.bounds

		SpaceX.cores { (cores: [Core]) in
			DispatchQueue.main.async {
				self.cores = cores
				self.tableView.reloadData()
			}
		} failure: {
		}

	}

// UITableViewDataSource ===========================================================================
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cores.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: RocketCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RocketCell
		cell.load(delegate: controller, core: cores[indexPath.row])
		return cell
	}
}
