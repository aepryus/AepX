//
//  RootViewController.swift
//  AepX
//
//  Created by Joe Charlier on 4/29/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {
	let homeViewController: HomeViewController
	let launchesViewController: LaunchesViewController
	let rocketsViewController: RocketsViewController

	let homeNavigationController: UINavigationController
	let launchesNavigationController: UINavigationController
	let rocketsNavigationController: UINavigationController

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		homeViewController = HomeViewController()
		homeNavigationController = UINavigationController(rootViewController: homeViewController)

		launchesViewController = LaunchesViewController()
		launchesNavigationController = UINavigationController(rootViewController: launchesViewController)

		rocketsViewController = RocketsViewController()
		rocketsNavigationController = UINavigationController(rootViewController: rocketsViewController)

		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	required init?(coder: NSCoder) { fatalError() }

// UITabBarController ==============================================================================
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		setNeedsStatusBarAppearanceUpdate()

		let appearance = UITabBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = UIColor.aepXbackgroundColor.alpha(0.9)

		tabBar.standardAppearance = appearance
		tabBar.scrollEdgeAppearance = tabBar.standardAppearance

		UITabBar.appearance().tintColor = .white

		let image1 = UIImage(named: "football-7")!
		let image2 = UIImage(named: "layer-7")!
		let image3 = UIImage(named: "command-7")!

		homeNavigationController.tabBarItem = UITabBarItem(title: "Home", image: image3, selectedImage: image3.withTintColor(.white))
		homeNavigationController.navigationBar.barStyle = .black

		launchesNavigationController.tabBarItem = UITabBarItem(title: "Launches", image: image1, selectedImage: image1.withTintColor(.white))
		launchesNavigationController.navigationBar.barStyle = .black

		rocketsNavigationController.tabBarItem = UITabBarItem(title: "Rockets", image: image2, selectedImage: image2.withTintColor(.white))
		rocketsNavigationController.navigationBar.barStyle = .black

		self.viewControllers = [
			homeNavigationController,
			launchesNavigationController,
			rocketsNavigationController
		]
	}
}
