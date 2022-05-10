//
//  ParaView.swift
//  AepX
//
//  Created by Joe Charlier on 5/10/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class ParaView: UIView, UIScrollViewDelegate {
	weak var scrollView: UIScrollView? = nil

	var pages: [UIView] = []
	var _pageNo: Int = 0
	var pageNo: Int {
		set { _pageNo = newValue }
		get { _pageNo }
	}

	private let thumb: UIView

	private var dragging: Bool = false
	private var numb: Bool = false

	init() {
		thumb = UIView()
		super.init(frame: .zero)

		backgroundColor = .cyan.tone(0.5).tint(0.5)
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
	}

// UIScrollViewDelegate ============================================================================
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		guard !numb else { return }
		let dx: CGFloat = scrollView.contentOffset.x / scrollView.contentSize.width * width
		thumb.topLeft(dx: dx, dy: thumb.top)
		pageNo = Int((scrollView.contentOffset.x+scrollView.width/2)/scrollView.width)
	}
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		if !dragging { numb = true }
	}
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		dragging = true
		numb = false
	}
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		dragging = false
	}
}
