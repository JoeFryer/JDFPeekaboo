//
//  JDFPeekabooCoordinator.h
//  Joe Fryer
//
//  Created by Joe Fryer on 01/31/2015.
//  Copyright (c) 2014 Joe Fryer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JDFPeekabooCoordinator : NSObject

// Scroll View
@property (nonatomic, weak) UIScrollView *scrollView;

// Containing View
@property (nonatomic, weak) UIView *containingView;

// Top Views
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, strong) NSArray *topViewItems;
@property (nonatomic) CGFloat topViewMinimisedHeight;

// Bottom Views
@property (nonatomic, weak) UIView *bottomView;

// Methods
- (void)setBarsNeedDisplay;
- (void)fullyExpandViews;

@end
