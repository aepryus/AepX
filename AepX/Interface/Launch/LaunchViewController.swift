//
//  LaunchView.swift
//  AepX
//
//  Created by Joe Charlier on 5/1/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit
import WebKit
import YouTubeiOSPlayerHelper

class LaunchViewController: UIViewController {
	lazy var controller: LaunchController = { LaunchController(vc: self) }()
	var launch: Launch { didSet {
		if let youtubeID = launch.links?.youtubeId {
			player.load(withVideoId: youtubeID)
		}
	} }

	let player: YTPlayerView = YTPlayerView()

	init(launch: Launch) {
		self.launch = launch
		super.init(nibName: nil, bundle: nil)
	}
	required init?(coder: NSCoder) { fatalError() }

// UIViewController ================================================================================
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.aepXbackgroundColor

		view.addSubview(player)

		player.center(width: 320*s, height: 180*s)
		player.layer.cornerRadius = 12*s
		player.layer.masksToBounds = true

		controller.load(id: launch.id)
	}
}
