//
//  ATMHAdSDKSplashDelegate.m
//  MHAdSDK-TopOnAdapter
//

#import "ATMHAdSDKSplashDelegate.h"

@implementation ATMHAdSDKSplashDelegate

- (void)splashAdDidLoad:(MHSplashAd *)splashAd placementID:(NSString *)placementID {
    NSLog(@"[ATMH] %@", NSStringFromSelector(_cmd));
    NSInteger ecpm = [splashAd ecpm];
    NSLog(@"[ATMH] ecpm=%ld", (long)ecpm);

    NSString *priceStr = [NSString stringWithFormat:@"%ld", (long)ecpm];
    if ([priceStr doubleValue] < 0) { priceStr = @"0"; }

    NSDictionary *extra = @{
        ATAdSendC2SBidPriceKey: priceStr,
        ATAdSendC2SCurrencyTypeKey: @(ATBiddingCurrencyTypeCNYCents)
    };
    [self.adStatusBridge atOnSplashAdLoadedExtra:extra];
}

- (void)splashAdLoadFailed:(MHSplashAd *)splashAd
                 errorCode:(NSInteger)errorCode
              errorMessage:(NSString *)errorMessage {
    NSLog(@"[ATMH] %@ errorCode=%ld msg=%@", NSStringFromSelector(_cmd), (long)errorCode, errorMessage);
    NSError *error = [NSError errorWithDomain:@"MHSplashAd"
                                         code:errorCode
                                     userInfo:@{NSLocalizedDescriptionKey: errorMessage ?: @"unknown"}];
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
}

- (void)splashAdDidAppear:(MHSplashAd *)splashAd placementID:(NSString *)placementID {
    NSLog(@"[ATMH] %@", NSStringFromSelector(_cmd));
    [self.adStatusBridge atOnAdShow:nil];
}

- (void)splashAdDidClicked:(MHSplashAd *)splashAd placementID:(NSString *)placementID {
    NSLog(@"[ATMH] %@", NSStringFromSelector(_cmd));
    [self.adStatusBridge atOnAdClick:nil];
}

- (void)splashAdDidDisappear:(MHSplashAd *)splashAd placementID:(NSString *)placementID {
    NSLog(@"[ATMH] %@", NSStringFromSelector(_cmd));
    [self.adStatusBridge atOnAdClosed:nil];
}

- (void)splashAdDidPresentFullScreen:(MHSplashAd *)splashAd placementID:(NSString *)placementID {
    NSLog(@"[ATMH] %@", NSStringFromSelector(_cmd));
}

- (void)splashAdDidDismissFullScreen:(MHSplashAd *)splashAd placementID:(NSString *)placementID {
    NSLog(@"[ATMH] %@", NSStringFromSelector(_cmd));
}

@end
