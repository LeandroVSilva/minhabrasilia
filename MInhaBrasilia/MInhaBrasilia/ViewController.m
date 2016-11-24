//
//  ViewController.m
//  MInhaBrasilia
//
//  Created by Leandro Vieira on 26/10/16.
//  Copyright © 2016 Leandro Vieira. All rights reserved.
//

#import "ViewController.h"
#import "Localizadores.h"
#import "Favoritos.h"
#import "CategoriaViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MeusFavoritosViewController.h"

@interface ViewController () <CLLocationManagerDelegate>

@property CLLocationManager * locationManager;
@property NSString *alerta;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            self.locationManager.distanceFilter = 100;
            [self.locationManager startUpdatingLocation];
            break;
        default:
            break;
        case kCLAuthorizationStatusDenied:
            _alerta = [[NSString alloc] initWithFormat:@"Para reativá-lo, acesse Configurações e ative o Serviço de Localização deste aplicativo. "];
            UIAlertView *myAlert = [[UIAlertView alloc]
                                    initWithTitle:@"Permissão de aplicativo negada."
                                    message:_alerta
                                    delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
            [myAlert show];
            break;
    }
    
}



#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SegueAsaNorte"]) {
        
        Localizadores *localizador = [[Localizadores alloc]init];
        localizador.Cidade = @"AsaNorte";
        [segue.destinationViewController setLocalizador:localizador];
        
    }else if ([[segue identifier] isEqualToString:@"SegueAsaSul"]) {
        
        Localizadores *localizador = [[Localizadores alloc]init];
        localizador.Cidade = @"AsaSul";
        [segue.destinationViewController setLocalizador:localizador];
        
    }
    
}

@end
