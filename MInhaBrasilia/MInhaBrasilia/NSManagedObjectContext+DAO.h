//
//  NSManagedObjectContext+DAO.h
//  MInhaBrasilia
//
//  Created by Leandro Vieira on 04/11/16.
//  Copyright © 2016 Leandro Vieira. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Favoritos.h"

@interface NSManagedObjectContext (DAO)
-(NSArray<Favoritos *> *) todosFavoritos;
@end
