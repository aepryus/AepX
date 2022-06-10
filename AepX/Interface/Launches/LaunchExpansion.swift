//
//  LaunchExpansion.swift
//  AepX
//
//  Created by Joe Charlier on 5/4/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

fileprivate class LaunchCoreResultView: UIView {
	var result: LaunchCore.Result? = nil {
		didSet {
			backgroundColor = result?.color
		}
	}

	init() {
		super.init(frame: .zero)
		layer.borderColor = UIColor.black.cgColor
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		let size: CGFloat = min(width, height)
		layer.cornerRadius = size/2
		layer.borderWidth = size/20
	}
}

fileprivate class LaunchCoreView: UIView {
	let label: UILabel = UILabel()
	let resultView: LaunchCoreResultView = LaunchCoreResultView()

	let serialPen = Pen(font: .axMedium(size: 19*Screen.s), color: .white, alignment: .left)
	let statePen = Pen(font: .axMedium(size: 15*Screen.s), color: .white, alignment: .left)

	var launchCore: LaunchCore? = nil {
		didSet {
			guard let launchCore = launchCore else { return }
			let core: Core = Loom.selectBy(only: launchCore.apiid)!
			label.attributedText = core.serial.attributed(pen: serialPen).append(" - \(launchCore.result)", pen: statePen)
			resultView.result = launchCore.result
		}
	}

	init() {
		super.init(frame: .zero)

		addSubview(resultView)
		addSubview(label)
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		resultView.left(width: 20*s, height: 20*s)
		label.left(dx: resultView.right+7*s, width: 200*s, height: 30*s)
	}
}

class LaunchExpansion: UIView {
	let launch: Launch

	let scrollView: UIScrollView = UIScrollView()
	var paraView: ParaView = ParaView(names: ["Info", "Video"])
	let imageView: UIImageView = UIImageView()
//	let blockValue: UILabel = UILabel()
//	let detailsValue: UILabel = UILabel()
	let timeValue: UILabel = UILabel()
	let crewValue: UILabel = UILabel()
	private let core1View: LaunchCoreView = LaunchCoreView()
	private let core2View: LaunchCoreView = LaunchCoreView()
	private let core3View: LaunchCoreView = LaunchCoreView()
	let wikipedia: LinkView = LinkView()
	let page1: UIView = UIView()
	let page2: UIView = UIView()
	let page3: UIView = UIView()

	let youTubeView: YouTubeView = YouTubeView()
	let youTubeFrame: UIView = UIView()

	init(launch: Launch) {
		self.launch = launch

		super.init(frame: .zero)

		backgroundColor = UIColor.axBackgroundColor

//		if !launch.hasDetails { paraView = ParaView(names: ["Info", "Video"]) }
		paraView.scrollView = scrollView
		addSubview(paraView)

		imageView.image = launch.rocket.image
		page1.addSubview(imageView)

//		let serials: [String] = launch.cores.compactMap {
//			let core: Core? = Loom.selectBy(only: $0.apiid)
//			return core?.serial
//		}
//		if serials.count > 1 {
//			var sb: String = ""
//			serials.forEach { sb += "\($0), " }
//			sb.removeLast(2)
//			blockValue.text = sb
//		} else if serials.count == 1 { blockValue.text = serials[0]
//		} else { blockValue.text = "" }
//		blockValue.pen = Pen.axValue
//		page1.addSubview(blockValue)

		timeValue.text = launch.date.format("hh:mm a")
		timeValue.pen = Pen.axValue
//		page1.addSubview(timeValue)

		crewValue.text = "\(launch.noOfCrew)"
		crewValue.pen = Pen.axValue
//		page1.addSubview(crewValue)

		if launch.cores.count == 1 {
			core3View.launchCore = launch.cores[0]
			page1.addSubview(core3View)
		} else if launch.cores.count == 3 {
			core1View.launchCore = launch.cores[0]
			page1.addSubview(core1View)
			core2View.launchCore = launch.cores[1]
			page1.addSubview(core2View)
			core3View.launchCore = launch.cores[2]
			page1.addSubview(core3View)
		}

		if let urlString = launch.wikipedia {
			wikipedia.image = UIImage(named: "wikipedia")
			wikipedia.urlString = urlString
			page1.addSubview(wikipedia)
		}

//		detailsValue.text = launch.details
//		detailsValue.pen = Pen(font: .axMedium(size: 17*s), color: .white, alignment: .left)
//		detailsValue.numberOfLines = 0
//		page2.addSubview(detailsValue)

		youTubeFrame.addSubview(youTubeView)

		youTubeFrame.backgroundColor = .axBackgroundColor.shade(0.3)
		youTubeFrame.layer.cornerRadius = 16*s
		page3.addSubview(youTubeFrame)

		if let youtubeID = launch.youtubeID {
			youTubeView.load(id: youtubeID)
		}

		scrollView.isPagingEnabled = true
		scrollView.showsHorizontalScrollIndicator = false
		addSubview(scrollView)
		scrollView.delegate = paraView

		scrollView.addSubview(page1)
//		if launch.hasDetails { scrollView.addSubview(page2) }
		scrollView.addSubview(page3)
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		super.layoutSubviews()
		paraView.top(dy: 12*s, width: width*0.9, height: 32*s)
		scrollView.frame = CGRect(x: 0, y: paraView.bottom, width: width, height: height-paraView.bottom)
		scrollView.contentSize = CGSize(width: width*2, height: scrollView.height)
		page1.left(width: width, height: scrollView.height)
		page3.left(dx: width, width: width, height: scrollView.height)

		if let image = imageView.image {
			let maxHeight: CGFloat = height*0.7
			let height: CGFloat = maxHeight*launch.rocket.height
			imageView.bottomLeft(dx: 20*s, dy: -12*s, width: image.size.width*height/image.size.height, height: height)
		}
		timeValue.topLeft(dx: imageView.right, width: 200*s, height: 30*s)
		crewValue.topLeft(dx: 75*s, dy: 110*s, width: 200*s, height: 30*s)
//		blockValue.bottomLeft(dx: 75*s, dy: -12*s, width: 300*s, height: 30*s)
		core1View.topLeft(dx: imageView.right+12*s, dy: 120*s, width: 200*s, height: 30*s)
		core2View.topLeft(dx: core1View.left, dy: core1View.bottom, width: 200*s, height: 30*s)
		core3View.topLeft(dx: core1View.left, dy: core2View.bottom, width: 200*s, height: 30*s)
		wikipedia.bottomRight(dx: -12*s, dy: -12*s, width: 103*s/2, height: 94*s/2)

//		detailsValue.topLeft(width: width-18*s, height: scrollView.height-12*s)
//		detailsValue.sizeToFit()
//		detailsValue.topLeft(dx: 9*s, dy: 6*s, height: min(detailsValue.height, scrollView.height-12*s))

		youTubeFrame.center(width: (320+2*12)*s, height: (180+2*12)*s)
		youTubeView.center(width: 320*s, height: 180*s)
	}
}
