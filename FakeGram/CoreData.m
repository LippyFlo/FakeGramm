//
//  CoreData.m
//  instagram
//
//  Created by LippyFlo on 05.03.15.
//  Copyright (c) 2015 LippyFlo. All rights reserved.
//

#import "CoreData.h"
#import "AppDelegate.h"


@implementation CoreData

+ (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

+(void)deleteallsecretss{
    NSManagedObjectContext *context= [self managedObjectContext];
    NSFetchRequest * alllogpass = [[NSFetchRequest alloc] init];
    [alllogpass setEntity:[NSEntityDescription entityForName:@"Entity" inManagedObjectContext:context]];
    [alllogpass setIncludesPropertyValues:NO];
    
    NSError * error = nil;
    NSArray * logpasses = [context executeFetchRequest:alllogpass error:&error];
    
    for (NSManagedObject * logpass in logpasses) {
        [context deleteObject:logpass];
    }
    NSError *saveError = nil;
    [context save:&saveError];

}

+(NSString *)savesecret:(NSString *)secret
{
    
    NSManagedObjectContext *context= [self managedObjectContext];
    NSManagedObject *secretid = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:context];
    [secretid setValue:secret forKey:@"secretid"];

    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    return @"saved!";
}

+(NSArray *)fetchallmysecrets{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"secretid"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"WHATTHEHELL! YOU GOT NO secrets!");
    }
    return fetchedObjects;
}


@end
