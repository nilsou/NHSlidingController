//
//  UIViewController+SlidingController.m
//  
//
//  Created by Nils Hayat on 6/26/13.
//  Copyright (c) 2013 Nils Hayat. All rights reserved.
//

#import "UIViewController+SlidingController.h"
#import <objc/runtime.h>

@implementation UIViewController (SlidingController)

static char NH_slidingControllerKey;

-(void)setSlidingController:(NHSlidingController *)slidingController
{
	objc_setAssociatedObject(self, &NH_slidingControllerKey, slidingController, OBJC_ASSOCIATION_ASSIGN);
	
	if ([self isKindOfClass:[UINavigationController class]]) {
		UINavigationController *navigationController = (UINavigationController *)self;
		for (UIViewController *viewController in navigationController.viewControllers) {
			[viewController setSlidingController:slidingController];
		}
	}
}

-(NHSlidingController *)slidingController
{
	return objc_getAssociatedObject(self, &NH_slidingControllerKey);
}
@end
