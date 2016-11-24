//
//  DetailsViewController.m
//  MInhaBrasilia
//
//  Created by Leandro Vieira on 01/11/16.
//  Copyright © 2016 Leandro Vieira. All rights reserved.
//

#import "DetailsViewController.h"
#import "Localizadores.h"
#import "UIViewController+CoreData.h"
@import MapKit;

@interface DetailsViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *sTitulo;
@property (weak, nonatomic) IBOutlet UILabel *sSubtitulo;

@property (weak, nonatomic) IBOutlet UILabel *sEndereco;

@property (weak, nonatomic) IBOutlet UILabel *sCidade;

@property (weak, nonatomic) IBOutlet UILabel *sQuadra;

@property (weak, nonatomic) IBOutlet MKMapView *map;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *detailsActivityView;

@property NSMutableArray<MKPointAnnotation *> * points;

@property MKPolyline * line;

@end

@implementation DetailsViewController

MKRoute *routeDetails;
CLPlacemark *thePlacemark;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.map setDelegate:self];
    self.map.showsUserLocation = YES;
    
    if(self.localizacao || self.favorito)
    {
        [self configureView];
        [self inicializarMap];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView {
    _sTitulo.text = self.localizacao ? self.localizacao.Titulo : self.favorito.titulo;
    _sSubtitulo.text = self.localizacao ? self.localizacao.Subtitulo: self.favorito.subtitulo;
    _sEndereco.text = self.localizacao ? self.localizacao.Endereco: self.favorito.endereco;
    _sCidade.text = self.localizacao ? self.localizacao.Cidade: self.favorito.cidade;
    _sQuadra.text = self.localizacao ? self.localizacao.Quadra: self.favorito.quadra;
}

- (void)inicializarMap{
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.localizacao ? [self.localizacao.Latitude doubleValue] : self.favorito.latitude,
                                                                   self.localizacao ? [self.localizacao.Longitude doubleValue] : self.favorito.longitude);
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate;
    point.title =  self.localizacao ? self.localizacao.Titulo : self.favorito.titulo;
    point.subtitle = self.localizacao ? self.localizacao.Subtitulo: self.favorito.subtitulo;
    
    [self.map addAnnotation:point];
    MKCoordinateRegion mapRegion;
    mapRegion.center = coordinate;
    mapRegion.span.latitudeDelta = 0.04;
    mapRegion.span.longitudeDelta = 0.04;
    
    [self.map setRegion:mapRegion animated: YES];
    [self.map regionThatFits:mapRegion];
    [self.map selectAnnotation:point animated:YES];
    
}
- (IBAction)criarRota:(id)sender {
    [self rota];
}


- (void)routeButtonPressed {
    
    CLLocationCoordinate2D destinoCoordinate =  CLLocationCoordinate2DMake(self.localizacao ? [self.localizacao.Latitude doubleValue] : self.favorito.latitude,
                                                                           self.localizacao ? [self.localizacao.Longitude doubleValue] : self.favorito.longitude);
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = destinoCoordinate;
    point.title =  self.localizacao ? self.localizacao.Titulo : self.favorito.titulo;
    point.subtitle = self.localizacao ? self.localizacao.Subtitulo: self.favorito.subtitulo;
    [self.map addAnnotation:point];
    
    MKPlacemark *destinoMark = [[MKPlacemark alloc] initWithCoordinate:destinoCoordinate addressDictionary:nil];
    
    
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:destinoMark];
    [directionsRequest setSource:[MKMapItem mapItemForCurrentLocation]];
    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:placemark]];
    directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            routeDetails = response.routes.lastObject;
            [self.map addOverlay:routeDetails.polyline];
        }
    }];
}


- (void) rota
{
    [_detailsActivityView startAnimating];
    CLLocationCoordinate2D destinoCoordinate = CLLocationCoordinate2DMake(self.localizacao ? [self.localizacao.Latitude doubleValue] : self.favorito.latitude,
                                                                          self.localizacao ? [self.localizacao.Longitude doubleValue] : self.favorito.longitude);
    
    
    
    MKPlacemark *destinoMark = [[MKPlacemark alloc] initWithCoordinate:destinoCoordinate addressDictionary:nil];
    MKMapItem *destintoItem = [[MKMapItem alloc] initWithPlacemark:destinoMark];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:[MKMapItem mapItemForCurrentLocation]];
    request.transportType = MKDirectionsTransportTypeAutomobile;
    request.transportType = MKDirectionsTransportTypeAutomobile;
    request.destination = destintoItem;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    __block typeof(self) weakSelf = self;
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *directionsResponse, NSError *error) {
         
         if (error) {
             NSLog(@"Error is %@",error);
         } else {
             [weakSelf carregarDirections:directionsResponse];
         }
     }];
    
    
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = destinoCoordinate;
    point.title =  self.localizacao ? self.localizacao.Titulo : self.favorito.titulo;
    point.subtitle = self.localizacao ? self.localizacao.Subtitulo: self.favorito.subtitulo;
    
    [self.map addAnnotation:point];
    
}

- (void)carregarDirections:(MKDirectionsResponse *)directionsResponse
{
    MKRoute *mkRoute = [directionsResponse.routes firstObject];
    [self.map addOverlay:mkRoute.polyline level:MKOverlayLevelAboveRoads];
    
    NSMutableArray *arrayStep = [NSMutableArray arrayWithCapacity:[mkRoute.steps count]];
    for (MKRouteStep *_step in mkRoute.steps) {
        [arrayStep addObject:[_step instructions]];
    }
    
    MKMapRect mapRec = MKMapRectNull;
    for (int points = 0; points < sizeof(mkRoute.polyline.points); points++) {
        MKMapPoint mapPoint = mkRoute.polyline.points[points];
        MKMapRect pointRect = MKMapRectMake(mapPoint.x, mapPoint.y, 0, 0);
        if (MKMapRectIsNull(mapRec)) {
            mapRec = pointRect;
        } else {
            mapRec = MKMapRectUnion(mapRec, pointRect);
        }
    }
    mapRec = MKMapRectInset(mapRec, -3000, -3000);
    [self.map setVisibleMapRect:mapRec edgePadding:UIEdgeInsetsMake(10, 10, 10, 10) animated:YES];
    [_detailsActivityView stopAnimating];
}


- (IBAction)salvar:(id)sender {
    
    if(!self.favorito) {
        self.favorito = [NSEntityDescription insertNewObjectForEntityForName:@"Favorito" inManagedObjectContext:self.managedObjectContext];
        
        self.favorito.cidade = self.localizacao.Cidade;
        self.favorito.quadra = self.localizacao.Quadra;
        self.favorito.titulo = self.localizacao.Titulo;
        self.favorito.subtitulo = self.localizacao.Subtitulo;
        self.favorito.endereco = self.localizacao.Endereco;
        self.favorito.telefone = self.localizacao.Telefone;
        self.favorito.latitude = [self.localizacao.Latitude doubleValue];
        self.favorito.longitude = [self.localizacao.Longitude doubleValue];
        self.favorito.categoria = self.localizacao.Categoria;
        
        NSError * error;
        [self.managedObjectContext save:&error];
        if(error){
            NSLog(@"Error %@",error);
        }
    }else{
        self.favorito = nil;
        [self performSegueWithIdentifier:@"unwindToFavoritos" sender:sender];
    }
}


#pragma mark - MKMapViewDelegate

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    return nil;
    
}




-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    MKPointAnnotation * point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    [_points addObject:point];
    
    [mapView removeOverlay:_line];
    
    CLLocationCoordinate2D * coords = malloc([_points count] * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < [_points count]; i++) {
        coords[i] = _points[i].coordinate;
    }
    
    _line = [MKPolyline polylineWithCoordinates:coords count:[_points count]];
    
    free(coords);
    
    [mapView addOverlay:_line];
    
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer * renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        [renderer setLineWidth:4];
        [renderer setStrokeColor:[UIColor redColor]];
        
        return renderer;
    }
    
    return nil;
}

@end
