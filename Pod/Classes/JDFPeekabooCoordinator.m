//
//  JDFPeekabooCoordinator.m
//  Joe Fryer
//
//  Created by Joe Fryer on 01/31/2015.
//  Copyright (c) 2014 Joe Fryer. All rights reserved.
//

#import "JDFPeekabooCoordinator.h"


@interface JDFPeekabooCoordinator() <UIScrollViewDelegate>

// Real delegate
@property (nonatomic, weak) id<UIScrollViewDelegate> scrollViewRealDelegate;

// State
@property (nonatomic) CGFloat previousScrollViewYOffset;

// Default values
@property (nonatomic) CGFloat topViewDefaultY;
@property (nonatomic) CGFloat bottomBarDefaultHeight;

@end


@implementation JDFPeekabooCoordinator

#pragma mark - Setters

- (void)setScrollViewRealDelegate:(id<UIScrollViewDelegate>)scrollViewRealDelegate
{
    if (scrollViewRealDelegate != self) {
        _scrollViewRealDelegate = scrollViewRealDelegate;
    }
}

- (void)setScrollView:(UIScrollView *)scrollView
{
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
    self.topViewItems = [NSMutableArray array];
    
    for (UIView* view in topBar.subviews) {
        bool isBackgroundView = [topBar isKindOfClass:[UINavigationBar class]] && view == [topBar.subviews objectAtIndex:0];
        bool isHidden = view.hidden || view.alpha == 0.0f;
        
        if (!isBackgroundView && !isHidden) {
            [self.topViewItems addObject:view];
        }
    }
}


#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.topViewMinimisedHeight = 20.0f;
    }
    return self;
}


#pragma mark - Public

- (void)setBarsNeedDisplay
{
    CGFloat topViewPercentageHidden = [self topViewPercentageHidden];
    [self updateTopViewSubviews:(1 - topViewPercentageHidden)];
}

- (void)fullyExpandViews
{
    [self animateTopViewToYPosition:self.topViewDefaultY];
    [self animateBottomViewToYPosition:(self.containingView.frame.size.height - self.bottomBarDefaultHeight)];
    [self setBarsNeedDisplay];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.scrollViewRealDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scrollViewRealDelegate scrollViewDidScroll:scrollView];
    }
    
    if (self.containingView.bounds.size.height - self.topView.bounds.size.height >= scrollView.contentSize.height) {
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
        bottomBarFrame.origin.y = defaultBottomViewY + topBarHeight;
    } else {
        topBarFrame.origin.y = MIN(self.topViewDefaultY, MAX(-topBarHeight + self.topViewMinimisedHeight, topBarFrame.origin.y - scrollDiff));
        CGFloat toolbarY = MAX(defaultBottomViewY, MIN(self.containingView.frame.size.height, bottomBarFrame.origin.y + scrollDiff));
        bottomBarFrame.origin.y = toolbarY;
    }
    
    UIEdgeInsets scrollViewInset = self.scrollView.contentInset;
    CGFloat bottomInset = self.containingView.frame.size.height - bottomBarFrame.origin.y;
    scrollViewInset.bottom = bottomInset < 0.0f ? 0.0f : bottomInset;
    self.scrollView.contentInset = scrollViewInset;
    
    [self.topView setFrame:topBarFrame];
    [self.bottomView setFrame:bottomBarFrame];
    
    CGFloat topViewPercentageHidden = [self topViewPercentageHidden];
    [self updateTopViewSubviews:(1 - topViewPercentageHidden)];
    
    self.previousScrollViewYOffset = scrollOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.scrollViewRealDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.scrollViewRealDelegate scrollViewDidEndDecelerating:scrollView];
    }
    
    [self stoppedScrolling:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
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
    if (topViewFrame.size.height + scrollView.contentOffset.y - self.topViewMinimisedHeight < 0) {
        [self animateTopViewToYPosition:self.topViewDefaultY];
        [self animateBottomViewToYPosition:(self.containingView.frame.size.height - self.bottomBarDefaultHeight)];
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
    CGFloat percentage = (self.topViewDefaultY - frame.origin.y) / (frame.size.height - 1 - self.topViewMinimisedHeight);
    return percentage;
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

@end
