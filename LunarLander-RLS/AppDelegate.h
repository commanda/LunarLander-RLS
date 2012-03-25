//
//  AppDelegate.h
//  LunarLander-RLS
//
//  Created by awixted on 2/26/12.
//  Copyright Meteor Grove Software 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
