//
//  LaunchExpansion.swift
//  AepX
//
//  Created by Joe Charlier on 5/4/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit
import YouTubeiOSPlayerHelper

class LaunchExpansion: UIView {
	let launch: Launch

	let scrollView: UIScrollView = UIScrollView()
	var paraView: ParaView = ParaView(names: ["Info", "Details", "Video"])
	let imageView: UIImageView = UIImageView()
	let blockValue: UILabel = UILabel()
	let detailsValue: UILabel = UILabel()
	let timeValue: UILabel = UILabel()
	let crewValue: UILabel = UILabel()
	let wikipedia: LinkView = LinkView()
	let page1: UIView = UIView()
	let page2: UIView = UIView()
	let page3: UIView = UIView()
	
	let player: YTPlayerView = YTPlayerView()

	init(launch: Launch) {
		self.launch = launch

		super.init(frame: .zero)

		backgroundColor = UIColor.axBackgroundColor

		if !launch.hasDetails { paraView = ParaView(names: ["Info", "Video"]) }
		paraView.scrollView = scrollView
		addSubview(paraView)

		imageView.image = launch.rocket.image
		page1.addSubview(imageView)

		let serials: [String] = launch.cores.compactMap {
			let core: Core? = Loom.selectBy(only: $0.apiid)
			return core?.serial
		}
		if serials.count > 1 {
			var sb: String = ""
			serials.forEach { sb += "\($0), " }
			sb.removeLast(2)
			blockValue.text = sb
		} else if serials.count == 1 { blockValue.text = serials[0]
		} else { blockValue.text = "" }
		blockValue.pen = Pen.axValue
		page1.addSubview(blockValue)

		timeValue.text = launch.date.format("hh:mm a")
		timeValue.pen = Pen.axValue
//		page1.addSubview(timeValue)

		crewValue.text = "\(launch.noOfCrew)"
		crewValue.pen = Pen.axValue
//		page1.addSubview(crewValue)

		if let urlString = launch.wikipedia {
			wikipedia.image = UIImage(named: "wikipedia")
			wikipedia.urlString = urlString
			page1.addSubview(wikipedia)
		}

		detailsValue.text = launch.details
		detailsValue.pen = Pen(font: .axMedium(size: 17*s), color: .white, alignment: .left)
		detailsValue.numberOfLines = 0
		page2.addSubview(detailsValue)

		player.layer.cornerRadius = 12*s
		player.layer.masksToBounds = true
		page3.addSubview(player)

		if let youtubeID = launch.youtubeID {
			player.load(withVideoId: youtubeID)
		}

		scrollView.isPagingEnabled = true
		scrollView.showsHorizontalScrollIndicator = false
		addSubview(scrollView)
		scrollView.delegate = paraView

		scrollView.addSubview(page1)
		if launch.hasDetails { scrollView.addSubview(page2) }
		scrollView.addSubview(page3)
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		super.layoutSubviews()
		paraView.top(dy: 12*s, width: width*0.9, height: 32*s)
		scrollView.frame = CGRect(x: 0, y: paraView.bottom, width: width, height: height-paraView.bottom)
		scrollView.contentSize = CGSize(width: width*(launch.hasDetails ? 3 : 2), height: scrollView.height)
		page1.left(width: width, height: scrollView.height)
		page2.left(dx: width, width: width, height: scrollView.height)
		page3.left(dx: (launch.hasDetails ? 2 : 1)*width, width: width, height: scrollView.height)

		if let image = imageView.image {
			let maxHeight: CGFloat = height*0.7
			let height: CGFloat = maxHeight*launch.rocket.height
			imageView.bottomLeft(dx: 20*s, dy: -12*s, width: image.size.width*height/image.size.height, height: height)
		}
		timeValue.topLeft(dx: imageView.right, width: 200*s, height: 30*s)
		crewValue.topLeft(dx: 75*s, dy: 110*s, width: 200*s, height: 30*s)
		blockValue.bottomLeft(dx: 75*s, dy: -12*s, width: 300*s, height: 30*s)
		wikipedia.bottomRight(dx: -12*s, dy: -12*s, width: 103*s/2, height: 94*s/2)

		detailsValue.topLeft(width: width-18*s, height: scrollView.height-12*s)
		detailsValue.sizeToFit()
		detailsValue.topLeft(dx: 9*s, dy: 6*s, height: min(detailsValue.height, scrollView.height-12*s))

		player.center(width: 320*s, height: 180*s)
	}
}
