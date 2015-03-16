//
//  CoreData.h
//  instagram
//
//  Created by LippyFlo on 05.03.15.
//  Copyright (c) 2015 LippyFlo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface CoreData : NSObject <NSFetchedResultsControllerDelegate>


+(NSArray *)fetchallmysecrets;
+(void)deleteallsecretss;
+(NSString *)savesecret:(NSString *)secret;

@end
