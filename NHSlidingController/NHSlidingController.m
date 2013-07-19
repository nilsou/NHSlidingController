//
//  NHSlidingController.m
//  sliding
//
//  Created by Nils Hayat on 1/15/13.
//  Copyright (c) 2013 Nils Hayat. All rights reserved.
//

#import "NHSlidingController.h"
#import "UIViewController+SlidingController.h"
#import <QuartzCore/QuartzCore.h>

// Standard speed for the sliding in pt/s
static const CGFloat slidingSpeed = 500.0;

@interface NHSlidingController () {
    UITapGestureRecognizer *tapGestureRecognizer;
}

@property (nonatomic, strong) UIView *topViewContainer;
@property (nonatomic, strong) UIView *bottomViewContainer;

@property (nonatomic) BOOL drawerOpened;

@end

@implementation NHSlidingController

- (id)initWithTopViewController:(UIViewController *)topViewController
           bottomViewController:(UIViewController *)bottomViewController
{
    self = [super init];
    if (self) {
        [self setBottomViewController:bottomViewController];
        [self setTopViewController:topViewController];
		
		self.slideDistance = 200.0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setupTheView];
    [self setupTheShadow];
    [self setupTheGestureRecognizers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Setup Helpers

-(void)setupTheView
{
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	
    _bottomViewContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    _bottomViewContainer.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    [self.view addSubview:_bottomViewContainer];
    [self.view sendSubviewToBack:_bottomViewContainer];
    [self.view addSubview:_bottomViewController.view];
    [_bottomViewController didMoveToParentViewController:self];
    
    _topViewContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    _topViewContainer.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    [self.view addSubview:_topViewContainer];
    [self.view bringSubviewToFront:_topViewContainer];
    [self.view addSubview:_topViewController.view];
    [_topViewController didMoveToParentViewController:self];
}

-(void)setupTheShadow
{
	
	self.topViewContainer.layer.shadowColor = [UIColor blackColor].CGColor;
	self.topViewContainer.layer.shadowOpacity = 0.7;
	self.topViewContainer.layer.shadowRadius = 8.0;
	self.topViewContainer.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.topViewContainer.bounds].CGPath;
}

-(void)setupTheGestureRecognizers
{
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tapGestureRecognizer.delegate = self;
    tapGestureRecognizer.enabled = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - Custom Accessors

-(void)setTopViewController:(UIViewController *)topViewController
{
    //remove old view controller
    [_topViewController.view removeFromSuperview];
    [_topViewController removeFromParentViewController];
    
    //replace with the new
    topViewController.view.frame = self.view.bounds;
    _topViewController = topViewController;

    [self addChildViewController:topViewController];
    topViewController.view.clipsToBounds = YES;
    [_topViewContainer addSubview:topViewController.view];
    [self.view bringSubviewToFront:_topViewContainer];
	
	_topViewController.slidingController = self;
}

-(void)setBottomViewController:(UIViewController *)bottomViewController
{
    //remove old view controller
    [_bottomViewController.view removeFromSuperview];
    [_bottomViewController removeFromParentViewController];
    
    bottomViewController.view.frame = self.view.bounds;
    _bottomViewController = bottomViewController;
    [self addChildViewController:bottomViewController];
    [_bottomViewContainer addSubview:bottomViewController.view];
    [self.view sendSubviewToBack:_bottomViewContainer];
	
	_bottomViewController.slidingController = self;
}

-(void)setDrawerOpened:(BOOL)drawerOpened
{
    _drawerOpened = drawerOpened;
    if (drawerOpened) {
        _topViewContainer.userInteractionEnabled = NO;
        tapGestureRecognizer.enabled = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kSlidingControllerDidOpenNotification object:self];
    } else {
        _topViewContainer.userInteractionEnabled = YES;
        tapGestureRecognizer.enabled = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:kSlidingControllerDidCloseNotification object:self];
    }
}

#pragma mark - Animation Trigger Methods

-(void)setTopViewController:(UIViewController *)topViewController animated:(BOOL)animated
{
    if (!self.drawerOpened) {
        [self toggleDrawer];
    }
    if (animated) {
        CGRect frame = self.view.bounds;
        CGPoint centerForOutside = CGPointMake(frame.size.width * 1.5, CGRectGetMidY(frame));
        [UIView animateWithDuration:0.3 animations:^{
            _topViewContainer.center = centerForOutside;
        } completion:^(BOOL finished) {
            self.topViewController = topViewController;
            [self toggleDrawer];
        }];
    } else {
        self.topViewController = topViewController;
    }
}

- (void)setDrawerOpened:(BOOL)opened animated:(BOOL)animated
{
    self.drawerOpened = opened;
    
    CGFloat duration = self.slideDistance / slidingSpeed;
    CGPoint center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));

    if (opened) {
        center.x += self.slideDistance;
        [self.bottomViewController viewWillAppear:YES];
    }
    
    [UIView animateWithDuration:duration animations:^{
        _topViewContainer.center = center;
    }];
    
}

#pragma mark - Public Methods

- (void)toggleDrawer
{
    [self setDrawerOpened:!_drawerOpened animated:YES];
}

-(void)openDrawerAnimated:(BOOL)animated
{
    [self setDrawerOpened:YES animated:animated];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [panGestureRecognizer translationInView:self.view];
        BOOL directionIsHorizontal = (fabs(translation.x) > fabs(translation.y));
        BOOL directionIsToRight = translation.x > 0;
        return directionIsHorizontal && (directionIsToRight || self.drawerOpened);
    } else if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)gestureRecognizer;
        return [tapRecognizer locationInView:self.view].x > self.slideDistance;
    }
    
    return YES;
}

-(void)panned:(UIPanGestureRecognizer *)recognizer
{
	CGFloat translation = [recognizer translationInView:self.view].x;
    [recognizer setTranslation:CGPointZero inView:self.view];
    
	CGFloat openedWidthCenter = CGRectGetMidX(self.view.bounds) + self.slideDistance;
	
    CGPoint center = _topViewContainer.center;
    center.x = center.x < openedWidthCenter ? center.x + translation : center.x + translation / (1.0 + center.x - openedWidthCenter);
	center.x = MAX(center.x, CGRectGetMidX(self.view.bounds));
    _topViewContainer.center = center;
        
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat velocity = [recognizer velocityInView:self.view].x;
        
        CGFloat centerForEdge, centerForBounce;
        BOOL finalOpenState;
        if (velocity > 0) {
            centerForEdge = CGRectGetMidX(self.view.bounds) + self.slideDistance;
            centerForBounce = centerForEdge + 22.0;
            finalOpenState = YES;
        } else {
            centerForEdge = CGRectGetMidX(self.view.bounds);
            centerForBounce = (centerForEdge - 22.0);
            finalOpenState = NO;
        }
        
        CGFloat distanceToTheEdge = centerForEdge - _topViewContainer.center.x;
        CGFloat timeToEdgeWithCurrentVelocity = fabs(distanceToTheEdge) / fabs(velocity);
        CGFloat timeToEdgeWithStandardVelocity = fabsf(distanceToTheEdge) / slidingSpeed;
                
        if (timeToEdgeWithCurrentVelocity < 0.7 * timeToEdgeWithStandardVelocity) {
            //Bounce and open
            center.x = centerForBounce;
            
            [UIView animateWithDuration:timeToEdgeWithCurrentVelocity delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _topViewContainer.center = center;
            } completion:^(BOOL finished) {
                CGPoint center = _topViewContainer.center;
                center.x = centerForEdge;
                [UIView animateWithDuration:0.3 animations:^{
                    _topViewContainer.center = center;
                } completion:^(BOOL finished) {
                    self.drawerOpened = finalOpenState;
                }];
            }];
        } else if (timeToEdgeWithCurrentVelocity < timeToEdgeWithStandardVelocity) {
            //finish the sliding with the current speed
            center.x = centerForEdge;
            
            [UIView animateWithDuration:timeToEdgeWithCurrentVelocity delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _topViewContainer.center = center;
            } completion:^(BOOL finished) {
                self.drawerOpened = finalOpenState;
            }];
        } else {
            //finish the sliding wiht minimum speed
            CGFloat duration = distanceToTheEdge / slidingSpeed;
            center.x = centerForEdge;
            [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _topViewContainer.center = center;
            } completion:^(BOOL finished) {
                self.drawerOpened = finalOpenState;
            }];
        }
    
    }
}

-(void)tapped:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self toggleDrawer];
}

@end
