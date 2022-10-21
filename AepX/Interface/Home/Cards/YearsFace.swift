//
//  YearsFace.swift
//  AepX
//
//  Created by Joe Charlier on 5/5/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

fileprivate struct Layer {
	let color: UIColor
	let percent: CGFloat
}
         
fileprivate class StratView: UIView {
	let layers: [Layer]

	init(layers: [Layer]) {
		self.layers = layers
		super.init(frame: .zero)
		backgroundColor = .clear
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		var dx: CGFloat = 0
		let c = UIGraphicsGetCurrentContext()!
		layers.forEach {
			guard $0.percent > 0 else { return }
			let path = CGMutablePath()
			let stratWidth: CGFloat = $0.percent * width
			let cr: CGFloat = min(3*s, stratWidth/2)
			path.addRoundedRect(in: CGRect(x: dx, y: 0, width: stratWidth, height: height), cornerWidth: cr, cornerHeight: cr)
			dx += stratWidth
			c.setLineWidth(1.5*s)
			c.setFillColor($0.color.cgColor)
			c.addPath(path)
			c.drawPath(using: .fillStroke)
			c.closePath()
		}
	}
}

fileprivate struct YearData {
	var year: String = "'00"
	var failed: Int = 0
	var expended: Int = 0
	var lost: Int = 0
	var landed: Int = 0
	var partial: Int = 0

	var total: Int {
		return failed + expended + lost + landed + partial
	}
}

fileprivate class YearView: UIView {
	let yearLabel: UILabel = UILabel()
	let stratView: StratView
	let totalLabel: UILabel = UILabel()
	let totalPercent: CGFloat

	init(data: YearData, max: Int) {
		let tonePercent: CGFloat = 0.6
		stratView = StratView(layers: [
			Layer(color: .blue.tone(tonePercent), percent: CGFloat(data.landed)/CGFloat(max)),
			Layer(color: .purple.tone(tonePercent), percent: CGFloat(data.partial)/CGFloat(max)),
			Layer(color: .orange.tone(tonePercent), percent: CGFloat(data.lost)/CGFloat(max)),
			Layer(color: .cyan.tone(tonePercent), percent: CGFloat(data.expended)/CGFloat(max)),
			Layer(color: .red.tone(tonePercent), percent: CGFloat(data.failed)/CGFloat(max)),
		])
		totalPercent = max > 0 ? CGFloat(data.total)/CGFloat(max) : 0
		super.init(frame: .zero)

		yearLabel.text = data.year
		yearLabel.pen = Pen(font: .axMedium(size: 14*s), color: .white, alignment: .center)
		addSubview(yearLabel)

		addSubview(stratView)

		totalLabel.text = data.total > 0 ? "\(data.total)" : ""
		totalLabel.pen = Pen(font: .axMedium(size: 14*s), color: .white)
		addSubview(totalLabel)
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		yearLabel.left(dx: 7*s, width: 32*s, height: 30*s)
		stratView.left(dx: yearLabel.right+4*s, width: width-yearLabel.right-4*s-9*s-24*s, height: 23*s)
		totalLabel.left(dx: stratView.left+stratView.width*totalPercent+5*s, width: 20*s, height: 20*s)
	}
}

class YearsView: UIView {
	fileprivate var years: [YearView] = []
    private let shouldAdd11: Bool

    init(shouldAdd11: Bool = true) {
        self.shouldAdd11 = shouldAdd11
		super.init(frame: .zero)
	}
	required init?(coder: NSCoder) { fatalError() }

    func loadData(launches: [Launch]) {
		years.forEach { $0.removeFromSuperview() }
		years = []

        var datas:[String:YearData] = shouldAdd11 ? ["'11":YearData(year: "'11")] : [:]

		launches.forEach {
			let year: String = "'"+$0.date.format("YY")
			var yearData: YearData = datas[year] ?? YearData(year: year)
			if !$0.successful { yearData.failed += 1 }
			else if $0.hasLostCores && $0.hasLandedCores { yearData.partial += 1 }
			else if $0.hasLostCores { yearData.lost += 1 }
			else if $0.hasLandedCores { yearData.landed += 1 }
			else { yearData.expended += 1 }
			datas[year] = yearData
		}

		let max: Int = datas.values.maximum { $0.landed + $0.partial + $0.lost + $0.expended + $0.failed } ?? 0

		years = datas.values.sorted(by: { $0.year > $1.year })
			.map { YearView(data: $0, max: max) }

		years.forEach { addSubview($0) }
	}

// UIView ==========================================================================================
	override func layoutSubviews() {
		var dy: CGFloat = 12*s
		years.forEach {
			$0.topLeft(dy: dy, width: width, height: 32*s)
			dy += 32*s
		}
	}
}

fileprivate class LegendRow: UIView {
	let view: UIView = UIView()
	let label: UILabel = UILabel()

	init(color: UIColor, text: String) {
		super.init(frame: .zero)

		view.backgroundColor = color
		view.layer.cornerRadius = 5*s
		addSubview(view)

		label.text = text
		label.pen = Pen(font: .axMedium(size: 14*s), color: .white, alignment: .right)
		addSubview(label)
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		label.left(width: width-21*s, height: 24*s)
		view.left(dx: label.right+4*s, width: 16*s, height: 16*s)
	}
}

fileprivate class LegendView: UIView {
	let rows: [LegendRow]

	init() {
		let tonePercent: CGFloat = 0.6
		rows = [
			LegendRow(color: .blue.tone(tonePercent), text: "success / landed"),
			LegendRow(color: .purple.tone(tonePercent), text: "success / partial"),
			LegendRow(color: .orange.tone(tonePercent), text: "success / lost"),
			LegendRow(color: .cyan.tone(tonePercent), text: "success / expended"),
			LegendRow(color: .red.tone(tonePercent), text: "failure"),
		]
		super.init(frame: .zero)
		rows.forEach { addSubview($0) }
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		var dy: CGFloat = 0
		rows.forEach {
			$0.topLeft(dy: dy, width: width, height: 30*s)
			dy += 24*s
		}
	}
}

class YearsFace: Face {
	private let yearsView: YearsView = YearsView()
	private let legendView: LegendView = LegendView()

	init() {
		super.init(frame: .zero)
		addSubview(yearsView)
		addSubview(legendView)
	}
	required init?(coder: NSCoder) { fatalError() }

    func loadData(launches: [Launch]) {
		yearsView.loadData(launches: launches)
	}

// Face ============================================================================================
	override var faceHeight: CGFloat { 24*s + CGFloat(yearsView.years.count)*32*s }

// UIView ==========================================================================================
	override func layoutSubviews() {
		yearsView.frame = bounds
		legendView.bottomRight(dx: -20*s, dy: -24*s, width: 200*s, height: 5*24*s)
	}
}
