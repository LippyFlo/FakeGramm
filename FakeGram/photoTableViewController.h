//
//  photoTableViewController.h
//  FakeGram
//
//  Created by LippyFlo on 06.03.15.
//  Copyright (c) 2015 LippyFlo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface photoTableViewController : UITableViewController

@property (strong, nonatomic) NSString *secret;
@property(strong, nonatomic)NSMutableDictionary *comments;
@property(strong, nonatomic)NSMutableDictionary *likes;
@property(strong, nonatomic)NSMutableDictionary *wholikes;
@property(strong, nonatomic)NSMutableDictionary *images;



@property(strong, nonatomic)    NSMutableDictionary *commentsfeed;
@property(strong, nonatomic)        NSMutableDictionary *allcomments;
@property(strong, nonatomic)        NSMutableDictionary *imagesfeed;
@property(strong, nonatomic) NSMutableDictionary *media;
@property(strong, nonatomic)     NSMutableDictionary *likesfeed;
@property(strong, nonatomic) NSMutableArray *feed;
@property(strong, nonatomic) NSString *min_id;

- (IBAction)logout:(id)sender;


@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tappedonce;

@end
