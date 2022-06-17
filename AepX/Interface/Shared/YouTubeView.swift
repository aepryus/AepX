//
//  YouTubeView.swift
//  AepX
//
//  Created by Joe Charlier on 6/10/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit
import YouTubeiOSPlayerHelper

class YouTubeView: UIView, YTPlayerViewDelegate {
	var youTubeID: String?

	let player: YTPlayerView = YTPlayerView()
	let preferredColor: UIColor = .axDarkBack

	var lastState: YTPlayerState = .unstarted

	init() {
		super.init(frame: .zero)

		layer.cornerRadius = 12*s
		layer.masksToBounds = true

		player.delegate = self
	}
	required init?(coder: NSCoder) { fatalError() }

	func load(id: String) {
		youTubeID = id
		player.load(withVideoId: youTubeID!)
	}

// UIView ==========================================================================================
	override func layoutSubviews() {
		player.frame = bounds
	}

// YTPlayerViewDelegate ============================================================================
	func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
//		print("playerViewDidBecomeReady")
		addSubview(player)
	}

	func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
//		print("playerView:didChangeToState [\(state)]")
		lastState = state
	}

	func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality) {
//		print("playerView:didChangeToQuality [\(quality)]")
	}

	func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
		print("playerView:receivedError [\(error)]")
		guard let youTubeID = youTubeID else { return }
		player.removeFromSuperview()
		player.load(withVideoId: youTubeID)
	}

	func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor { preferredColor }
	func playerViewPreferredInitialLoading(_ playerView: YTPlayerView) -> UIView? {
		return ColorView(preferredColor)
	}
}
