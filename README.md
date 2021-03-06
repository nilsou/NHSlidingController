NHSlidingController
===================
A simple Sliding Controller (à la Path and Facebook) that bounces and has elasticity.

NHSlidingController is a sliding controller to handle interfaces with a top and bottom view controllers where the top one slides to reveal the bottom one.

There are a lot of alternative out there but none of them had the animations and elasticity feel right to me.

This class is completely self contained, from displaying to animation to handling taps and gestures. You create it, give it its top and bottom view controllers and that's it!

NHSlidingController is Universal and can be used on both iPhone and iPad. It requires iOS 5 minimum and ARC.

##Why?
Instead of using one of the dozens of implementations available on github, I decided to write my own for 2 reasons:

- I wanted something as minimal as possible in terms of code and I wanted it to be self contained.
- I wanted the animations and elasticity to feel just right.

Since I could not find one that satisfied these two conditions, I wrote NHSlidingController.

##Usage

Create the NHSlidingController with the top and bottom controller and assign it as the root ViewController from you window. Add this to your app delegate's -application:didFinishishLaunchingWithOptions: method.

``` objective-c
UIViewController *topViewController = [[UIViewController alloc] init]; // Your Top ViewController
topViewController.view.backgroundColor = [UIColor blueColor];
UIViewController *bottomViewController = [[UIViewController alloc] init]; //Your Bottom ViewController
bottomViewController.view.backgroundColor = [UIColor redColor];

NHSlidingController *slidingController = [[NHSlidingController alloc] initWithTopViewController:topViewController bottomViewController:bottomViewController];

self.window.rootViewController = slidingController;
```

That's it. You can now slide and reveal the bottom view controller.
You can also trigger the open/close animation programatically.

The `UIViewController+SlidingController` category adds the NHSlidingController as a property of your view controllers. In any of your view controllers you can do:

``` objective-c
NHSlidingController *slidingController = self.slidingController;
[slidingController toggleDrawer];
```

You can customize the maximum distance that the drawer will open:
``` objective-c
slidingController.slideDistance = 150.0;
```

##Adding NHSlidingController to your project

NHSlidingController is available on [CocoaPods](http://cocoapods.org). Add the following line to your `Podfile`:

``` ruby
pod 'NHSlidingController'
```
and then run `pod install` to install the dependency.

