//
//  LKWaitPanel.m
//  LKWaitPanel
//
//  Created by Hiroshi Hashiguchi on 11/05/24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LKWaitPanel.h"

static LKWaitPanel* sharedPanel_ = nil;

//---
@interface LKWaitPanelBackgroundView : UIView {
}
@end

@implementation LKWaitPanelBackgroundView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath* panelPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                         cornerRadius:10.0];
    [[UIColor colorWithWhite:0.0 alpha:0.5] set];
    [panelPath fill];
}


@end

//---
@interface LKWaitPanel()

@property (nonatomic, retain) UIView* panelView;
@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UIActivityIndicatorView* activityIndicatorView;
@property (nonatomic, assign) CGRect panelFrame;

@end


@implementation LKWaitPanel

@synthesize panelView;
@synthesize titleLabel;
@synthesize activityIndicatorView;
@synthesize panelFrame;

/*
#define LK_WAITPANEL_HEIGHT 100
#define LK_WAITPANEL_WIDTH  (LK_WAITPANEL_HEIGHT*1.618)
*/
#define LK_WAITPANEL_WIDTH  200
#define LK_WAITPANEL_HEIGHT 100

#define LK_WAITPANEL_TITLE_MARGIN_HORIZONTAL 10
#define LK_WAITPANEL_TITLE_TOP               15
#define LK_WAITPANEL_TITLE_HEIGHT            26
#define LK_WAITPANEL_ACTIVITY_TOP            (LK_WAITPANEL_TITLE_TOP+LK_WAITPANEL_TITLE_HEIGHT+15)

- (void)_resignFirstResponderOnView:(UIView*)superview
{
    for (UIView* view in superview.subviews) {
        if (view.isFirstResponder) {
            [view resignFirstResponder];
            break;
        } else if ([view.subviews count] > 0) {
            [self _resignFirstResponderOnView:view];
        }
    }
}

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        CGRect applicationBounds = [UIScreen mainScreen].applicationFrame;
        applicationBounds.origin = CGPointZero;
        
        self.panelFrame = CGRectMake((applicationBounds.size.width-LK_WAITPANEL_WIDTH)/2.0,
                                     (applicationBounds.size.height-LK_WAITPANEL_HEIGHT)/2.0,
                                     LK_WAITPANEL_WIDTH,
                                     LK_WAITPANEL_HEIGHT);
        self.frame = applicationBounds;

        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];

        self.panelView = [[[LKWaitPanelBackgroundView alloc] initWithFrame:self.panelFrame] autorelease];
        self.panelView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|
        UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.panelView];
        
        
        self.activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        CGRect activityFrame = self.activityIndicatorView.frame;
        activityFrame.origin.x = (LK_WAITPANEL_WIDTH-activityFrame.size.width)/2.0;
        activityFrame.origin.y = LK_WAITPANEL_ACTIVITY_TOP;
        self.activityIndicatorView.frame = activityFrame;
        [self.panelView addSubview:self.activityIndicatorView];
        
        CGRect labelFrame = CGRectMake(LK_WAITPANEL_TITLE_MARGIN_HORIZONTAL,
                                       LK_WAITPANEL_TITLE_TOP,
                                       panelFrame.size.width-LK_WAITPANEL_TITLE_MARGIN_HORIZONTAL*2,
                                       LK_WAITPANEL_TITLE_HEIGHT);
        self.titleLabel = [[[UILabel alloc] initWithFrame:labelFrame] autorelease];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        [self.panelView addSubview:self.titleLabel];
    }
    return self;
}

/*
- (void)layoutSubviews
{
    NSLog(@"x");
    [self _relayout];
}
 */

#define LK_WAITPANEL_FRAME_MARGIN 7.5
- (void)dealloc
{
    self.panelView = nil;
    self.titleLabel = nil;
    self.activityIndicatorView = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Private
- (void)_showOnView:(UIView*)view title:(NSString*)title
{
    if (self.superview) {
        [self removeFromSuperview];
    }
    self.alpha = 0.0;
    [view addSubview:self];
    self.frame = view.bounds;
    [self _resignFirstResponderOnView:self.superview];
    self.titleLabel.text = title;
    [self.activityIndicatorView startAnimating];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    }];
}
- (void)_hide
{
    [self.activityIndicatorView stopAnimating];
    if (self.superview) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.alpha = 0.0;
                         }
                         completion:^(BOOL completion) {
                             [self removeFromSuperview];
                         }];
    }
}



#pragma mark -
#pragma mark API
+ (void)showOnView:(UIView*)view title:(NSString*)title ;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPanel_ = [[self alloc] init];
    });
    [sharedPanel_ _showOnView:view title:title];
}

+ (void)hide
{
    [sharedPanel_ _hide];
}

+ (BOOL)isShowing
{
    return (sharedPanel_.superview != nil); 
}

@end
