
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

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"location", @"error", @"enter", @"exit", @"visit"];
}
RCT_EXPORT_METHOD(askAlwaysAuthorization)
{
    [self.GPS requestAlwaysAuthorization];
}
RCT_EXPORT_METHOD(askInUseAuthorization)
{
    [self.GPS requestWhenInUseAuthorization];
}
RCT_REMAP_METHOD(getAuthorization, getAuthorizationWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusDenied:
            resolve(@"denied");
            break;
        case kCLAuthorizationStatusRestricted:
            resolve(@"restricted");
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            resolve(@"always");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            resolve(@"inUse");
            break;
        default:
            resolve(@"undefined");
            break;
    }
}
RCT_EXPORT_METHOD(getLocation)
{
    [self.GPS requestLocation];
}
RCT_EXPORT_METHOD(startMonitor:(NSNumber*)latitude longitude:(NSNumber*)longitude name:(NSString*)name)
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        if ([CLLocationManager isMonitoringAvailableForClass: CLCircularRegion.self]) {
            double longitudeTmp = [RCTConvert double: longitude];
            double latitudeTmp = [RCTConvert double: latitude];
            self.latitude = latitudeTmp;
            self.longitude = longitudeTmp;
            self.home = CLLocationCoordinate2DMake(self.latitude, self.longitude);
            self.region = [[CLCircularRegion alloc] initWithCenter:self.home radius:self.distance identifier:name];
            self.region.notifyOnExit = true;
            self.region.notifyOnEntry = true;
            [self.GPS startMonitoringForRegion:self.region];
        } else {
            [self sendEventWithName:@"error" body:@{@"error": @"can't monitoring"}];
        }
    } else {
        [self sendEventWithName:@"error" body:@{@"error": @"no authorization"}];
    }
}
RCT_EXPORT_METHOD(stopMonitor)
{
    if (self.region) {
        [self.GPS stopMonitoringForRegion:self.region];
    } else {
        [self sendEventWithName:@"error" body:@{@"error": @"no region"}];
    }
}
RCT_EXPORT_METHOD(allowBackgroundLocation:(NSNumber*)distance timeout:(NSNumber*)timeout)
{
    double distanceTmp = [RCTConvert double: distance];
    double timeoutTmp = [RCTConvert double: timeout];
    self.distance = distanceTmp;
    self.timeout = timeoutTmp;
    self.GPS.distanceFilter = self.distance;
    self.GPS.allowsBackgroundLocationUpdates = true;
    [self.GPS allowDeferredLocationUpdatesUntilTraveled:self.distance timeout:self.timeout];
    
}
RCT_EXPORT_METHOD(disallowBackgroundLocation)
{
    self.GPS.allowsBackgroundLocationUpdates = false;
    [self.GPS disallowDeferredLocationUpdates];
}
RCT_EXPORT_METHOD(updateLocation)
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        [self.GPS startUpdatingLocation];
    } else {
        [self sendEventWithName:@"error" body:@{@"error": @"can't update"}];
    }
}
RCT_EXPORT_METHOD(stopUpdateLocation)
{
    [self.GPS stopUpdatingLocation];
}
RCT_EXPORT_METHOD(startVisit)
{
    [self.GPS startMonitoringVisits];
}
RCT_EXPORT_METHOD(stopVisit)
{
    [self.GPS stopMonitoringVisits];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.GPS = [[CLLocationManager alloc] init];
        self.GPS.delegate = self;
        self.accuracy = kCLLocationAccuracyNearestTenMeters;
        self.GPS.activityType = CLActivityTypeOther;
        self.GPS.desiredAccuracy = self.accuracy;
    }
    return self;
}
- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit
{
    NSDictionary *visitEvent = @{
                                    @"latitude": @(visit.coordinate.latitude),
                                    @"longitude": @(visit.coordinate.longitude),
                                    @"accuracy": @(visit.horizontalAccuracy),
                                    @"arrival": @(lroundf([visit.arrivalDate timeIntervalSince1970] * 1000)), // in ms
                                    @"departure": @(lroundf([visit.departureDate timeIntervalSince1970] * 1000)) // in ms
                                    };
    [self sendEventWithName:@"visit" body:@{@"visit": visitEvent}];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    NSDictionary *locationEvent = @{
                                    @"latitude": @(location.coordinate.latitude),
                                    @"longitude": @(location.coordinate.longitude),
                                    @"altitude": @(location.altitude),
                                    @"accuracy": @(location.horizontalAccuracy),
                                    @"altitudeAccuracy": @(location.verticalAccuracy),
                                    @"course": @(location.course),
                                    @"speed": @(location.speed),
                                    @"timestamp": @(lroundf([location.timestamp timeIntervalSince1970] * 1000)) // in ms
                                    };
    [self sendEventWithName:@"location" body:@{@"location": locationEvent}];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSDictionary *errorEvent = @{
                                    @"code": @(error.code),
                                    @"domain": error.domain,
                                    @"userInfo": error.userInfo,
                                    @"localizedDescription": error.localizedDescription,
                                    @"localizedFailureReason": error.localizedFailureReason
                                    };
    [self sendEventWithName:@"error" body:@{@"error": errorEvent}];
}
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if (region != nil) {
        NSString * identifier = region.identifier;
        [self sendEventWithName:@"enter" body:@{@"region": region, @"identifier": identifier}];
    } else {
        [self sendEventWithName:@"error" body:@{@"error": @"bad region"}];
    }
}
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if (region != nil) {
        NSString * identifier = region.identifier;
        [self sendEventWithName:@"exit" body:@{@"region": region, @"identifier": identifier}];
    } else {
        [self sendEventWithName:@"error" body:@{@"error": @"bad region"}];
    }
}
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSDictionary *errorEvent = @{
                                 @"code": @(error.code),
                                 @"domain": error.domain,
                                 @"userInfo": error.userInfo,
                                 @"localizedDescription": error.localizedDescription,
                                 @"localizedFailureReason": error.localizedFailureReason
                                 };
    [self sendEventWithName:@"error" body:@{@"error": errorEvent, @"region": region}];
}

@end
  
