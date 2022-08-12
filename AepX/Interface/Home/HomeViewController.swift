//
//  HomeViewController.swift
//  AepX
//
//  Created by Joe Charlier on 5/1/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	lazy var controller: HomeController = { HomeController(vc: self) }()

	let backView: UIImageView = UIImageView()
	let tableView: UITableView = UITableView()
	let nextFace: LaunchFace = LaunchFace(title: "next launch")
	let latestFace: LaunchFace = LaunchFace(title: "latest launch")
	let statsFace: StatsFace = StatsFace()
	let yearsFace: YearsFace = YearsFace()
	let creditsFace: CreditsFace = CreditsFace()
	let ooviumFace: OoviumFace = OoviumFace()
	let aexelsFace: AexelsFace = AexelsFace()

	var cards: [Card] = []

// UIViewController ================================================================================
	override func viewDidLoad() {
		super.viewDidLoad()

		navigationController?.navigationBar.tintColor = .white
		navigationItem.backButtonDisplayMode = .minimal

		backView.image = UIImage(named: "Starship")
		view.addSubview(backView)

		tableView.register(LaunchCell.self, forCellReuseIdentifier: "cell")
		tableView.dataSource = self
		tableView.delegate = self
		tableView.backgroundColor = UIColor.clear
		tableView.rowHeight = 120*s
		if Screen.mac { tableView.perform(NSSelectorFromString("_setSupportsPointerDragScrolling:"), with: true) }
		else { tableView.showsVerticalScrollIndicator = false }
		view.addSubview(tableView)

		cards = [
			Card(face: nextFace),
			Card(face: latestFace),
			Card(face: statsFace),
			Card(face: yearsFace),
			Card(face: creditsFace),
			Card(face: ooviumFace),
			Card(face: aexelsFace),
		]

        controller.loadData()
	}
	override func viewWillLayoutSubviews() {
		backView.frame = view.bounds
		creditsFace.renderCredits()
		tableView.frame = view.bounds
	}

// UITableViewDelegate =============================================================================
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return cards[indexPath.row].cardHeight
	}
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if (cell as! Card).face === creditsFace {
			creditsFace.startRoll()
		}
	}

// UITableViewDataSource ===========================================================================
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cards.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return cards[indexPath.row]
	}
}
