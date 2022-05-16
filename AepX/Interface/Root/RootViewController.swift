
//
//  RootViewController.swift
//  AepX
//
//  Created by Joe Charlier on 4/29/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class RootViewController: UITabBarController, UITabBarControllerDelegate {
	let homeViewController: HomeViewController
	let launchesViewController: LaunchesViewController
	let rocketsViewController: RocketsViewController

	let homeNavigationController: UINavigationController
	let launchesNavigationController: UINavigationController
	let rocketsNavigationController: UINavigationController

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		homeViewController = HomeViewController()
		homeViewController.title = "AepX"
		homeNavigationController = UINavigationController(rootViewController: homeViewController)

		launchesViewController = LaunchesViewController()
		launchesViewController.title = "Launches"
		launchesNavigationController = UINavigationController(rootViewController: launchesViewController)

		rocketsViewController = RocketsViewController()
		rocketsViewController.title = "Rockets"
		rocketsNavigationController = UINavigationController(rootViewController: rocketsViewController)

		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

		delegate = self
	}
	required init?(coder: NSCoder) { fatalError() }

// UITabBarController ==============================================================================
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
	override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
	override func viewDidLoad() {
		super.viewDidLoad()

		setNeedsStatusBarAppearanceUpdate()

		let appearance = UITabBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = UIColor.axBackgroundColor.alpha(0.9)

		tabBar.standardAppearance = appearance
		tabBar.scrollEdgeAppearance = tabBar.standardAppearance

		UITabBar.appearance().tintColor = .white

		let navApp = UINavigationBarAppearance()
		navApp.configureWithOpaqueBackground()
		navApp.backgroundColor = UIColor.axBackgroundColor.alpha(0.9)
		navApp.titleTextAttributes = [.foregroundColor: UIColor.white]
		navApp.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
		navApp.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
		UINavigationBar.appearance().standardAppearance = navApp
		UINavigationBar.appearance().scrollEdgeAppearance = navApp

		let image1 = UIImage(named: "football-7")!
		let image2 = UIImage(named: "layer-7")!
		let image3 = UIImage(named: "command-7")!

		homeNavigationController.tabBarItem = UITabBarItem(title: "Home", image: image3, selectedImage: image3.withTintColor(.white))
		launchesNavigationController.tabBarItem = UITabBarItem(title: "Launches", image: image1, selectedImage: image1.withTintColor(.white))
		rocketsNavigationController.tabBarItem = UITabBarItem(title: "Rockets", image: image2, selectedImage: image2.withTintColor(.white))

		self.viewControllers = [
			homeNavigationController,
			launchesNavigationController,
			rocketsNavigationController
		]
	}

// UITabBarControllerDelegate ======================================================================
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		guard let previous = tabBarController.selectedViewController, previous === viewController else { return true }

		if let rocketsController = ((viewController as? UINavigationController)?.topViewController as? RocketsViewController)?.controller {
			rocketsController.onFilterTapped()
		} else if let launchesController = ((viewController as? UINavigationController)?.topViewController as? LaunchesViewController)?.controller {
			launchesController.onFilterTapped()
		}

		return true
	}
}
