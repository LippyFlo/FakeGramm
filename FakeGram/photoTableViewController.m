//
//  photoTableViewController.m
//  FakeGram
//
//  Created by LippyFlo on 06.03.15.
//  Copyright (c) 2015 LippyFlo. All rights reserved.
//

#import "photoTableViewController.h"
#import "CoreData.h"
#import "authViewController.h"
#import "AFNetworking.h"
#import "detailViewController.h"
#import "logoutViewController.h"

@interface photoTableViewController ()

@end

@implementation photoTableViewController

-(void)viewWillAppear:(BOOL)animated{
    //проверяем секретайди, и если его нет кидаем на авторизацию
    if (![CoreData fetchallmysecrets].count) {
        authViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"auth"];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else{
        self.secret = [[[CoreData fetchallmysecrets]objectAtIndex:0]valueForKey:@"secretid"];
        [self refreshfeed];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];


    _min_id = [[NSString alloc]init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)handletaponce:(UITapGestureRecognizer *)sender{
    //хендл тап на картинке
    UITableView* tableView = (UITableView*)self.view;
    CGPoint touchPoint = [sender locationInView:self.view];
    NSIndexPath* row = [tableView indexPathForRowAtPoint:touchPoint];

    if (row != nil) {
        
        detailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
        [controller setMedia:[_media valueForKey:[NSString stringWithFormat:@"%ld", (long)row.row]]];
        [controller setSecret:self.secret];
        [self showViewController:controller sender:nil];
    }

}

-(void)likeadd:(UIButton*)sender{
//добавляем лайк
    NSString *HostAdress = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes", [_media valueForKey:[NSString stringWithFormat:@"%ld", (long)sender.tag]] ];
    NSLog(@"%@", HostAdress);
    NSDictionary *parameters = @{@"access_token":self.secret};
    NSLog(@"%@", [_media valueForKey:[NSString stringWithFormat:@"%ld", (long)sender.tag]]);
    NSLog(@"%@", _secret);
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:HostAdress
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {

              NSLog(@"%@", responseObject);
              _likesfeed = [self likes];
              [self.tableView reloadData];
              //[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]] reloadInputViews];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"%@", error);
          }];
}

- (IBAction)refresh:(id)sender {
    [self refreshfeed];
}

-(void)refreshfeed{
    //обновление фида
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager
     
        GET:@"https://api.instagram.com/v1/users/self/feed"
        parameters:@{@"access_token":self.secret, @"count":@"10"}
     
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             _feed = [[NSMutableArray alloc]init];
             _feed = [[NSMutableArray alloc]initWithArray:[responseObject valueForKey:@"data"]];

             [self comments];
             [self allcomments];
             [self images];
             [self likes];
             [self media];
             
             [self.tableView reloadData];
             [self.refreshControl endRefreshing];
             
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [CoreData deleteallsecretss];
        logoutViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"logout"];
        [self presentViewController:controller animated:YES completion:nil];
    }];
    


}

-(void)addfeed{
    //добавление фида при прокрутке
    NSInteger i = [_feed count];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSInteger y = i+11;
    while (i<y) {
        i++;
        [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];

    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager
     
     GET:@"https://api.instagram.com/v1/users/self/feed"
     parameters:@{@"access_token":self.secret, @"count":@"10", @"max_id":_min_id}
     
     success:^(AFHTTPRequestOperation *operation, id responseObject) {

         [_feed addObjectsFromArray:[responseObject valueForKey:@"data"]];
         
         NSMutableDictionary *copy = [_commentsfeed mutableCopy];
         [self comments];
         [_commentsfeed addEntriesFromDictionary:copy];

         NSMutableDictionary *copyall = [_allcomments mutableCopy];
         [self allcomments];
         [_allcomments addEntriesFromDictionary:copyall];
         
         NSMutableDictionary *copyimages = [_imagesfeed mutableCopy];
         [self images];
         [_imagesfeed addEntriesFromDictionary:copyimages];
         
         NSMutableDictionary *copylikes = [_likesfeed mutableCopy];
         [self likes];
         [_likesfeed addEntriesFromDictionary:copylikes];
         
         NSMutableDictionary *copymedia = [_media mutableCopy];
         [self media];
         [_media addEntriesFromDictionary:copymedia];
         
         [self.tableView reloadData];


     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         [CoreData deleteallsecretss];
         authViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"auth"];
         [self presentViewController:controller animated:YES completion:nil];
     }];
    
    
    
}

-(NSMutableDictionary *)likes{
    //забираем лайки
    _likesfeed = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *likes = [[NSMutableDictionary alloc]init];
    int d=0;
    
    for ( id data in _feed) {
        
        [likes setObject:[[data valueForKey:@"likes"] valueForKey:@"count"] forKey:[NSString stringWithFormat:@"%d", d]];
        
        d++;
        
    }
    _likesfeed = [[NSMutableDictionary alloc]initWithDictionary:likes];
    return _likesfeed;

}

-(NSMutableDictionary *)media{
    //забираем айди медиа
    _media = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *mediaone = [[NSMutableDictionary alloc]init];
    int d=0;
    
    for ( id data in _feed) {
        
        [mediaone setObject:[data valueForKey:@"id"] forKey:[NSString stringWithFormat:@"%d", d]];
        
        d++;
        
    }
    _media = [[NSMutableDictionary alloc]initWithDictionary:mediaone];
    return _media;
    
}

-(NSDictionary *)comments{
    //забираем 3 комментария для фида
    NSMutableDictionary *comments = [[NSMutableDictionary alloc]init];
    NSString *commentone = [[NSString alloc]init];
    int d=0;

    for ( id data in _feed) {
        int i=0;
        for (id comment in [[data valueForKey:@"comments"] valueForKey:@"data"]) {
            if (i<3) {
                
            commentone = [NSString stringWithFormat:@"%@ %@: %@\r\r", commentone, [[comment valueForKey:@"from"] valueForKey:@"username"], [comment valueForKey:@"text"]];
            i++;
                
            }
        }
        [comments setObject:commentone forKey:[NSString stringWithFormat:@"%d", d]];
        commentone = [[NSString alloc]init];
        i=0;
        d++;

    }
    _commentsfeed = [[NSMutableDictionary alloc]initWithDictionary:comments];
    return _commentsfeed;
}

-(NSDictionary *)allcomments{
    //все комментарии
    NSMutableDictionary *comments = [[NSMutableDictionary alloc]init];

    int d=0;
    
    for ( id data in _feed) {
        
        [comments setObject:[[data valueForKey:@"comments"] valueForKey:@"count"] forKey:[NSString stringWithFormat:@"%d", d]];
        
        d++;
        
    }

    _allcomments = [[NSMutableDictionary alloc]initWithDictionary:comments];
    return _allcomments;
}

-(NSDictionary *)images{
    //картинки
    _imagesfeed = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *images = [[NSMutableDictionary alloc]init];
    NSURL *imageone = [[NSURL alloc]init];
    int d=0;
    
    for ( id image in [[[_feed valueForKey:@"images"] valueForKey:@"low_resolution"] valueForKey:@"url"]) {

            imageone = [NSURL URLWithString:image];
            
        [images setObject:imageone forKey:[NSString stringWithFormat:@"%d", d]];
        imageone = [[NSURL alloc]init];
        d++;
    }
    _imagesfeed = [[NSMutableDictionary alloc]initWithDictionary:images];
    return _imagesfeed;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_feed count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *image = (UIImageView*)[cell viewWithTag:1];
    UILabel *labelcomment = (UILabel *)[cell viewWithTag:2];
    UILabel *labellike = (UILabel *)[cell viewWithTag:3];
    UITextView *comments = (UITextView *)[cell viewWithTag:4];
    UIButton *likebutton = (UIButton *)[cell viewWithTag:5];
    
    [likebutton addTarget:self action:@selector(likeadd:) forControlEvents:UIControlEventTouchUpInside];
    
    NSData *data = [NSData dataWithContentsOfURL:[_imagesfeed objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
    [labelcomment setText:[NSString stringWithFormat:@"%@", [_allcomments objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]]];
    [image setImage:[UIImage imageWithData:data]];
    [comments setText:[_commentsfeed objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
    [labellike setText:[NSString stringWithFormat:@"%@", [_likesfeed objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]]];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handletaponce:)];
    recognizer.numberOfTapsRequired = 1;

    [self.view addGestureRecognizer:recognizer];
    likebutton.tag = indexPath.row;
    [likebutton addTarget:self action:@selector(likeadd:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.row == [_feed count]-2) {
        _min_id = [_media valueForKey:[NSString stringWithFormat:@"%lu", (unsigned long)[_feed count]-1]];
        [self addfeed];
    }
}

- (IBAction)logout:(id)sender {
    //удаляем секретайди пользователя
    [CoreData deleteallsecretss];
    self.secret = @"";
    [self refreshfeed];
}
@end
