//
//  detailViewController.h
//  FakeGram
//
//  Created by LippyFlo on 06.03.15.
//  Copyright (c) 2015 LippyFlo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *media;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentoutlet;
@property(strong, nonatomic) NSString *secret;
- (IBAction)segmentchange:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

- (IBAction)likeadd:(id)sender;

@end
