
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
		let imageView: UIImageView = UIImageView(image: UIImage(named: "Title"))
		imageView.contentMode = .scaleAspectFit
		homeViewController.navigationItem.titleView = imageView
		homeNavigationController = UINavigationController(rootViewController: homeViewController)

		launchesViewController = LaunchesViewController()
		launchesViewController.title = "Launches"
		launchesNavigationController = UINavigationController(rootViewController: launchesViewController)

		rocketsViewController = RocketsViewController()
		rocketsViewController.title = "Boosters"
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
		appearance.backgroundColor = .axDarkBack.alpha(0.9)

		tabBar.standardAppearance = appearance
		tabBar.scrollEdgeAppearance = tabBar.standardAppearance

		UITabBar.appearance().tintColor = .white

		let navApp = UINavigationBarAppearance()
		navApp.configureWithOpaqueBackground()
		navApp.backgroundColor = .axDarkBack.alpha(0.9)
		navApp.titleTextAttributes = Pen(font: .axHeavy(size: 22*s), color: .white, alignment: .center).attributes
		navApp.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
		navApp.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
		UINavigationBar.appearance().standardAppearance = navApp
		UINavigationBar.appearance().scrollEdgeAppearance = navApp

		let image1 = UIImage(named: "Starbase")!
		let image2 = UIImage(named: "Launches")!
		let image3 = UIImage(named: "Boosters")!

		homeNavigationController.tabBarItem = UITabBarItem(title: "Starbase", image: image1, selectedImage: image1.withTintColor(.white))
		launchesNavigationController.tabBarItem = UITabBarItem(title: "Launches", image: image2, selectedImage: image2.withTintColor(.white))
		rocketsNavigationController.tabBarItem = UITabBarItem(title: "Boosters", image: image3, selectedImage: image3.withTintColor(.white))

		self.viewControllers = [
			homeNavigationController,
			launchesNavigationController,
			rocketsNavigationController
		]
	}
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		coordinator.animate { (context: UIViewControllerTransitionCoordinatorContext) in
			self.view.bounds = CGRect(origin: .zero, size: size)
		}
	}

// UITabBarControllerDelegate ======================================================================
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		guard let previous = tabBarController.selectedViewController, previous === viewController else {
			rocketsViewController.dismissFilter()
			launchesViewController.dismissFilter()
			return true
		}

		if let rocketsController = ((viewController as? UINavigationController)?.topViewController as? RocketsViewController)?.controller {
			rocketsController.onFilterTapped()
		} else if let launchesController = ((viewController as? UINavigationController)?.topViewController as? LaunchesViewController)?.controller {
			launchesController.onFilterTapped()
		}

		return true
	}
}
