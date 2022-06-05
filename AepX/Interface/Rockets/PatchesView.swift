//
//  BadgesView.swift
//  AepX
//
//  Created by Joe Charlier on 5/9/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit


class PatchesView: UIView {
	let size: CGFloat
	var core: Core? = nil
	fileprivate var patches: [PatchInfo] = []
	fileprivate var patchesViews: [PatchView] = []

	fileprivate struct PatchInfo {
		let url: String
		let date: Date
		var count: Int
	}
	fileprivate class PatchView: UIView {
		let patchInfo: PatchInfo

		let imageView: UIImageView = UIImageView()
		let label: UILabel = UILabel()

		init(patchInfo: PatchInfo) {
			self.patchInfo = patchInfo
			super.init(frame: .zero)

			imageView.loadImage(url: self.patchInfo.url)
			addSubview(imageView)

			if patchInfo.count > 1 {
				label.text = "\u{00D7}\(patchInfo.count)"
				label.pen = Pen(font: UIFont(name: "AvenirNext-Medium", size: 15*s)!, color: .white, alignment: .center)
				addSubview(label)
			}
		}
		required init?(coder: NSCoder) { fatalError() }

		override func layoutSubviews() {
			imageView.left(width: height, height: height)
			if patchInfo.count > 1 {
				label.left(dx: imageView.right, width: 20*s, height: 20*s)
			}
		}
	}

	init(size: CGFloat) {
		self.size = size
		super.init(frame: .zero)
	}
	required init?(coder: NSCoder) { fatalError() }

	var patchesWidth: CGFloat {
		let width: CGFloat = patchesViews.summate {
			size + ($0.patchInfo.count>1 ? 20*s : 0) + 7*s
		}
		return width - 7*s
	}

	func load(core: Core) {
		self.core = core

		var patchesIndex:[String:PatchInfo] = [:]
		self.core?.launches.forEach {
			guard $0.completed, let patch = $0.patch else { return }
			if patchesIndex[patch] == nil {
				patchesIndex[patch] = PatchInfo(url: patch, date: $0.date, count: 0)
			}
			patchesIndex[patch]!.count = patchesIndex[patch]!.count + 1
		}
		patches = patchesIndex.values.sorted { (a: PatchInfo, b: PatchInfo) in
			if a.count != b.count { return a.count < b.count }
			return a.date < b.date
		}

		subviews.forEach { $0.removeFromSuperview() }
		patchesViews = []

		patches.forEach {
			let patchView: PatchView = PatchView(patchInfo: $0)
			addSubview(patchView)
			self.patchesViews.append(patchView)
		}

		bounds = CGRect(origin: .zero, size: CGSize(width: patchesWidth, height: height))
	}

// UIView ==========================================================================================
	override func layoutSubviews() {
		var dx: CGFloat = 0
		patchesViews.forEach {
			$0.left(dx: dx, width: size+($0.patchInfo.count>1 ? 20*s : 0), height: size)
			dx += $0.width+7*s
		}
	}
}
