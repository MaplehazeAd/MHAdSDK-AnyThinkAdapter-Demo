//
//  ATMHAdSDKSplashDelegate.h
//  MHAdSDK-TopOnAdapter
//

#import <AnyThinkSDK/AnyThinkSDK.h>
#import <MHAdSDK/MHSplashAd.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATMHAdSDKSplashDelegate : NSObject <MHSplashAdDelegete>

@property (nonatomic, strong) ATSplashAdStatusBridge *adStatusBridge;

@end

NS_ASSUME_NONNULL_END
