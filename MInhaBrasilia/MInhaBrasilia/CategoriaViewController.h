//
//  CategoriaViewController.h
//  MInhaBrasilia
//
//  Created by Leandro Vieira on 26/10/16.
//  Copyright © 2016 Leandro Vieira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Localizadores.h"

@interface CategoriaViewController : UITableViewController

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property Localizadores * localizador;

@end
