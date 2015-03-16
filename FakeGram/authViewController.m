//
//  authViewController.m
//  instagram
//
//  Created by LippyFlo on 05.03.15.
//  Copyright (c) 2015 LippyFlo. All rights reserved.
//

#import "authViewController.h"
#import "CoreData.h"
#import "photoTableViewController.h"

@interface authViewController ()


@end

@implementation authViewController
@synthesize webauth;

- (void)viewDidLoad {
    [super viewDidLoad];
    webauth.delegate = self;
    
    static NSString *client_id = @"71bf13eb627f44a0968b31358d2e50b1";
    static NSString *REDIRECT = @"http://ridewithme.com";
    
    [webauth loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&scope=likes", client_id,REDIRECT]]]];
    // Do any additional setup after loading the view.
}


-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSString *currentURL = webauth.request.URL.absoluteString;
    NSLog(@"%@", currentURL);
    if ([currentURL hasPrefix:@"http://ridewithme.com"]) {
        [webauth stopLoading];
        
        if (![CoreData fetchallmysecrets].count) {
            
            [CoreData deleteallsecretss];
        }
        if ([[CoreData savesecret:[[currentURL componentsSeparatedByString:@"http://ridewithme.com/#access_token="] objectAtIndex:1]] isEqualToString:@"saved!"]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Внимание" message:@"Что-то пошло не так" delegate:nil cancelButtonTitle:@"Отмена" otherButtonTitles:nil, nil];
            [alert show];

        }
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
