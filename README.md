# JDFPeekaboo

[![Version](https://img.shields.io/cocoapods/v/JDFPeekaboo.svg?style=flat)](http://cocoadocs.org/docsets/JDFPeekaboo)
[![License](https://img.shields.io/cocoapods/l/JDFPeekaboo.svg?style=flat)](http://cocoadocs.org/docsets/JDFPeekaboo)
[![Platform](https://img.shields.io/cocoapods/p/JDFPeekaboo.svg?style=flat)](http://cocoadocs.org/docsets/JDFPeekaboo)

JDFPeekaboo is a simple class that hides the navigation bar when you scroll down, and shows it again when you scroll back up. It can actually be any UIView that it hides, and it will also hide a view at the bottom of the screen as well, if you like.

It's very easy to use. Simply add a property for it:

    @property (nonatomic, strong) JDFPeekabooCoordinator *scrollCoordinator;

Then, set it up (say, in `-viewDidLoad`):

``` objc
self.scrollCoordinator = [[JDFPeekabooCoordinator alloc] init];
self.scrollCoordinator.scrollView = self.scrollView;
self.scrollCoordinator.topView = self.navigationController.navigationBar;
self.scrollCoordinator.bottomView = self.navigationController.toolbar;
```

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

JDFPeekaboo is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

    pod "JDFPeekaboo"

## Author

Joe Fryer, joe.d.fryer@gmail.com

Twitter - [JoeFryer88](https://twitter.com/joefryer88)

## License

JDFPeekaboo is available under the MIT license. See the LICENSE file for more info.

