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

	var pages: [UIView] = [] {
		didSet {}
	}
	var _pageNo: Int = 0
	var pageNo: Int {
		set {
			if _pageNo != newValue {
				_pageNo = newValue
				onPageChange(pageNo: _pageNo)
			}
			UIView.animate(withDuration: 0.2) {
				self.thumb.frame = CGRect(x: CGFloat(self._pageNo)*self.pw, y: 0, width: self.pw, height: self.height)
			}
			if let scrollView = scrollView {
				scrollView.setContentOffset(CGPoint(x: CGFloat(_pageNo)*scrollView.width, y: 0), animated: true)
			}
		}
		get { _pageNo }
	}

	private let thumb: UIView

	private var dragging: Bool = false
	private var numb: Bool = true
	private var pw: CGFloat = 0

	let pen: Pen = Pen(font: .axDemiBold(size: 16*Screen.s), color: .white, alignment: .center)

	init(names: [String]) {
		thumb = UIView()
		super.init(frame: .zero)

		thumb.backgroundColor = UIColor.blue.tone(0.7).tint(0.5).alpha(0.5)
		thumb.layer.cornerRadius = 8*s
		addSubview(thumb)

		pages = names.map {
			let label: UILabel = UILabel()
			label.text = $0
			label.pen = pen
			return label
		}
		pages.forEach { addSubview($0) }

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
		thumb.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onPan)))
	}
	required init?(coder: NSCoder) { fatalError() }

	func snapTo(pageNo: Int) {
		if _pageNo != pageNo {
			_pageNo = pageNo
			onPageChange(pageNo: _pageNo)
		}
		thumb.frame = CGRect(x: CGFloat(_pageNo)*pw, y: 0, width: pw, height: height)
		if let scrollView = scrollView {
			scrollView.setContentOffset(CGPoint(x: CGFloat(_pageNo)*scrollView.width, y: 0), animated: false)
		}
	}

	private func pageFor(x: CGFloat) -> Int {
		min(max(Int(x/pw),0),pages.count-1)
	}

// Events ==========================================================================================
	func onPageChange(pageNo: Int) {
	}
	@objc func onTap(_ gesture: UITapGestureRecognizer) {
		pageNo = pageFor(x: gesture.location(in: self).x)
	}
	private var startX: CGFloat = 0
	@objc func onPan(_ gesture: UIPanGestureRecognizer) {
		if gesture.state == .began { startX = thumb.left }

		let x: CGFloat = startX+gesture.translation(in: self).x
		if gesture.state == .ended {
			pageNo = min(max(Int((x+pw/2)/pw),0),pages.count-1)
		} else {
			thumb.frame = CGRect(x: x.clamped(to: 0...(width-thumb.width)), y: 0, width: pw, height: height)
		}
	}

// UIView ==========================================================================================
	override func layoutSubviews() {
		pw = width / CGFloat(pages.count)
		pages.enumerated().forEach { $1.frame = CGRect(x: CGFloat($0)*pw, y: 0, width: pw, height: height) }
		thumb.frame = CGRect(x: CGFloat(_pageNo)*pw, y: 0, width: pw, height: height)
	}

// UIScrollViewDelegate ============================================================================
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		guard !numb else { return }
		let x: CGFloat = scrollView.contentOffset.x / scrollView.contentSize.width * width
		thumb.frame = CGRect(x: x, y: 0, width: thumb.width, height: thumb.height)
		_pageNo = Int((scrollView.contentOffset.x+scrollView.width/2)/scrollView.width)
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
