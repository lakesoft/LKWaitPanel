//
//  LKWaitPanelAppDelegate.h
//  LKWaitPanel
//
//  Created by Hiroshi Hashiguchi on 11/05/24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKWaitPanelViewController;

@interface LKWaitPanelAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet LKWaitPanelViewController *viewController;

@end
