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
	let blockLabel: UILabel = UILabel()
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
			blockLabel.text = sb
		} else if serials.count == 1 { blockLabel.text = serials[0]
		} else { blockLabel.text = "" }
		blockLabel.pen = Pen.axValue
		scrollView.addSubview(blockLabel)

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
		blockLabel.bottomLeft(dx: 75*s, dy: -12*s, width: 300*s, height: 30*s)
		player.bottomLeft(dx: width+27.5*s, dy: -20*s, width: 320*s, height: 180*s)
	}
}
