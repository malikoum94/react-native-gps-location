
#import "RNGpsLocation.h"
@interface RNGpsLocation () <CLLocationManagerDelegate>
@end
@implementation RNGpsLocation 
RCT_EXPORT_MODULE()
- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.GPS = [[CLLocationManager alloc] init];
        self.GPS.delegate = self;
        self.distance = 100;
        self.timeout = 100;
        self.accuracy = kCLLocationAccuracyHundredMeters;
        self.longitude = 48.8963207;
        self.latitude = 2.3186806;
        self.home = CLLocationCoordinate2DMake(self.longitude, self.latitude);
        self.region = [[CLCircularRegion alloc] initWithCenter:self.home radius:self.distance identifier:@"42"];
        self.GPS.activityType = CLActivityTypeOther;
        self.GPS.allowsBackgroundLocationUpdates = true;
        [self.GPS allowDeferredLocationUpdatesUntilTraveled:self.distance timeout:self.timeout];
        self.GPS.distanceFilter = self.distance;
        self.GPS.desiredAccuracy = self.accuracy;
        NSLog(@"%@", self.region);
    }
    return self;
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"Location", @"error", @"enter", @"exit"];
}
RCT_EXPORT_METHOD(askAuthorization)
{
    [self.GPS requestAlwaysAuthorization];
}
RCT_EXPORT_METHOD(getLocation)
{
    [self.GPS requestLocation];
}
RCT_EXPORT_METHOD(startMonitor)
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        if ([CLLocationManager isMonitoringAvailableForClass: CLCircularRegion.self]) {
            self.region.notifyOnExit = true;
            self.region.notifyOnEntry = true;
            [self.GPS startMonitoringForRegion:self.region];
            NSLog(@"start monitoring");
        } else {
            NSLog(@"can't monitoring");
        }
    } else {
        NSLog(@"no authorization");
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"location");
    NSLog(@"%@", locations);
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"fail get");
    NSLog(@"%@", error);
}
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if (region != nil) {
        NSString * indentifier = region.identifier;
        NSLog(@"enter");
        NSLog(@"%@", region);
    } else {
        NSLog(@"bad region");
    }
}
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if (region != nil) {
        NSString * indentifier = region.identifier;
        NSLog(@"exit");
        NSLog(@"%@", region);
    } else {
        NSLog(@"bad region");
    }
}
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"monitoring error");
    NSLog(@"%@", region);
    NSLog(@"%@", error);
}

@end
  
