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
 *  This is the view that contains the top & bottom views, if this isn't the scrollView.
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
 *  Updates the Alpha of the @c topViewItems. You should call this method if you manually adjust the frame of the topView to make sure the alpha of the @c topViewItems is corrrect.
 */
- (void)setBarsNeedDisplay;

/**
 *  Returns all of the views to their default position.
 */
- (void)fullyExpandViews;

/**
 *  Moves all of the views to their minimised position;
 */
- (void)fullyHideViews;


#pragma mark - Enabling/Disabling

/**
 *  Disables the @c JDFPeekabooCoordinator from automatically adjusting the views in response to the @c scrollView scrolling. Using this method fully expands the views before disabling (if you don't require this behaviour, use @c -disableLeavingViewsAtCurrentPositon).
 
 *   @note Disabling c JDFPeekabooCoordinator only disables adjustments that are in response to the @c scrollView. Calling methods like @c -fullyExpandViews still takes effect.
 */
- (void)disable;

/**
 *  Disables the @c JDFPeekabooCoordinator from automatically adjusting the views in response to the @c scrollView scrolling. Using this method leaves the bars in their current position.
 
 *  @note Disabling c JDFPeekabooCoordinator only disables adjustments that are in response to the @c scrollView. Calling methods like @c -fullyExpandViews still takes effect.
 */
- (void)disableLeavingViewsAtCurrentPositon;

/**
 *  Disables the @c JDFPeekabooCoordinator from automatically adjusting the views in response to the @c scrollView scrolling, optionally returning all views to their default (expanded) postion.
 *
 *  @param expandViews Indicates whether or not to expand the views before disabling.
 
 *  @note Disabling c JDFPeekabooCoordinator only disables adjustments that are in response to the @c scrollView. Calling methods like @c -fullyExpandViews still takes effect.
 */
- (void)disableFullyExpandingViews:(BOOL)expandViews;

/**
 *  Disables the @c JDFPeekabooCoordinator from automatically adjusting the views in response to the @c scrollView scrolling, optionally returning all views to their hidden (minimised) postion.
 *
 *  @param hideViews Indicates whether or not to hide the views before disabling.
 
 *  @note Disabling c JDFPeekabooCoordinator only disables adjustments that are in response to the @c scrollView. Calling methods like @c -fullyExpandViews still takes effect.
 */
- (void)disableFullyHidingViews:(BOOL)hideViews;

/**
 *  Enables the @c JDFPeekabooCoordinator so that it begins adjusting the views in response to the @c scrollView scrolling. Using this method leaves the views in their current position after enabling.
 */
- (void)enable;

/**
 *  Enables the @c JDFPeekabooCoordinator so that it begins adjusting the views in response to the @c scrollView scrolling, optionally returning all views to their default (expanded) position.
 *
 *  @param expandViews Indicates whether or not to expand the views before enabling.
 */
- (void)enableFullyExpandingViews:(BOOL)expandViews;

/**
 *  Enables the @c JDFPeekabooCoordinator so that it begins adjusting the views in response to the @c scrollView scrolling, optionally returning all views to their hidden (minimised) position.
 *
 *  @param hideViews Indicates whether or not to hide the views before enabling.
 */
- (void)enableFullyHidingViews:(BOOL)hideViews;

@end
