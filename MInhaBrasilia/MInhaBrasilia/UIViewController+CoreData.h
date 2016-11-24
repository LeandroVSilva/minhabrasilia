//
//  UIViewController+CoreData.h
//  MInhaBrasilia
//
//  Created by Leandro Vieira on 04/11/16.
//  Copyright © 2016 Leandro Vieira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CoreData)

@property (readonly) NSManagedObjectContext * managedObjectContext;

@end
