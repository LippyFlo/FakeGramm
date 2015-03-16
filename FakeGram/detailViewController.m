//
//  detailViewController.m
//  FakeGram
//
//  Created by LippyFlo on 06.03.15.
//  Copyright (c) 2015 LippyFlo. All rights reserved.
//

#import "detailViewController.h"
#import "AFNetworking.h"

@interface detailViewController ()

@end

@implementation detailViewController{
    NSURL *url;
    NSMutableArray *allcomments;
    NSMutableArray *alllikes;
}
@synthesize segmentoutlet, imageview;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadlikes];
    [self loadphoto];
    [self loadcomments];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableview reloadData];
}
-(NSURL *)loadphoto{
    //загрузка фото
    url= [[NSURL alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager
     
     GET:[NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@", self.media]
     parameters:@{@"access_token":self.secret}
     
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"%@", [[[[responseObject valueForKey:@"data"] valueForKey:@"images"] valueForKey:@"standard_resolution"] valueForKey:@"url"]);
         NSURL *urlimage = [NSURL URLWithString:[[[[responseObject valueForKey:@"data"] valueForKey:@"images"] valueForKey:@"standard_resolution"] valueForKey:@"url"]];
         url=urlimage;
         NSData *data = [NSData dataWithContentsOfURL:url];
         UIImage *image = [UIImage imageWithData:data];
         [imageview setImage:image];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];
    return url;
}

-(NSMutableArray *)loadcomments{
    //загрузка комментов
    allcomments =[[NSMutableArray alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager
     
     GET:[NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/comments", self.media]
     parameters:@{@"access_token":self.secret}
     
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         NSMutableArray *comments = [[NSMutableArray alloc]init];
         NSString *commentone = [[NSString alloc]init];
         
         for ( id data in [responseObject valueForKey:@"data"]) {
                     
                     commentone = [NSString stringWithFormat:@" %@: %@", [[data valueForKey:@"from"] valueForKey:@"username"], [data valueForKey:@"text"]];
             
             [comments addObject:commentone];
             
         }
         allcomments = comments;
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];
    return allcomments;
}

-(NSMutableArray *)loadlikes{
    //загрузка лайков
    alllikes =[[NSMutableArray alloc]init];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager
     
     GET:[NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes", self.media]
     parameters:@{@"access_token":self.secret}
     
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         NSMutableArray *likes = [[NSMutableArray alloc]init];
         
         for ( id data in [responseObject valueForKey:@"data"]) {
             
             [likes addObject: [NSString stringWithFormat:@" %@", [data valueForKey:@"username"]]];
             
         }
         alllikes = likes;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];
    return alllikes;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (segmentoutlet.selectedSegmentIndex == 0) {
        return [alllikes count];
    }
    else{
        return [allcomments count];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (segmentoutlet.selectedSegmentIndex == 0) {
        [cell.textLabel setText:[alllikes objectAtIndex:indexPath.row]];
    }
    else{
        [cell.textLabel setText:[allcomments objectAtIndex:indexPath.row]];
    }
    
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)segmentchange:(id)sender {
    [self.tableview reloadData];
}
- (IBAction)likeadd:(id)sender {
    //добавить лайк и перезагрузить вью
    
    NSString *HostAdress = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes", self.media];
    NSDictionary *parameters = @{@"access_token":self.secret};
    NSLog(@"%@", _secret);
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:HostAdress
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //[self.tableView reloadRowsAtIndexPaths:[NSIndexPath indexPathForRow:sender.tag inSection:0] withRowAnimation:UITableViewRowAnimationAutomatic];
              NSLog(@"%@", responseObject);
              [self loadlikes];
              [self.tableview reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"%@", error);
          }];
}
@end
