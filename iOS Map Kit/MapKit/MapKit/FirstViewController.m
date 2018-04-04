

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapRecognizer];
    
}
- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)placemarker:(id)sender {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    NSString *addressString =
    [NSString stringWithFormat:
     @"%@ %@ %@ %@",
     _address.text,
     _city.text,
     _state.text,
     _zip.text];
    
    [geocoder geocodeAddressString:addressString
                 completionHandler:^(NSArray *placemarks,
                                     NSError *error) {
                     
                     if (error) {
                         NSLog(@"Geocode failed with error: %@", error);
                         return;
                     }
                     
                     if (placemarks && placemarks.count > 0)
                     {
                         CLPlacemark *placemark = placemarks[0];
                         
                         CLLocation *location = placemark.location;
                         _coordStart = location.coordinate;
                         
                         NSString *endString =
                         [NSString stringWithFormat:
                          @"%@ %@ %@ %@",
                          _address2.text,
                          _city2.text,
                          _state2.text,
                          _zip2.text];
                         [geocoder geocodeAddressString:endString completionHandler:^(NSArray *placemarks, NSError *error) {
                             if (placemarks.count == 0) {
                                 NSLog(@"geocode end failed with error %@", error);
                                 return;
                             }
                             CLPlacemark *placemarkEnd = placemarks[0];
                             _coordEnd = placemarkEnd.location.coordinate;
                             [self showMap1];
                         }];
                         
                     }
                 }];
}

-(void)showMap1
{
    NSDictionary *addressStart = @{
                                   (NSString *)kABPersonAddressStreetKey: _address.text,
                                   (NSString *)kABPersonAddressCityKey: _city.text,
                                   (NSString *)kABPersonAddressStateKey: _state.text,
                                   (NSString *)kABPersonAddressZIPKey: _zip.text
                                   };
    NSDictionary *addrEnd = @{(NSString *)kABPersonAddressStreetKey: _address2.text,
                              (NSString *)kABPersonAddressCityKey: _city2.text,
                              (NSString *)kABPersonAddressStateKey: _state2.text,
                              (NSString *)kABPersonAddressZIPKey: _zip2.text
                              };
    
    MKPlacemark *placeStart = [[MKPlacemark alloc]
                               initWithCoordinate:_coordStart
                               addressDictionary:addressStart];
    MKPlacemark *placeEnd = [[MKPlacemark alloc]
                             initWithCoordinate:_coordEnd
                             addressDictionary:addrEnd];
    MKMapItem *mapItemStart = [[MKMapItem alloc]initWithPlacemark:placeStart];
    MKMapItem *mapItemEnd = [[MKMapItem alloc]initWithPlacemark:placeEnd];
    
    //  NSDictionary *options = @{
    
    //  };
    
    [MKMapItem openMapsWithItems:@[mapItemStart, mapItemEnd] launchOptions:0];
    
    //    [mapItem openInMapsWithLaunchOptions:options];
}

@end
