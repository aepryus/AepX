//
//  AboutViewController.swift
//  AepX
//
//  Created by Joe Charlier on 6/14/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class AboutViewController: UIViewController {
	let backView: UIImageView = UIImageView(image: UIImage(named: "Background"))
	let scrollView: UIScrollView = UIScrollView()
	let label: UILabel = UILabel()
	var imageView: UIImageView = {
		let imageView: UIImageView = UIImageView(image: UIImage(named: "Banner"))
		imageView.layer.cornerRadius = 24*Screen.s
		imageView.layer.borderColor = UIColor.red.tone(0.6).shade(0.6).cgColor
		imageView.layer.borderWidth = 6*Screen.s
		imageView.layer.masksToBounds = true
		let width: CGFloat = AepX.window.width - 15*Screen.s
		imageView.topLeft(width: width, height: width * 144/360)
		return imageView
	}()

	func render() {
		let pen: Pen = Pen(font: .axMedium(size: 17*s), color: .white)
		let headerPen: Pen = pen.clone(font: .axBold(size: 19*s))
		let imagePen: Pen = Pen(font: .axMedium(size: 18*s), color: .white, baselineOffset: 10*s)

		let colorView: ColorView = ColorView(Result.landed.color)
		colorView.layer.cornerRadius = 5*s
		colorView.layer.borderColor = UIColor.white.cgColor
		colorView.layer.borderWidth = 1*s
		colorView.center(width: 30*s, height: 30*s)

		let text: NSMutableAttributedString = NSMutableAttributedString()

        text.append("\nLegend\n".localized, pen: headerPen)
        text.append("Throughout this app the following colors are used to represent the results of a launch.\n\n".localized, pen: pen)

        text.append(image: colorView.asImage()).append("  - landed".localized, pen: imagePen)
        text.append("\nThe primary mission succeeded with the booster(s) landing successfully.\n\n".localized, pen: pen)

		colorView.backgroundColor = Result.partial.color
        text.append(image: colorView.asImage()).append("  - partial".localized, pen: imagePen)
        text.append("\nThe primary mission succeeded with some boosters landing and others being expended or lost.\n\n".localized, pen: pen)

		colorView.backgroundColor = Result.lost.color
        text.append(image: colorView.asImage()).append("  - lost".localized, pen: imagePen)
        text.append("\nThe primary mission succeeded however the landing attempt failed.\n\n".localized, pen: pen)

		colorView.backgroundColor = Result.expended.color
        text.append(image: colorView.asImage()).append("  - expended".localized, pen: imagePen)
        text.append("\nThe primary mission succeeded however no landing attempt was made; the booster being expended.\n\n".localized, pen: pen)

		colorView.backgroundColor = Result.failed.color
        text.append(image: colorView.asImage()).append("  - destroyed".localized, pen: imagePen)
        text.append("\nThe primary mission failed and the booster was destroyed.\n".localized, pen: pen)

        text.append("\n\nTips and Tricks\n".localized, pen: headerPen)
		text.append("""
        Both the 'Launches' and 'Boosters' screens have filters available.
        
        The filter can be brought up by either tapping the magnifying glass in the upper right-hand corner or by tapping the 'Launches' or 'Booster' navigation icon a second time.
        
        The filter can be dimissed by hitting the 'Done' button or once again hitting the navigation icon.

        """.localized, pen: pen)

        text.append("\n\nAcknowledgements\n".localized, pen: headerPen)
		text.append("""
        AepX makes use of the following 3rd party resources:
        
        - images of SpaceX rockets created by Lucabon (based on work of Markus Säynevirta and Craigboy and Rressi )
        
        - a modified version of 'mars-planets-moon-ufo-war-couple' image from Pixabay (via Affinity Photo) by user -MayaQ-
        
        - a blurred version of the Starship construction image from @elonmusk's twitter feed.
        
        - the 'YouTube-Player-iOS-Helper' library, originally authored by Ikai Lan, Ibrahim Ulukaya and Yoshifumi Yamaguchi.

        """.localized, pen: pen)

		text.append("\n\n\tAepX", pen: Pen(font: .axCopper(size: 36*s), color: .white))
		text.append(" v\(AepX.version)\n", pen: Pen(font: .axCopper(size: 22*s), color: .white))
		text.append("\t\tby Aepryus Software\n", pen: Pen(font: .axCopper(size: 21*s), color: .white))
		text.append("\t\t\t© 2022\n\n", pen: Pen(font: .axCopper(size: 23*s), color: .white))

		let width: CGFloat = AepX.window.width - 20*Screen.s
		imageView.topLeft(width: width, height: width * 144/360)
		text.append(image: imageView.asImage())
		text.append("\n\n\n", pen: pen)

		label.attributedText = text
		label.numberOfLines = 0
	}

// UIViewController ================================================================================
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(backView)

		scrollView.alwaysBounceVertical = true
		if Screen.mac { scrollView.perform(NSSelectorFromString("_setSupportsPointerDragScrolling:"), with: true) }
		else { scrollView.showsVerticalScrollIndicator = false }
		view.addSubview(scrollView)

		scrollView.addSubview(label)
	}
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		render()
		backView.frame = view.bounds
		scrollView.frame = view.bounds
		label.topLeft(width: view.width-16*s, height: 999*s)
		label.sizeToFit()
		label.topLeft(dx: 8*s, dy: 3*s)
		scrollView.contentSize = CGSize(width: view.width, height: label.height+30*s)
	}
}
