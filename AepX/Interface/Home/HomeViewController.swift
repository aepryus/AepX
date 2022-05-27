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
	let backView: UIImageView = UIImageView()
	let tableView: UITableView = UITableView()

	let nextFace: NextFace = NextFace()
	let latestFace: LatestFace = LatestFace()
	let statsFace: StatsFace = StatsFace()
	let yearsFace: YearsFace = YearsFace()
	let creditsFace: CreditsFace = CreditsFace()
	let ooviumFace: OoviumFace = OoviumFace()
	let aexelsFace: AexelsFace = AexelsFace()

	var cards: [Card] = []

	func loadData() {
		let launches: [Launch] = Loom.selectAll().sorted { (a: Launch, b: Launch) in
			if a.date == b.date { return a.flightNo < b.flightNo }
			return a.date < b.date
		}
		guard launches.count > 2 else { return }
		var i: Int = 0
		while i < launches.count-1 {
			if launches[i].date < Date.now && launches[i+1].date >= Date.now {
				break
			}
			i += 1
		}
		latestFace.launch = launches[i]
		nextFace.launch = launches[i+1]
		statsFace.loadData()
		tableView.reloadData()
	}

// UIViewController ================================================================================
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.axBackgroundColor

		backView.image = UIImage(named: "Starship")
		view.addSubview(backView)

		tableView.register(LaunchCell.self, forCellReuseIdentifier: "cell")
		tableView.dataSource = self
		tableView.delegate = self
		tableView.backgroundColor = UIColor.clear
		tableView.rowHeight = 120*s
		if Screen.mac { tableView.perform(NSSelectorFromString("_setSupportsPointerDragScrolling:"), with: true) }
		view.addSubview(tableView)


		backView.frame = view.bounds
		tableView.frame = view.bounds

		cards = [
			Card(face: nextFace),
			Card(face: latestFace),
			Card(face: statsFace),
			Card(face: yearsFace),
			Card(face: creditsFace),
			Card(face: ooviumFace),
			Card(face: aexelsFace),
		]

		loadData()
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
