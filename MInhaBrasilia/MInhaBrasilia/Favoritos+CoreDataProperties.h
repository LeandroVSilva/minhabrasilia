//
//  Favoritos+CoreDataProperties.h
//  MInhaBrasilia
//
//  Created by Leandro Vieira on 04/11/16.
//  Copyright © 2016 Leandro Vieira. All rights reserved.
//

#import "Favoritos.h"

@interface Favoritos (CoreDataProperties)

@property (nullable, nonatomic, copy) NSString *cidade;
@property (nullable, nonatomic, copy) NSString *categoria;
@property (nullable, nonatomic, copy) NSString *endereco;
@property (nullable, nonatomic, copy) NSString *quadra;
@property (nullable, nonatomic, copy) NSString *telefone;
@property (nullable, nonatomic, copy) NSString *titulo;
@property (nullable, nonatomic, copy) NSString *subtitulo;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@end
