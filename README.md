# AepX

AepX is a SpaceX launch tracking app developed by Aepryus Software.  It is available in the AppStore: [AepX](https://apps.apple.com/us/app/aepx/id1630233662).

I developed this app in order to create a recommended sane iOS app architecture that could be the basis of signficantly easier to develop and maintain apps.  AepX makes extensive use of my iOS toolkit [Acheron](https://github.com/aepryus/Acheron).  The app is small to mid sized; written using a modest 2654 lines of code (I've encountered AppDelegates with that much code).  The toolkit Acheron adds another 3204 lines of code, but of course AepX doesn't make use of all of its functionality.  Both AepX and Acheron are developed using the coding philosophy and best practices advocated for [here](https://github.com/aepryus/Cocytus).

There are a number of aspects of this code base that could be discussed in more detail, but let's start out with three in particular.

## User Interface Layout
Storyboards and Interface Builder have been instrumental in making iOS development a major pain in the ass, certainly because of git merge conflicts, but more importantly because multiple screen sizes is handled very poorly or dealing with dynamic screens is impossible or just the spectacularly poor UI/UX of Interface Builder itself.

AutoLayout is way more complicated than it needs to be and fundamentally I’m against the desire to turn iOS development into web development; I want to decide where my controls are located not leave it to some (overly complicated) algorithm.  One of the major reasons why I was enthusiastic about bolting from web development to iOS was because I hated web development; I’ve never understood the continuing effort of Apple to turn iOS development into a CSS document.

I had such high hopes for SwiftUI when it was announced.  I figured they realized all the mistakes they made with IB and AutoLayout and were finally going to give us the UI library we needed.  But instead they embraced the ridiculous Reactive; tried to make everything even more like a CSS document and topped it all off with being buggy and wildly incomplete for the 3ish years since it was released.

As a modest alternative to all this insanity, I put forward the 347 lines of AepLayout, which makes creating an app easy, precise, straightforward, easily maintainable, easily modifiable and easy to make things look the same on any and all screen sizes; while also giving the option of making them look different if desired.

The basic concept is that each UIView contains 9 anchor points (all the combinations of left, right, top, bottom and center).  All subviews are laid out relative to one of these 9 anchors of their parent view.



|  |  |  |
| :- | :-: | -: |
| topLeft    | top    | topRight    |
| left       | center | right       |
| bottomLeft | bottom | bottomRight |


In addition each device has a scaling factor ```s```, which is to be multiplied by all scalar values; the result of which allows controls to look the same on any screen they appear on.

Let’s look at the layout code for the LaunchCell:

```Swift
	override func layoutSubviews() {
		super.layoutSubviews()
		patchView.left(dx: 9*s, width: 48*s, height: 48*s)
		nameLabel.left(dx: patchView.right+12*s, dy: -12*s, width: width-(patchView.right+12*s)-12*s, height: 40*s)
		dateLabel.left(dx: nameLabel.left, dy: 12*s, width: 300*s, height: 48*s)
		flightNoLabel.right(dx: -12*s, width: 1000*s, height: 60*s)
		resultView.right(dx: -1*s, width: 4*s, height: baseHeight*0.6)
		lineView.bottom(width: width, height: 1)
	}
```


The dx and dy specify the offset from those anchors and the width and height the width and height of the control with each scalar number being multiplied by the scale factor 's'. 

These 9 simple commands are able to remove a spectacular amount of insanity from any code base and a spectacular amount of pain and suffering from any project.

## App Initialization
One aspect of app development that is almost always an adventure in Silicon Valley startups is app initialization.  When an app is first launched there are often numerous possible states that an app could be in and potentially a large number of network calls that go out asking for various pieces of data all coming back at different times.

Coordinating all this is extremely difficult and often results in overly complicated and buggy code.  There are a few options in dealing with all this asynchronous code (such as Reactive).  Certainly, I can appreciate the async/await feature of Swift and for the trivial case it can clean up some code.  But, once you get a way from the trivial case one has to ask if the cure isn't worse than the disease.

To solve this issue Acheron has its Pond and Pebbles concept (179 lines of a code).  Each Pebble is a (potentially asynchronous) task.  These pebbles are pulled out of a single pond instance and defined.  Once a pond's pebbles are defined, start conditions are indicated for each of the pebbles (related to the state of the other pebbles).

Once the pond and pebbles are fully defined, the pond can be started up, which will than coordinate the conditional execution of each of its pebbles.  This will continue until no pebbles are actively running.  The pond can also be made to be backgroundable so that it continues even after the app loses focus.

This tool has the effect of greatly simplifying app initialization and making the entire process more readily understandable and maintainable going forward.  App initialization for AepX is relatively simple, but provides a decent illustration of the tool:

```Swift
class BootPond: Pond {
	lazy var loadLaunches: Pebble = pebble(name: "loadLaunches") { (complete: @escaping (Bool) -> ()) in
        	Calypso.launches { (launches: [Calypso.Launch]) in
			launches.forEach { (launchAPI: Calypso.Launch) in
				Loom.transact {
					var launch: Launch = Loom.selectBy(only: launchAPI.apiid) ?? Loom.create()
                    			launchAPI.load(launch: launch)
				}
			}
			complete(true)
		} failure: {
			complete(false)
		}
	}
	lazy var loadCores: Pebble = pebble(name: "loadCores") { (complete: @escaping (Bool) -> ()) in
	        Calypso.cores { (cores: [Calypso.Core]) in
			cores.forEach { (coreAPI: Calypso.Core) in
				Loom.transact {
					var core: Core = Loom.selectBy(only: coreAPI.apiid) ?? Loom.create()
                    			coreAPI.load(core: core)
				}
			}
			complete(true)
		} failure: {
			complete(false)
		}
	}
	lazy var refreshScreens: Pebble = pebble(name: "refreshScreens") { (complete: @escaping (Bool) -> ()) in
		(AepX.window.rootViewController as! RootViewController).homeViewController.loadData()
		(AepX.window.rootViewController as! RootViewController).launchesViewController.loadData()
		(AepX.window.rootViewController as! RootViewController).rocketsViewController.loadData()
		complete(true)
	}

// Init ============================================================================================
	override init() {
		 super.init()

		loadLaunches.ready = { true }
		loadCores.ready = { true }

		refreshScreens.ready = {
			self.loadLaunches.completed
			&& self.loadCores.completed
		}
	}
}
```

A more involved example exists within [Oovium](https://github.com/aepryus/Oovium/blob/master/Oovium/Global/Ponds/BootPond.swift).

## Local Data Persistence

Device side data persistence on iOS is an unnecessary annoyance.  There are a few options:
- CoreData
- 3rd Party
- SQLite
- File System
- NSUserDefaults

The file system and NSUserDefaults are actually not bad choices especially if the data needs are simple.  As the persistence requirements become more sophisticated higher level options may be desired.  However, these higher level options tend to be complicated, hard to work with, may require fixed data struct specification with involved data migrations needs and in all the cases above (that I'm aware of), are not thread safe.

Alternatively, Acheron includes Loom, a mechanism that makes data persistence extremely easy.  Loom is an ORM which includes a Basket object which is a collection of the persisted objects.  Any root persistent object simply need extend from Anchor.  Child objects extend from Domain.  Any changes to these objects that occur within a Basket.transact block will autmatically be persisted.  Queries to the basket as well as calls to transact are entirely thread safe.

```Swift
// Initialize a basket object using SQLite
let basket: Basket = Basket(SQLitePersist("AepX"))

// Set the default basket and define all namespaces Domain objects could be defined in.
Loom.start(basket: basket, namesspaces: ["AepX"])

let appid = "123456789abcdef"
// Pull a Launch object out of the basket
let launch: Launch = Loom.selectBy(only: apiid)

// Modify the Launch object
Loom.transact {
	launch.name = "The New Launch Name"
}
```

