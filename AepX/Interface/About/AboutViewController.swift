//
//  AboutViewController.swift
//  AepX
//
//  Created by Joe Charlier on 6/14/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

extension UIView {
	func asImage() -> UIImage {
		return UIGraphicsImageRenderer(bounds: bounds).image { layer.render(in: $0.cgContext) }
	}
}

class AboutViewController: UIViewController {
	let backView: UIImageView = UIImageView(image: UIImage(named: "Starship"))
	let scrollView: UIScrollView = UIScrollView()
	let label: UILabel = UILabel()

// UIViewController ================================================================================
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(backView)

		scrollView.alwaysBounceVertical = true
		view.addSubview(scrollView)

		let pen: Pen = Pen(font: .axMedium(size: 17*s), color: .white)
		let headerPen: Pen = pen.clone(font: .axBold(size: 19*s))
		let imagePen: Pen = Pen(font: .axMedium(size: 18*s), color: .white, baselineOffset: 10*s)

		let colorView: UIView = UIView()
		colorView.layer.cornerRadius = 5*s
		colorView.layer.borderColor = UIColor.white.cgColor
		colorView.layer.borderWidth = 1*s
		colorView.center(width: 30*s, height: 30*s)
		colorView.backgroundColor = Launch.Result.successLanded.color

		let text: NSMutableAttributedString = NSMutableAttributedString()

		text.append("\nLegend\n", pen: headerPen)
		text.append("Throughout this app the following colors are used to represent the results of a launch.\n\n", pen: pen)

		text.append(image: colorView.asImage()).append("  - landed", pen: imagePen)
		text.append("\nThe primary mission succeeded with the booster(s) landing successfully.\n\n", pen: pen)

		colorView.backgroundColor = Launch.Result.successPartial.color
		text.append(image: colorView.asImage()).append("  - partial", pen: imagePen)
		text.append("\nThe primary mission succeeded with some boosters landing and others being lost.\n\n", pen: pen)

		colorView.backgroundColor = Launch.Result.successLost.color
		text.append(image: colorView.asImage()).append("  - lost", pen: imagePen)
		text.append("\nThe primary mission succeeded however the landing attempt failed.\n\n", pen: pen)

		colorView.backgroundColor = Launch.Result.successExpended.color
		text.append(image: colorView.asImage()).append("  - expended", pen: imagePen)
		text.append("\nThe primary mission succeeded however no landing attempt was made; the booster being expended.\n\n", pen: pen)

		colorView.backgroundColor = Launch.Result.failure.color
		text.append(image: colorView.asImage()).append("  - destroyed", pen: imagePen)
		text.append("\nThe primary mission failed and the booster was destroyed.\n", pen: pen)

		text.append("\n\nTips and Tricks\n", pen: headerPen)
		text.append("""
		Both the 'Launches' and 'Boosters' screens have filters available.

		The filter can be brought up by either tapping the magnifying glass in the upper right-hand corner or by tapping the 'Launches' or 'Booster' navigation icon a second time.

		The filter can be dimissed by hitting the 'Done' button or once again hitting the navigation icon.

		""", pen: pen)

		text.append("\n\nAcknowledgements\n", pen: headerPen)
		text.append("""
		This apps makes use of the following 3rd party resources:

		- AepX uses images of SpaceX rockets created by Lucabon (based on work of Markus Säynevirta and Craigboy and Rressi )

		- AepX makes use of the 'YouTube-Player-iOS-Helper' library, originally authored by Ikai Lan, Ibrahim Ulukaya and Yoshifumi Yamaguchi.

		- AepX also makes use of the subreddit /r/spacex's SpaceX-API data feed in order to drive the data contained in this app.

		""", pen: pen)

		text.append("\n\n\tAepX\n", pen: Pen(font: .axHeavy(size: 24*s), color: .white))
		text.append("\t\tby Aepryus Software\n", pen: Pen(font: .axDemiBold(size: 21*s), color: .white))
		text.append("\t\t\t© 2022\n\n", pen: Pen(font: .axMedium(size: 18*s), color: .white))

		let imageView: UIImageView = UIImageView(image: UIImage(named: "Banner"))
		imageView.layer.cornerRadius = 24*s
		imageView.layer.borderColor = UIColor.red.tone(0.6).shade(0.6).cgColor
		imageView.layer.borderWidth = 6*s
		imageView.layer.masksToBounds = true

		text.append(image: imageView.asImage())
		text.append("\n\n\n", pen: pen)

		label.attributedText = text
		label.numberOfLines = 0
		scrollView.addSubview(label)
	}
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		backView.frame = view.bounds
		scrollView.frame = view.bounds
		label.topLeft(width: view.width-16*s, height: 999*s)
		label.sizeToFit()
		label.topLeft(dx: 8*s, dy: 3*s)
		scrollView.contentSize = CGSize(width: view.width, height: label.height+30*s)
	}
}
