//
//  Favoritos+CoreDataProperties.m
//  MInhaBrasilia
//
//  Created by Leandro Vieira on 04/11/16.
//  Copyright © 2016 Leandro Vieira. All rights reserved.
//

#import "Favoritos+CoreDataProperties.h"


@implementation Favoritos (CoreDataProperties)

+ (NSFetchRequest<Favoritos *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"Favorito"];
}

@dynamic cidade;
@dynamic categoria;
@dynamic endereco;
@dynamic quadra;
@dynamic telefone;
@dynamic titulo;
@dynamic subtitulo;
@dynamic latitude;
@dynamic longitude;

@end
