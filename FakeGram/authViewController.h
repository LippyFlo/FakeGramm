//
//  authViewController.h
//  instagram
//
//  Created by LippyFlo on 05.03.15.
//  Copyright (c) 2015 LippyFlo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface authViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webauth;

@end
