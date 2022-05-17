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
	let paraView: ParaView = ParaView(names: ["Info", "Video"])
	let imageView: UIImageView = UIImageView()
	let blockValue: UILabel = UILabel()
	let flightNoValue: UILabel = UILabel()
	let detailsValue: UILabel = UILabel()
	let timeValue: UILabel = UILabel()
	let crewValue: UILabel = UILabel()
	let wikipedia: LinkView = LinkView()
	
	let player: YTPlayerView = YTPlayerView()

	init(launch: Launch) {
		self.launch = launch

		super.init(frame: .zero)

		backgroundColor = UIColor.axBackgroundColor

		player.layer.cornerRadius = 12*s
		player.layer.masksToBounds = true
		scrollView.addSubview(player)

		paraView.scrollView = scrollView
		addSubview(paraView)

		imageView.image = launch.rocket.image
		scrollView.addSubview(imageView)

		let serials: [String] = launch.cores.compactMap {
			let core: Core? = Loom.selectBy(only: $0.appid)
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
		scrollView.addSubview(blockValue)

		flightNoValue.text = "\(launch.flightNo)"
		flightNoValue.pen = Pen.axValue
		scrollView.addSubview(flightNoValue)

		detailsValue.text = launch.details
		detailsValue.pen = Pen.axLabel
		scrollView.addSubview(detailsValue)

		timeValue.text = launch.date.format("hh:mm aZZZ")
		timeValue.pen = Pen.axLabel
		scrollView.addSubview(timeValue)

		crewValue.text = "\(launch.noOfCrew)"
		crewValue.pen = Pen.axValue
		scrollView.addSubview(crewValue)

		if let urlString = launch.wikipedia {
			wikipedia.image = UIImage(named: "wikipedia")
			wikipedia.urlString = urlString
			scrollView.addSubview(wikipedia)
		}

		scrollView.isPagingEnabled = true
		scrollView.showsHorizontalScrollIndicator = false
		addSubview(scrollView)
		scrollView.delegate = paraView

		if let youtubeID = launch.youtubeID {
			player.load(withVideoId: youtubeID)
		}
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		super.layoutSubviews()
		paraView.top(dy: 12*s, width: width*0.9, height: 32*s)
		scrollView.frame = CGRect(x: 0, y: paraView.bottom, width: width, height: height-paraView.bottom)
		scrollView.contentSize = CGSize(width: width*2, height: scrollView.height)
		if let image = imageView.image {
			let maxHeight: CGFloat = height*0.7
			let height: CGFloat = maxHeight*launch.rocket.height
			imageView.bottomLeft(dx: 20*s, dy: -12*s, width: image.size.width*height/image.size.height, height: height)
		}
		flightNoValue.topLeft(dx: 75*s, dy: 50*s, width: 200*s, height: 30*s)
		detailsValue.topLeft(dx: 75*s, dy: 70*s, width: 300*s, height: 30*s)
		timeValue.topLeft(dx: 75*s, dy: 90*s, width: 200*s, height: 30*s)
		crewValue.topLeft(dx: 75*s, dy: 110*s, width: 200*s, height: 30*s)
		wikipedia.topLeft(dx: 275*s, dy: 130*s, width: 103*s/2, height: 94*s/2)
		blockValue.bottomLeft(dx: 75*s, dy: -12*s, width: 300*s, height: 30*s)
		player.bottomLeft(dx: width+27.5*s, dy: -20*s, width: 320*s, height: 180*s)
	}
}
