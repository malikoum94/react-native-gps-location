
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <CoreLocation/CoreLocation.h>

@interface RNGpsLocation : RCTEventEmitter <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager * GPS;
@property (nonatomic) CLLocationDistance distance;
@property (nonatomic) NSTimeInterval timeout;
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic) CLLocationCoordinate2D home;
@property (nonatomic) CLCircularRegion * region;
@property (nonatomic) CLLocationAccuracy accuracy;
@end
  
