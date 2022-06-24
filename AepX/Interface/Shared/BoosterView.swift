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

protocol BoosterViewDelegate: AnyObject {
	func onBoosterTapped(core: Core)
}

class BoosterView: UIView {
	var leftJustified: Bool
	weak var delegate: BoosterViewDelegate?
	var launchCore: LaunchCore?

	let resultView: ResultView = ResultView()
	let gradient: CAGradientLayer = CAGradientLayer()
	let label: UILabel = UILabel()
	let patchesView: PatchesView
	let patchesContainer: UIView = UIView()

	init(leftJustified: Bool = false) {
		self.leftJustified = leftJustified
		patchesView = PatchesView(size: 27*Screen.s, leftJustified: leftJustified)

		super.init(frame: .zero)

		addSubview(resultView)

		label.pen = Pen(font: .axMedium(size: 17*s), color: .white)
		addSubview(label)

		patchesContainer.addSubview(patchesView)

		gradient.startPoint = CGPoint(x: 0, y: 0)
		gradient.endPoint = CGPoint(x: 1, y: 0)
		if !leftJustified {
			gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor]
			gradient.locations = [0, 0.3, 0.5, 1]
		} else {
			gradient.colors = [UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor]
			gradient.locations = [0, 0.85, 0.96, 1]
		}
		patchesContainer.layer.mask = gradient
		addSubview(patchesContainer)

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
	}
	required init?(coder: NSCoder) { fatalError() }

	func load(delegate: BoosterViewDelegate? = nil, launchCore: LaunchCore) {
		self.delegate = delegate
		self.launchCore = launchCore
		resultView.result = launchCore.result
		let core: Core = Loom.selectBy(only: launchCore.apiid)!
		label.text = core.serial
		patchesView.load(core: core)
        setNeedsLayout()
	}

// Events ==========================================================================================
	@objc func onTap() {
		guard let delegate: BoosterViewDelegate = delegate,
			  let launchCore: LaunchCore = launchCore,
			  let core: Core = Loom.selectBy(only: launchCore.apiid) else { return }
		delegate.onBoosterTapped(core: core)
	}

// UIView ==========================================================================================
	override func layoutSubviews() {
		resultView.left(width: 20*s, height: 20*s)
		label.sizeToFit()
		label.left(dx: resultView.right+7*s)
		if !leftJustified {
			patchesContainer.frame = bounds
			patchesView.right(dx: -9*s, width: patchesView.patchesWidth, height: 30*s)
		} else {
			patchesContainer.left(dx: label.right+6*s, width: width-(label.right+8*s), height: 30*s)
			patchesView.frame = patchesContainer.bounds
		}
		gradient.frame = patchesContainer.bounds
	}
}
