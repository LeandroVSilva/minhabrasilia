//
//  LocalizacoesViewController.m
//  MInhaBrasilia
//
//  Created by Leandro Vieira on 27/10/16.
//  Copyright © 2016 Leandro Vieira. All rights reserved.
//

#import "LocalizacoesViewController.h"
#import "Localizadores.h"
#import "DetailsViewController.h"

@interface LocalizacoesViewController ()

@property (nonatomic, copy) NSArray *localizacoes;
//@property (nonatomic, copy) UIActivityIndicatorView *spinner;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;


@end

@implementation LocalizacoesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SegueDetails"]) {
        
        if ([sender isKindOfClass:[Localizadores class]]){
            
            DetailsViewController *detailsView = [segue destinationViewController];
            detailsView.localizacao = [[Localizadores alloc]init];
            detailsView.localizacao = sender;
        }
    }
    [self.spinner stopAnimating];
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellLocalizacoes" forIndexPath:indexPath];
    
    Localizadores *localizacao = (Localizadores *) [self.listaLocalizacoes objectAtIndex:indexPath.row];
    [self configureCell:cell withObject:localizacao row:indexPath.row];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withObject:(Localizadores *)object row:(NSUInteger)index {
    
    NSString * text=[NSString stringWithFormat:@"%@\r%@", object.Titulo,object.Endereco];
    cell.textLabel.text = text;
    cell.textLabel.numberOfLines = 0;
    cell.backgroundColor = index % 2
    ? [UIColor whiteColor]
    : [UIColor colorWithRed:0.94 green:0.98 blue:0.98 alpha:1.0];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.frame = CGRectMake(0, 0, 24, 24);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView = self.spinner;
    [self.spinner startAnimating];
    
    Localizadores *localizacao = (Localizadores *) [self.listaLocalizacoes objectAtIndex:indexPath.row];
   
    [self performSegueWithIdentifier:@"SegueDetails" sender:localizacao];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listaLocalizacoes count];
}

@end
