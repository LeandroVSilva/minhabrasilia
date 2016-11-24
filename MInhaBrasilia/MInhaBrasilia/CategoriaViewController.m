//
//  CategoriaViewController.m
//  MInhaBrasilia
//
//  Created by Leandro Vieira on 26/10/16.
//  Copyright © 2016 Leandro Vieira. All rights reserved.
//

#import "CategoriaViewController.h"
#import "Localizadores.h"
#import "LocalizacoesViewController.h"

@interface CategoriaViewController ()

@property (nonatomic, copy) NSArray *categorias;
@property (nonatomic, copy) NSMutableArray *loc;
@end

@implementation CategoriaViewController
NSString *alerta;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * sCidade = @"Categoria";
    
    if(self.localizador) {
        sCidade = [sCidade stringByAppendingString: self.localizador.Cidade];
    }
    
    NSURL *plistURL = [[NSBundle mainBundle] URLForResource:sCidade withExtension:@"plist"];
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfURL:plistURL];
    self.categorias = plist[@"categorias"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SegueLocalizacoes"]) {
        
        if([self.loc count] > 0)
        {
            LocalizacoesViewController *locView = [segue destinationViewController];
            locView.listaLocalizacoes = [[NSMutableArray alloc]init];
            locView.listaLocalizacoes = self.loc;
        }
    }
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *categoria = self.categorias[indexPath.row];
    cell.textLabel.text = categoria;
    cell.backgroundColor = indexPath.row % 2
    ? [UIColor whiteColor]
    : [UIColor colorWithRed:0.94 green:0.98 blue:0.98 alpha:1.0];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    [self httpPostLocalizacoes:(selectedCell)];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categorias.count;
}

-(void) httpPostLocalizacoes: (UITableViewCell *)selectedCell
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0, 0, 24, 24);
    UITableViewCell *cell = selectedCell;
    cell.accessoryView = spinner;
    [spinner startAnimating];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:@"http://minhabrasiliaapp-com.umbler.net/api/cidade/localizacoes"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *params = [NSString stringWithFormat:@"%@%@%@%@", @"cidade=", [self.localizador.Cidade uppercaseString] , @"&Categoria=", selectedCell.textLabel.text];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableArray *liveSales = [[NSMutableArray alloc] init];
    
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           
                                                           if(!error)
                                                           {
                                                               NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                               
                                                               if ([responseDict isKindOfClass:[NSDictionary class]]){
                                                                   
                                                                   NSArray *listaLoc = responseDict[@"data"];
                                                                   
                                                                   if ([listaLoc isKindOfClass:[NSArray class]]){
                                                                       
                                                                       for (NSDictionary *dictionary in listaLoc) {
                                                                           
                                                                           Localizadores *loc = [[Localizadores alloc] init];
                                                                           
                                                                           loc.Categoria =[dictionary objectForKey:@"categoria"];
                                                                           
                                                                           loc.Titulo =[dictionary objectForKey:@"titulo"];
                                                                           
                                                                           if([self.localizador.Cidade isEqualToString:@"AsaNorte" ])
                                                                           {
                                                                               loc.Cidade = @"Asa Norte";
                                                                           }else{
                                                                               loc.Cidade = @"Asa Sul";
                                                                           }
                                                                           
                                                                           loc.Subtitulo =[dictionary objectForKey:@"subtitulo"];
                                                                           
                                                                           loc.Endereco =[dictionary objectForKey:@"endereco"];
                                                                           
                                                                           loc.Localizacao =[dictionary objectForKey:@"localizacao"];
                                                                           
                                                                           loc.Quadra =[dictionary objectForKey:@"quadra"];
                                                                           
                                                                           loc.Telefone =[dictionary objectForKey:@"telefone"];
                                                                           
                                                                           loc.Longitude =[dictionary objectForKey:@"logintude"];
                                                                           
                                                                           loc.Latitude =[dictionary objectForKey:@"latitude"];
                                                                           
                                                                           [liveSales addObject:loc];
                                                                       }
                                                                   }
                                                               }
                                                               
                                                               if([liveSales count] > 0)
                                                               {
                                                                   self.loc = [[NSMutableArray alloc] init];
                                                                   
                                                                   self.loc = liveSales;
                                                                   
                                                                   [spinner stopAnimating];
                                                                   
                                                                   [self performSegueWithIdentifier:@"SegueLocalizacoes" sender: selectedCell];
                                                               }else{
                                                                   [spinner stopAnimating];
                                                                   alerta = [[NSString alloc] initWithFormat:@"Não foi encontrado nenhum item para sua pesquisa"];
                                                                   UIAlertView *myAlert = [[UIAlertView alloc]
                                                                                           initWithTitle:@"Mensagem de alerta."
                                                                                           message:alerta
                                                                                           delegate:nil
                                                                                           cancelButtonTitle:@"OK"
                                                                                           otherButtonTitles:nil];
                                                                   [myAlert show];
                                                               }
                                                           }
                                                           else
                                                           {
                                                               [spinner stopAnimating];
                                                               alerta = [[NSString alloc] initWithFormat:@"Não foi possível conectar ao serviço. Verifique sua internet "];
                                                               UIAlertView *myAlert = [[UIAlertView alloc]
                                                                                       initWithTitle:@"Mensagem de erro."
                                                                                       message:alerta
                                                                                       delegate:nil
                                                                                       cancelButtonTitle:@"OK"
                                                                                       otherButtonTitles:nil];
                                                               [myAlert show];
                                                               
                                                               
                                                           }
                                                           
                                                       }];
    
    [dataTask resume];
    
}


@end
