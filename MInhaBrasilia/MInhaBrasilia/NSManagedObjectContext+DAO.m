//
//  NSManagedObjectContext+DAO.m
//  MInhaBrasilia
//
//  Created by Leandro Vieira on 04/11/16.
//  Copyright © 2016 Leandro Vieira. All rights reserved.
//

#import "NSManagedObjectContext+DAO.h"

@implementation NSManagedObjectContext (DAO)

-(NSArray<Favoritos *> *) todosFavoritos {
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Favorito"];
    return [self executeFetchRequest:request error:nil];
    
}

@end
