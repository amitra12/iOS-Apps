

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PlotViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSString *addressString;
@end
