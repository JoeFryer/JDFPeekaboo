//
//  JDFPeekabooCoordinator.h
//  Joe Fryer
//
//  Created by Joe Fryer on 01/31/2015.
//  Copyright (c) 2014 Joe Fryer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JDFPeekabooCoordinator : NSObject

#pragma mark - Main Views

/**
 *  This is the scroll view that the @c JDFPeekabooCoordinator tracks. As the scrollView scrolls, the @c topView and @c bottomView are hidden & revealed appropriately.
 */
@property (nonatomic, weak) UIScrollView *scrollView;

/**
 *  This is the view that contains the scrollView.
 */
@property (nonatomic, weak) UIView *containingView;


#pragma mark - Top Views

/**
 *  This view will be moved upwards so that it is hidden as the scrollView scrolls. This could be any view, including a UINavigationBar.
 */
@property (nonatomic, weak) UIView *topView;

/**
 *  This is an array of views (typically they are subviews of the top view) that will be dimmed, and eventually become invisible, as the topView is hidden. This is useful if you have some stuff on your top view that you want to be hidden when it is in its most hidden position.
 */
@property (nonatomic, strong) NSArray *topViewItems;

/**
 *  This is the height of the topView when it is in its most minimised position. The default is 20.0f;
 */
@property (nonatomic) CGFloat topViewMinimisedHeight;


#pragma mark - Bottom Views

/**
 *  This view will be moved upwards so that it is hidden as the scrollView scrolls. This could be any view, including a UINavigationBar.
 */
@property (nonatomic, weak) UIView *bottomView;

#pragma mark - Methods

/**
 *  This method updates the Alpha of the @c topViewItems. You should call this method if you manually adjust the frame of the topView to make sure the alpha of the @c topViewItems is corrrect.
 */
- (void)setBarsNeedDisplay;

/**
 *  This method returns all of the views to their default position.
 */
- (void)fullyExpandViews;

@end
