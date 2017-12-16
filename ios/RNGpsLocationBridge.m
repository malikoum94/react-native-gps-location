
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(RNGpsLocation, RCTEventEmitter)

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXTERN_METHOD(askAuthorization)

RCT_EXTERN_METHOD(startMonitor)

RCT_EXTERN_METHOD(getLocation)

@end
  
