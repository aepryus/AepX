//
//  YouTubeView.swift
//  AepX
//
//  Created by Joe Charlier on 6/10/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation
import YouTubeiOSPlayerHelper

class YouTubeView: UIView, YTPlayerViewDelegate {
	var youTubeID: String?

	let player: YTPlayerView = YTPlayerView()
	let preferredColor: UIColor = .axBackgroundColor.shade(0.5)

	var lastState: YTPlayerState = .unstarted

	init() {
		super.init(frame: .zero)

		layer.cornerRadius = 12*s
		layer.masksToBounds = true

		player.delegate = self
	}
	required init?(coder: NSCoder) { fatalError() }

	func load(id: String) {
		print("Requested load from state [\(lastState)]")
		guard id != youTubeID && lastState != .unknown else { return }
		youTubeID = id
		player.removeFromSuperview()
		player.load(withVideoId: youTubeID!)
	}

// UIView ==========================================================================================
	override func layoutSubviews() {
		player.frame = bounds
	}

// YTPlayerViewDelegate ============================================================================
	func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
		print("playerViewDidBecomeReady")
		addSubview(player)
	}

	func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
		print("playerView:didChangeToState [\(state)]")
		lastState = state
	}

	func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality) {
		print("playerView:didChangeToQuality [\(quality)]")
	}

	func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
		print("playerView:receivedError [\(error)]")
		guard let youTubeID = youTubeID else { return }
		player.removeFromSuperview()
		player.load(withVideoId: youTubeID)
	}

//	func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
//		print("playerView:didPlayTime [\(playTime)]")
//	}

	func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
		return preferredColor
	}

	func playerViewPreferredInitialLoading(_ playerView: YTPlayerView) -> UIView? {
		let view = UIView()
		view.backgroundColor = preferredColor
		return view
	}
}
