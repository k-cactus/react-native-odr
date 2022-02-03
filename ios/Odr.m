#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(Odr, NSObject)

    RCT_EXTERN_METHOD(download:(NSDictionary *)options
                      withResolver:(RCTPromiseResolveBlock)resolve
                      withRejecter:(RCTPromiseRejectBlock)reject)

@end
