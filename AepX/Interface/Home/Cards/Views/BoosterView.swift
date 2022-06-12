//
//  BoosterView.swift
//  AepX
//
//  Created by Joe Charlier on 6/12/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit
import QuartzCore

class BoosterView: UIView {
	var controller: HomeController?
	var launchCore: LaunchCore?

	let resultView: ResultView = ResultView()
	let gradient: CAGradientLayer = CAGradientLayer()
	let label: UILabel = UILabel()
	let patchesView: PatchesView = PatchesView(size: 27*Screen.s)
	let patchesContainer: UIView = UIView()

	init() {
		super.init(frame: .zero)
		addSubview(resultView)

		label.pen = Pen(font: .axMedium(size: 17*s), color: .white)
		addSubview(label)

		patchesContainer.addSubview(patchesView)

		gradient.startPoint = CGPoint(x: 0, y: 0)
		gradient.endPoint = CGPoint(x: 1, y: 0)
		gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor]
		gradient.locations = [0, 0.3, 0.5, 1]
		patchesContainer.layer.mask = gradient
		addSubview(patchesContainer)

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
	}
	required init?(coder: NSCoder) { fatalError() }

	func load(controller: HomeController, launchCore: LaunchCore) {
		self.controller = controller
		self.launchCore = launchCore
		resultView.result = launchCore.result.toLaunchResult
		let core: Core = Loom.selectBy(only: launchCore.apiid)!
		label.text = core.serial
		patchesView.load(core: core)
	}

// Events ==========================================================================================
	@objc func onTap() {
		guard let controller: HomeController = controller,
			  let launchCore: LaunchCore = launchCore,
			  let core: Core = Loom.selectBy(only: launchCore.apiid) else { return }
		controller.onBoosterTapped(core: core)
	}

// UIView ==========================================================================================
	override func layoutSubviews() {
		resultView.left(width: 24*s, height: 20*s)
		label.left(dx: resultView.right+7*s, width: 200*s, height: 30*s)
		patchesView.right(dx: -9*s, width: patchesView.patchesWidth, height: 30*s)
		patchesContainer.frame = bounds
		gradient.frame = patchesContainer.frame
	}
}
