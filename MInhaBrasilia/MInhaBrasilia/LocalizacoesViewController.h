//
//  LocalizacoesViewController.h
//  MInhaBrasilia
//
//  Created by Leandro Vieira on 27/10/16.
//  Copyright © 2016 Leandro Vieira. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Localizadores.h"


@interface LocalizacoesViewController : UITableViewController

@property (nullable, nonatomic, copy) NSString * sTitulo;
@property (nullable, nonatomic, copy) NSMutableArray * listaLocalizacoes;


@end
