//
//  LaunchExpansion.swift
//  AepX
//
//  Created by Joe Charlier on 5/4/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class LaunchExpansion: UIView {
	weak var delegate: BoosterViewDelegate?
	var launch: Launch?

	let scrollView: UIScrollView = UIScrollView()
	var paraView: ParaView = ParaView(names: ["Info"])
	let rocketView: UIImageView = UIImageView()
    let patchView: UIImageView = UIImageView()
	let core1View: BoosterView = BoosterView(leftJustified: true)
	let core2View: BoosterView = BoosterView(leftJustified: true)
	let core3View: BoosterView = BoosterView(leftJustified: true)
	let wikipedia: LinkView = LinkView()
	let page1: UIView = UIView()
	let page2: UIView = UIView()

	let youTubeView: YouTubeView = YouTubeView()
	let youTubeFrame: UIView = UIView()

	init(delegate: BoosterViewDelegate? = nil) {
		self.delegate = delegate

		super.init(frame: .zero)

		backgroundColor = .axBackground

		page1.addSubview(rocketView)
        page1.addSubview(patchView)

		youTubeFrame.addSubview(youTubeView)

		youTubeFrame.backgroundColor = .axBackground.shade(0.3)
		youTubeFrame.layer.cornerRadius = 16*s
		page2.addSubview(youTubeFrame)

		scrollView.isPagingEnabled = true
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.alwaysBounceHorizontal = true
		if Screen.mac { scrollView.perform(NSSelectorFromString("_setSupportsPointerDragScrolling:"), with: true) }
		addSubview(scrollView)

		scrollView.addSubview(page1)
	}
	required init?(coder: NSCoder) { fatalError() }

	func load(launch: Launch) {
		self.launch = launch
        
        paraView.snapTo(pageNo: 0)

        rocketView.image = launch.rocket.image
        if let urlString = launch.patch { patchView.loadImage(url: urlString) }
        else { patchView.image = nil }

		paraView.removeFromSuperview()
		if launch.youtubeID != nil { paraView = ParaView(names: ["Info", "Video"]) }
		else { paraView = ParaView(names: ["Info"]) }
		paraView.scrollView = scrollView
		addSubview(paraView)
		scrollView.delegate = paraView

		if let urlString = launch.wikipedia {
			wikipedia.image = UIImage(named: "wikipedia")
			wikipedia.urlString = urlString
			page1.addSubview(wikipedia)
		} else {
			wikipedia.removeFromSuperview()
		}

		if launch.launchCores.count == 1 {
			core3View.load(delegate: delegate, launchCore: launch.launchCores[0])
			core1View.removeFromSuperview()
			core2View.removeFromSuperview()
			page1.addSubview(core3View)
		} else if launch.launchCores.count == 3 {
			core1View.load(delegate: delegate, launchCore: launch.launchCores[0])
			core2View.load(delegate: delegate, launchCore: launch.launchCores[1])
			core3View.load(delegate: delegate, launchCore: launch.launchCores[2])
			page1.addSubview(core1View)
			page1.addSubview(core2View)
			page1.addSubview(core3View)
        } else {
            core1View.removeFromSuperview()
            core2View.removeFromSuperview()
            core3View.removeFromSuperview()
        }

		if let youtubeID = launch.youtubeID {
			youTubeView.load(id: youtubeID)
			scrollView.addSubview(page2)
		} else { page2.removeFromSuperview() }
	}

// UIView ==========================================================================================
	override func layoutSubviews() {
		guard let launch = launch else { return }
		paraView.top(dy: 12*s, width: width*0.9, height: 32*s)
		scrollView.frame = CGRect(x: 0, y: paraView.bottom, width: width, height: height-paraView.bottom)
		scrollView.contentSize = CGSize(width: width*(launch.youtubeID != nil ? 2 : 1), height: scrollView.height)
		page1.left(width: width, height: scrollView.height)
		page2.left(dx: width, width: width, height: scrollView.height)
		wikipedia.bottomRight(dx: -12*s, dy: -12*s, width: 103*s/2, height: 94*s/2)
        
		if let image = rocketView.image {
			let maxHeight: CGFloat = height - 81*s
			let height: CGFloat = maxHeight*launch.rocket.height
            rocketView.bottomLeft(dx: 20*s, dy: -12*s, width: image.size.width*height/image.size.height, height: height)
		}

        patchView.topRight(dx: -width/12, dy: width/20, width: width/4, height: width/4)

		let boosterDX: CGFloat = rocketView.right+12*s
        let boosterWidth: CGFloat = width - (wikipedia.superview != nil ? wikipedia.width + 8*s : 0) - 8*s - boosterDX

		core3View.bottomLeft(dx: boosterDX, dy: -16*s, width: boosterWidth, height: 30*s)
		core1View.topLeft(dx: core3View.left, dy: core3View.top-60*s, width: boosterWidth, height: 30*s)
		core2View.topLeft(dx: core3View.left, dy: core1View.bottom, width: boosterWidth, height: 30*s)

		youTubeFrame.center(width: (320*AepX.widthScale+2*12)*s, height: (180*AepX.widthScale+2*12)*s)
		youTubeView.center(width: 320*s * AepX.widthScale, height: 180*s * AepX.widthScale)
	}
}
