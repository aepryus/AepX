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
	let footerCell: RocketsFooterCell = RocketsFooterCell()

	let shield: UIView = UIView()
	let filter: RocketsFilterView = RocketsFilterView()

	var activeCores: [Core] = []
	var inactiveCores: [Core] = []

	static let filterHeight: CGFloat = 120*3*Screen.s + 12*Screen.s + Screen.navBottom + 16*Screen.s
	func invokeFilter() {
		guard filter.superview == nil else { return }
		view.addSubview(shield)
		view.addSubview(filter)
		filter.bottom(dy: RocketsViewController.filterHeight, width: view.width, height: RocketsViewController.filterHeight)
		shield.alpha = 0
		UIView.animate(withDuration: 0.2) {
			self.filter.bottom(width: self.view.width, height: RocketsViewController.filterHeight)
			self.shield.alpha = 1
		}
	}
	func dismissFilter() {
		guard filter.superview != nil else { return }
		UIView.animate(withDuration: 0.2) {
			self.filter.bottom(dy: RocketsViewController.filterHeight, width: self.view.width, height: RocketsViewController.filterHeight)
			self.shield.alpha = 0
            self.controller.loadData()
		} completion: { (completed: Bool) in
			self.filter.removeFromSuperview()
			self.shield.removeFromSuperview()
		}
	}
	func toggleFilter() {
		if filter.superview == nil { invokeFilter() }
		else { dismissFilter() }
	}

// UIViewController ================================================================================
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .axBackground

		navigationController?.navigationBar.tintColor = .white
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: controller, action: #selector(RocketsController.onFilterTapped))
		navigationItem.backButtonDisplayMode = .minimal

		backView.image = UIImage(named: "Background")
		view.addSubview(backView)

		tableView.backgroundColor = UIColor.clear
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(RocketCell.self, forCellReuseIdentifier: "cell")
		tableView.allowsSelection = false
		tableView.sectionHeaderTopPadding = 0
		if Screen.mac { tableView.perform(NSSelectorFromString("_setSupportsPointerDragScrolling:"), with: true) }
		else { tableView.showsVerticalScrollIndicator = false }
		view.addSubview(tableView)

		shield.backgroundColor = .black.alpha(0.8)
		shield.addGestureRecognizer(UITapGestureRecognizer(target: controller, action: #selector(RocketsController.onFilterTapped)))

		filter.doneButton.addAction { self.controller.onFilterTapped() }

        controller.loadData()
	}
	override func viewWillLayoutSubviews() {
		backView.frame = view.bounds
		tableView.frame = view.bounds
		shield.frame = view.bounds
		if filter.superview != nil { filter.bottom(width: self.view.width, height: RocketsViewController.filterHeight) }
	}

// UITableViewDataSource ===========================================================================
	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
			case 0: return activeCores.count
			case 1: return inactiveCores.count
			case 2: return 1
			default: fatalError()
		}
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section < 2 {
			let cell: RocketCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RocketCell
			cell.load(delegate: controller, core: indexPath.section == 0 && activeCores.count > 0 ? activeCores[indexPath.row] : inactiveCores[indexPath.row])
			return cell
		} else {
			footerCell.numberOfRockets = activeCores.count + inactiveCores.count
			return footerCell
		}

	}

// UITableViewDelegate =============================================================================
	class HeaderView: UIView {
		let label: UILabel = UILabel()
		let line: UIView = UIView()

		init(_ title: String) {
			super.init(frame: .zero)

			backgroundColor = .axBorder

			line.backgroundColor = .axBorder.tint(0.3)
			addSubview(line)

			label.text = title
			label.pen = Pen(font: .axDemiBold(size: 19*s), color: .white)
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
	let notActiveView: HeaderView = HeaderView("Inactive".localized)

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		switch section {
			case 0: return activeView
			case 1: return notActiveView
			case 2: return nil
			default: fatalError()
		}
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60*s
	}
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		guard filter.sortsView.selectedRow(inComponent: 0) != 1 else { return 0 }
		switch section {
			case 0: return activeCores.count > 0 ? 36*s : 0
			case 1: return inactiveCores.count > 0 ? 36*s : 0
			case 2: return 0
			default: fatalError()
		}
	}
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0
	}
}
