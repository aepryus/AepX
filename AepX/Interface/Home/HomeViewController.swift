//
//  HomeViewController.swift
//  AepX
//
//  Created by Joe Charlier on 5/1/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	let backView: UIImageView = UIImageView()
	let tableView: UITableView = UITableView()

	let nextFace: NextFace = NextFace()
	let latestFace: LatestFace = LatestFace()
	let statsFace: StatsFace = StatsFace()
	let yearsFace: YearsFace = YearsFace()
	let thanksFace: ThanksFace = ThanksFace()
	let creditsFace: CreditsFace = CreditsFace()

	var cards: [Card] = []

// UIViewController ================================================================================
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.aepXbackgroundColor

		backView.image = UIImage(named: "Starship")
		view.addSubview(backView)

		tableView.register(LaunchCell.self, forCellReuseIdentifier: "cell")
		tableView.dataSource = self
		tableView.delegate = self
		tableView.backgroundColor = UIColor.clear
		tableView.rowHeight = 120*s
		view.addSubview(tableView)

		backView.frame = view.bounds
		tableView.frame = view.bounds

		SpaceX.nextLaunch { (launch: Launch) in
			DispatchQueue.main.async {
				self.nextFace.launch = launch
			}
		} failure: {
			print("failure")
		}

		SpaceX.latestLaunch { (launch: Launch) in
			DispatchQueue.main.async {
				self.latestFace.launch = launch
			}
		} failure: {
			print("failure")
		}

		cards = [
			Card(face: nextFace),
			Card(face: latestFace),
			Card(face: statsFace),
			Card(face: yearsFace),
			Card(face: thanksFace),
			Card(face: creditsFace)
		]
	}

// UITableViewDelegate =============================================================================
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return cards[indexPath.row].cardHeight
	}

// UITableViewDataSource ===========================================================================
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cards.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return cards[indexPath.row]
	}
}
