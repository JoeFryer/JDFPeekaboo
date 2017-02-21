//
//  JDFPeekabooCoordinator.m
//  Joe Fryer
//
//  Created by Joe Fryer on 01/31/2015.
//  Copyright (c) 2014 Joe Fryer. All rights reserved.
//

#import "JDFPeekabooCoordinator.h"
#import <objc/runtime.h>


// Constants
static CGFloat const JDFPeekabooCoordinatorNavigationBarHorizontalHeightDifferential = 20.0f; // This is the difference between the size of the navigation bar when it is in portrait and landscape. This should probably be handled more elegantly.



@interface JDFPeekabooCoordinator() <UIScrollViewDelegate>

// Real delegate
@property (nonatomic, weak) id<UIScrollViewDelegate> scrollViewRealDelegate;

// State
@property (nonatomic) CGFloat previousScrollViewYOffset;
@property (nonatomic) BOOL scrollingCoordinatorEnabled;

// Default values
@property (nonatomic) CGFloat topViewDefaultY;
@property (nonatomic) CGFloat bottomBarDefaultHeight;

@end


@implementation JDFPeekabooCoordinator

#pragma mark - Getters

- (UIView *)containingView
{
    if (!_containingView) {
        return _scrollView;
    }
    return _containingView;
}

- (CGFloat)topViewDefaultY
{
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        if ([self.topView isKindOfClass:[UINavigationBar class]]) {
            return _topViewDefaultY - [[UIApplication sharedApplication] statusBarFrame].size.height - JDFPeekabooCoordinatorNavigationBarHorizontalHeightDifferential;
        } else {
            return _topViewDefaultY - [[UIApplication sharedApplication] statusBarFrame].size.height;
        }
    } else {
        return _topViewDefaultY;
    }
}

- (CGFloat)bottomBarDefaultHeight
{
    return self.bottomView.frame.size.height;
}


#pragma mark - Setters

- (void)setScrollViewRealDelegate:(id<UIScrollViewDelegate>)scrollViewRealDelegate
{
    if (scrollViewRealDelegate != self) {
        _scrollViewRealDelegate = scrollViewRealDelegate;
    }
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        if (scrollView.delegate == self) {
            return;
        }
    } else {
        if (self.scrollView) {
            self.scrollView.delegate = self.scrollViewRealDelegate;
        }
    }
    _scrollView = scrollView;
    self.scrollViewRealDelegate = scrollView.delegate;
    _scrollView.delegate = self;
}

- (void)setBottomView:(UIView *)bottomBar
{
    _bottomView = bottomBar;
    self.bottomBarDefaultHeight = bottomBar.bounds.size.height;
    [self fullyExpandViews];
    if (self.scrollView) {
        [self scrollViewDidScroll:self.scrollView];
    }
}

- (void)setTopView:(UIView *)topBar
{
    _topView = topBar;
    self.topViewDefaultY = topBar.frame.origin.y;
}


#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.topViewMinimisedHeight = 20.0f;
        self.scrollingCoordinatorEnabled = YES;
    }
    return self;
}

- (void)dealloc
{
    self.scrollView.delegate = self.scrollViewRealDelegate;
}


#pragma mark - Public - General

- (void)setBarsNeedDisplay
{
    CGFloat topViewPercentageHidden = [self topViewPercentageHidden];
    [self updateTopViewSubviews:(1.f - topViewPercentageHidden)];
}

- (void)fullyExpandViews
{
    if (self.expandOnReachOnly && self.scrollView.contentOffset.y > FLT_EPSILON) {
        return;
    }
    [self animateTopViewToYPosition:self.topViewDefaultY];
    [self animateBottomViewToYPosition:(self.containingView.frame.size.height - self.bottomBarDefaultHeight)];
    [self setBarsNeedDisplay];
    if ([self.delegate respondsToSelector:@selector(peekabooCoordinator:fullyExpandedViewsForScrollView:)]) {
        [self.delegate peekabooCoordinator:self fullyExpandedViewsForScrollView:self.scrollView];
    }
}

- (void)fullyHideViews
{
    [self animateTopViewToYPosition:[self topViewMinimisedY]];
    [self animateBottomViewToYPosition:[self bottomViewMinimisedY]];
    [self setBarsNeedDisplay];
    if ([self.delegate respondsToSelector:@selector(peekabooCoordinator:fullyCollapsedViewsForScrollView:)]) {
        [self.delegate peekabooCoordinator:self fullyCollapsedViewsForScrollView:self.scrollView];
    }
}


#pragma mark - Public - Enabling/Disabling

- (void)disable
{
    [self disableFullyExpandingViews:YES];
}

- (void)disableLeavingViewsAtCurrentPositon
{
    self.scrollingCoordinatorEnabled = NO;
}

- (void)disableFullyExpandingViews:(BOOL)expandViews
{
    if (expandViews) {
        [self fullyExpandViews];
    }
    self.scrollingCoordinatorEnabled = NO;
}

- (void)disableFullyHidingViews:(BOOL)hideViews
{
    if (hideViews) {
        [self fullyHideViews];
    }
    self.scrollingCoordinatorEnabled = NO;
}

- (void)enable
{
    self.scrollingCoordinatorEnabled = YES;
}

- (void)enableFullyExpandingViews:(BOOL)expandViews
{
    if (expandViews) {
        [self fullyExpandViews];
    }
    self.scrollingCoordinatorEnabled = YES;
}

- (void)enableFullyHidingViews:(BOOL)hideViews
{
    if (hideViews) {
        [self fullyHideViews];
    }
    self.scrollingCoordinatorEnabled = YES;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.frame.size.height > scrollView.contentSize.height) {
        return;
    }

    if (!self.scrollingCoordinatorEnabled) {
        return;
    }

    if ([self.scrollViewRealDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scrollViewRealDelegate scrollViewDidScroll:scrollView];
    }

    if (!(self.scrollView.isDragging || self.scrollView.isDecelerating) && fabs([self topViewPercentageHidden]) < FLT_EPSILON) {
        return;
    }

    if (self.containingView.bounds.size.height - self.topView.bounds.size.height >= scrollView.contentSize.height && self.bottomView) {
        UIEdgeInsets contentInset = self.scrollView.contentInset;
        contentInset.bottom = self.bottomView.bounds.size.height;
        scrollView.contentInset = contentInset;
        return;
    } else {
        scrollView.contentInset = self.scrollView.contentInset;
    }

    CGRect topBarFrame = self.topView.frame;
    CGRect bottomBarFrame = self.bottomView.frame;

    CGFloat topBarHeight = topBarFrame.size.height;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        topBarHeight += self.topViewMinimisedHeight;
    }
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
    CGFloat scrollHeight = scrollView.frame.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;

    CGFloat defaultBottomViewY = self.containingView.frame.size.height - self.bottomBarDefaultHeight;
    if (scrollOffset <= -scrollView.contentInset.top) {
        topBarFrame.origin.y = self.topViewDefaultY;
        bottomBarFrame.origin.y = defaultBottomViewY;
    } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
        topBarFrame.origin.y = -topBarHeight + self.topViewMinimisedHeight;
        bottomBarFrame.origin.y = defaultBottomViewY + self.bottomBarDefaultHeight;
    } else if (! self.expandOnReachOnly || scrollDiff > FLT_EPSILON || scrollOffset + scrollDiff <= - topBarFrame.origin.y - topBarHeight) {
        topBarFrame.origin.y = MIN(self.topViewDefaultY, MAX(-topBarHeight + self.topViewMinimisedHeight, topBarFrame.origin.y - scrollDiff));
        CGFloat toolbarY = MAX(defaultBottomViewY, MIN(self.containingView.frame.size.height, bottomBarFrame.origin.y + scrollDiff));
        bottomBarFrame.origin.y = toolbarY;
    }

    if (self.bottomView) {
        UIEdgeInsets scrollViewInset = self.scrollView.contentInset;
        CGFloat bottomInset = self.containingView.frame.size.height - bottomBarFrame.origin.y;
        scrollViewInset.bottom = bottomInset < 0.0f ? 0.0f : bottomInset;
        self.scrollView.contentInset = scrollViewInset;
    }

    [self.topView setFrame:topBarFrame];
    [self.bottomView setFrame:bottomBarFrame];

    CGFloat top = topBarFrame.origin.y + topBarFrame.size.height;
    CGFloat bottom;

    if (self.bottomView) {
        bottom = self.scrollView.frame.size.height - bottomBarFrame.origin.y;
    } else {
        bottom = self.scrollView.scrollIndicatorInsets.bottom;
    }

    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(top, 0, bottom, 0);

    CGFloat topViewPercentageHidden = [self topViewPercentageHidden];
    [self updateTopViewSubviews:(1.f - topViewPercentageHidden)];

    if (fabs(topViewPercentageHidden) < FLT_EPSILON) {
        if ([self.delegate respondsToSelector:@selector(peekabooCoordinator:fullyExpandedViewsForScrollView:)]) {
            [self.delegate peekabooCoordinator:self fullyExpandedViewsForScrollView:scrollView];
        }
    } else if (fabs(topViewPercentageHidden - 1.f) < FLT_EPSILON) {
        if ([self.delegate respondsToSelector:@selector(peekabooCoordinator:fullyCollapsedViewsForScrollView:)]) {
            [self.delegate peekabooCoordinator:self fullyCollapsedViewsForScrollView:scrollView];
        }
    }

    if ([self.delegate respondsToSelector:@selector(peekabooCoordinator:scrolledToPercentageHidden:)]) {
        [self.delegate peekabooCoordinator:self scrolledToPercentageHidden:topViewPercentageHidden];
    }

    self.previousScrollViewYOffset = scrollOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!self.scrollingCoordinatorEnabled) {
        return;
    }

    if ([self.scrollViewRealDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.scrollViewRealDelegate scrollViewDidEndDecelerating:scrollView];
    }

    [self stoppedScrolling:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!self.scrollingCoordinatorEnabled) {
        return;
    }

    if ([self.scrollViewRealDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.scrollViewRealDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    if (!decelerate) {
        [self stoppedScrolling:scrollView];
    }
}


#pragma mark - Bar Hiding/Showing helpers

- (void)stoppedScrolling:(UIScrollView *)scrollView
{
    CGRect topViewFrame = self.topView.frame;
    CGFloat topViewMinimisedY = [self topViewMinimisedY];
    CGFloat topViewHalfY = (topViewMinimisedY + self.topViewDefaultY) / 2;

    if (fabs([self topViewPercentageHidden]) > FLT_EPSILON && self.topViewMinimisedHeight < - scrollView.contentOffset.y) {
        [self fullyExpandViews];
    } else if (topViewFrame.origin.y > topViewMinimisedY && topViewFrame.origin.y < topViewHalfY) {
        [self fullyHideViews];
    } else if (topViewFrame.origin.y < self.topViewDefaultY && topViewFrame.origin.y >= topViewHalfY) {
        [self fullyExpandViews];
    }
    [self setBarsNeedDisplay];
}

- (void)updateTopViewSubviews:(CGFloat)alpha
{
    if (alpha > 1.0f) {
        alpha = 1.0f;
    } else if (alpha < 0.0f) {
        alpha = 0.0f;
    }

    for (UIView *view in self.topViewItems) {
        view.alpha = alpha;
    }
    self.topView.tintColor = [self.topView.tintColor colorWithAlphaComponent:alpha];

    if ([self.topView isKindOfClass:[UINavigationBar class]]) {
        UINavigationBar *navigationBar = (UINavigationBar *)self.topView;
        NSMutableDictionary *navigationBarTitleTextAttributes = [navigationBar.titleTextAttributes mutableCopy] ? : [NSMutableDictionary dictionary];
        UIColor *titleColor = navigationBarTitleTextAttributes[NSForegroundColorAttributeName] ? : [[UINavigationBar appearance] titleTextAttributes][NSForegroundColorAttributeName] ? : [UIColor blackColor];
        titleColor = [titleColor colorWithAlphaComponent:alpha];
        navigationBarTitleTextAttributes[NSForegroundColorAttributeName] = titleColor;
        navigationBar.titleTextAttributes = navigationBarTitleTextAttributes;
    }
}

- (void)animateTopViewToYPosition:(CGFloat)y
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.topView.frame;
        CGFloat alpha = (frame.origin.y >= y ? 0 : 1);
        frame.origin.y = y;
        [self.topView setFrame:frame];
        [self updateTopViewSubviews:alpha];
    } completion:^(BOOL finished) {
        [self setBarsNeedDisplay];
    }];
}

- (void)animateBottomViewToYPosition:(CGFloat)y
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.bottomView.frame;
        frame.origin.y = y;
        [self.bottomView setFrame:frame];
    } completion:^(BOOL finished) {
        [self setBarsNeedDisplay];
    }];
}

- (CGFloat)topViewPercentageHidden
{
    CGRect frame = self.topView.frame;
    CGFloat percentage = 1.f - (frame.size.height + frame.origin.y - self.topViewMinimisedHeight) / (frame.size.height - self.topViewMinimisedHeight);
    return percentage;
}

- (CGFloat)topViewMinimisedY
{
    CGRect topViewFrame = self.topView.frame;
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        return -topViewFrame.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height;
    } else {
        return -topViewFrame.size.height + self.topViewMinimisedHeight;
    }
}

- (CGFloat)bottomViewMinimisedY
{
    return self.containingView.frame.size.height;
}


#pragma mark - ScrollView delegate forwarding

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([self.scrollViewRealDelegate respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.scrollViewRealDelegate respondsToSelector:aSelector]) {
        return self.scrollViewRealDelegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}


#pragma mark - TableView delegate forwarding

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self isTableViewDelegateMethod:anInvocation.selector]) {

        if ([self.scrollViewRealDelegate respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:self.scrollViewRealDelegate];
        }
    } else {
        [super forwardInvocation:anInvocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([self isTableViewDelegateMethod:aSelector]) {

        if ([self.scrollViewRealDelegate respondsToSelector:aSelector]) {

            return [[self.scrollViewRealDelegate class]
                    instanceMethodSignatureForSelector:aSelector];
        }
    }
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];

    if (! signature) {
        signature = [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return signature;
}


#pragma mark - Private

- (BOOL)isTableViewDelegateMethod:(SEL)aSelector
{
    return protocol_getMethodDescription(@protocol(UITableViewDelegate),
                                         aSelector, NO, YES).name != NULL;
}

@end
