//
//  RocketsViewController.swift
//  AepX
//
//  Created by Joe Charlier on 4/29/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class RocketsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	lazy var controller: RocketsController = { RocketsController(vc: self) }()

	let backView: UIImageView = UIImageView()
	let tableView: UITableView = UITableView()

	let shield: UIView = UIView()
	let filter: RocketsFilterView = RocketsFilterView()

	var activeCores: [Core] = []
	var inactiveCores: [Core] = []

	func loadData() {
		activeCores = []
		inactiveCores = []
		let cores: [Core] = Loom.selectAll()

		cores.forEach {
			if $0.coreStatus == "active" { activeCores.append($0) }
			else { inactiveCores.append($0) }
		}

		activeCores.sort(by: { (a: Core, b: Core) in
			if a.launches.count != b.launches.count { return a.launches.count > b.launches.count }
			return a.serial < b.serial
		})

		inactiveCores.sort(by: { (a: Core, b: Core) in
			if a.launches.count != b.launches.count { return a.launches.count > b.launches.count }
			if let aLast = a.launches.last, let bLast = b.launches.last {
				return aLast.date > bLast.date
			}
			return a.serial < b.serial
		})

		tableView.reloadData()
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
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: controller, action: #selector(RocketsController.onFilterTapped))

		backView.image = UIImage(named: "Starship")
		view.addSubview(backView)

		tableView.backgroundColor = UIColor.clear
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(RocketCell.self, forCellReuseIdentifier: "cell")
		tableView.allowsSelection = false
		tableView.rowHeight = 70*s
		tableView.sectionHeaderTopPadding = 0
		view.addSubview(tableView)

		shield.backgroundColor = .black.alpha(0.8)
		shield.addGestureRecognizer(UITapGestureRecognizer(target: controller, action: #selector(RocketsController.onFilterTapped)))

		backView.frame = view.bounds
		tableView.frame = view.bounds
		shield.frame = view.bounds

		loadData()
	}

// UITableViewDataSource ===========================================================================
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 { return activeCores.count }
		else { return inactiveCores.count }
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: RocketCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RocketCell
		cell.load(delegate: controller, core: indexPath.section == 0 ? activeCores[indexPath.row] : inactiveCores[indexPath.row])
		return cell
	}

// UITableViewDelegate =============================================================================
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

	let activeView: HeaderView = HeaderView("Active".localized)
	let notActiveView: HeaderView = HeaderView("Not Active".localized)

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return section == 0 ? activeView : notActiveView
	}
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 36*s
	}
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0
	}
}
