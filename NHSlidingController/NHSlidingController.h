//
//  NHSlidingController.h
//  sliding
//
//  Created by Nils Hayat on 1/15/13.
//  Copyright (c) 2013 Nils Hayat. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSlidingControllerDidOpenNotification @"kSlidingControllerDidOpenNotification"
#define kSlidingControllerDidCloseNotification @"kSlidingControllerDidCloseNotification"

@interface NHSlidingController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIViewController *topViewController;
@property (nonatomic, strong) UIViewController *bottomViewController;
/// This how far the drawer opens. Defaults to 200.0
@property (nonatomic) CGFloat slideDistance;

- (id)initWithTopViewController:(UIViewController *)topViewController
           bottomViewController:(UIViewController *)bottomViewController;

///This methods opens the drawer if it is closed and closes it if it is opened. (Animated)
-(void)toggleDrawer;

-(void)openDrawerAnimated:(BOOL)animated;

///Use this method to change the topViewController and animate the change (go all the way to
/// the right, change ViewController and come back in place)
-(void)setTopViewController:(UIViewController *)topViewController animated:(BOOL)animated;

@end
