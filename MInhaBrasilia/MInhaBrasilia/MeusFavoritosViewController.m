//
//  MeusFavoritosViewController.m
//  MInhaBrasilia
//
//  Created by Leandro Vieira on 04/11/16.
//  Copyright © 2016 Leandro Vieira. All rights reserved.
//

#import "MeusFavoritosViewController.h"
#import "UIViewController+CoreData.h"
#import "Favoritos.h"
#import "Localizadores.h"
#import "DetailsViewController.h"


@interface MeusFavoritosViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchController;
@property NSString *alerta;
@end

@implementation MeusFavoritosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    [self alertar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object row:(NSUInteger)index {
    
    NSString * text=[NSString stringWithFormat:@"%@\r%@", [object valueForKey:@"titulo"],[object valueForKey:@"endereco"]];
    
    cell.textLabel.text = text;
    cell.textLabel.numberOfLines = 0;
    cell.backgroundColor = index % 2
    ? [UIColor whiteColor]
    : [UIColor colorWithRed:0.94 green:0.98 blue:0.98 alpha:1.0];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = true;
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self configureCell:cell withObject:object row:indexPath.row];
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorito" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    NSError * error = nil;
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"titulo" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject row:indexPath.row];
            break;
            
        case NSFetchedResultsChangeMove:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject row:indexPath.row];
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            
            
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SegueDetailsFavoritos"]) {
        
        Favoritos * favorito = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        [segue.destinationViewController setFavorito:favorito];
    }
}

-(IBAction)unwindToFavoritos:(UIStoryboardSegue *)segue {
    
}

-(Boolean) contemRegistro {
    
    if(self.fetchedResultsController != nil)
    {
        if([[self.fetchedResultsController fetchedObjects] count] > 0)
        {
            return true;
        }
    }
    
    return false;
}

-(void) alertar
{
    if(![self contemRegistro])
    {
        
        _alerta = [[NSString alloc] initWithFormat:@"Você ainda não marcou nenhum favorito. "];
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"Sem favorito."
                                message:_alerta
                                delegate:nil
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
        [myAlert show];
    }
}


@end
