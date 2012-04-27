//
//  LKWaitPanel.h
//  LKWaitPanel
//
//  Created by Hiroshi Hashiguchi on 11/05/24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LKWaitPanel : UIView {
    
}

// API
//+ (void)showWithTitle:(NSString*)title;
+ (void)showOnView:(UIView*)view title:(NSString*)title;
+ (void)hide;
+ (BOOL)isShowing;

@end
