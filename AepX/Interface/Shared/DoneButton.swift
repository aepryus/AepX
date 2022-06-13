//
//  DoneButton.swift
//  AepX
//
//  Created by Joe Charlier on 6/9/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class DoneButton: UIButton {

	var path: CGMutablePath! = nil
	var touchDown: Bool = false

	init() {
		super.init(frame: .zero)

		addAction(for: [.touchDown, .touchDragInside]) {
			self.touchDown = true
			self.setNeedsDisplay()
		}
		addAction(for: [.touchCancel, .touchDragOutside, .touchUpInside]) {
			self.touchDown = false
			self.setNeedsDisplay()
		}
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? { path.contains(point) ? self : nil }
	override func draw(_ rect: CGRect) {
		let p: CGFloat = 1*s					// padding
		let q: CGFloat = (height-2*p)/2			// width and height of the angled segments

		let x1: CGFloat = p
		let x2: CGFloat = x1 + q
		let x4: CGFloat = width - p
		let x3: CGFloat = x4 - q

		let y1: CGFloat = p
		let y2: CGFloat = y1 + q
		let y3: CGFloat = height - p

		let c = UIGraphicsGetCurrentContext()!
		path = CGMutablePath()
		path.move(to: CGPoint(x: x1, y: y2))
		path.addLine(to: CGPoint(x: x2, y: y1))
		path.addLine(to: CGPoint(x: x3, y: y1))
		path.addLine(to: CGPoint(x: x4, y: y2))
		path.addLine(to: CGPoint(x: x3, y: y3))
		path.addLine(to: CGPoint(x: x2, y: y3))
		path.addLine(to: CGPoint(x: x1, y: y2))
		c.addPath(path)
		c.setLineWidth(1*s)
		c.setStrokeColor(UIColor.white.cgColor)
		c.setFillColor((!touchDown ? UIColor.axDarkBack : UIColor.axBackground.tint(0.5)).cgColor)
		c.drawPath(using: .fillStroke)

		("Done".localized as NSString).draw(in: rect.offsetBy(dx: 0, dy: 3.5*s), pen: Pen(font: .axHeavy(size: 19*s), color: !touchDown ? .white : .axBackground, alignment: .center))
	}
}
