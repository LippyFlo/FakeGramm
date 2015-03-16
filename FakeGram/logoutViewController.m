//
//  logoutViewController.m
//  FakeGram
//
//  Created by LippyFlo on 07.03.15.
//  Copyright (c) 2015 LippyFlo. All rights reserved.
//

#import "logoutViewController.h"
#import "authViewController.h"

@interface logoutViewController ()

@end

@implementation logoutViewController
@synthesize weblogout;

- (void)viewDidLoad {
    [super viewDidLoad];
    weblogout.delegate =self;
    [self author];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)author{
    //запрос для логаута
    [weblogout loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://instagram.com/accounts/logout"]]]];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //[controller presentViewController:controller animated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
