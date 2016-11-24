//
//  MeusFavoritosViewController.h
//  MInhaBrasilia
//
//  Created by Leandro Vieira on 04/11/16.
//  Copyright © 2016 Leandro Vieira. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface MeusFavoritosViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

-(IBAction)unwindToFavoritos:(UIStoryboardSegue *)segue;

-(Boolean) contemRegistro;
@end
