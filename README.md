NHSlidingController
===================

NHSLidingController is a sliding controller to handle interfaces with a top and bottom view controllers where the top one slides to reveal the bottom one.

There are a lot of alternative out there but none of them had the animations and elasticity feel right to me.

This class is completely self contained, from displaying to animation to handling taps and gestures. You create it, give it its top and bottom view controllers and that's it!

##Usage

Create the NHSlidingController with the top and bottom controller and assign it as the root ViewController from you window.

``` objective-c
	UIViewController *topViewController; // Your Top ViewController
	UIViewController *bottomViewController; //Your Bottom ViewController
	NHSlidingController *slidingController = [[NHSlidingController alloc] 	initWithTopViewController:topViewController 	bottomViewController:bottomViewController];
	self.window.rootViewController = slidingController;
```

That's it. You can now slide and reveal the bottom view controller.
You can also trigger the open/close animation programatically.

The `UIViewController+SlidingController` category adds the NHSlidingController as a property of your view controllers. In Any of your view controllers you can do:

``` objective-c
NHSlidingController *slidingController = self.slidingController;
[slidingController toggleDrawer];
[slidingController toggleDrawer];
```


##Adding NHSlidingController to your project

NHSlidingController is available on [CocoaPods](http://cocoapods.org). Add the following line to your `Podfile`:

``` ruby
pod 'NHSlidingController'
```
and then run `pod install` to install the dependency.

