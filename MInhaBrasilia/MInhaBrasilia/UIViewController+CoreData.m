//
//  UIViewController+CoreData.m
//  MInhaBrasilia
//
//  Created by Leandro Vieira on 04/11/16.
//  Copyright © 2016 Leandro Vieira. All rights reserved.
//

#import "UIViewController+CoreData.h"
#import "AppDelegate.h"

@implementation UIViewController (CoreData)

-(NSManagedObjectContext *)managedObjectContext {
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegate.managedObjectContext;
}

@end
