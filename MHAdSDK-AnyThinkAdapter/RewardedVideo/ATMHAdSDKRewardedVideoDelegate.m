//
//  ATMHAdSDKRewardedVideoDelegate.m
//  MHAdSDK-TopOnAdapter
//

#import "ATMHAdSDKRewardedVideoDelegate.h"

@implementation ATMHAdSDKRewardedVideoDelegate

- (void)rewardedVideoAdVideoDidLoad:(MHRewardedVideoAd *)rewardedVideoAd
                        placementID:(NSString *)placementID {
    NSLog(@"[ATMH] %@", NSStringFromSelector(_cmd));
    NSInteger ecpm = [rewardedVideoAd ecpm];
    NSLog(@"[ATMH] ecpm=%ld", (long)ecpm);

    NSString *priceStr = [NSString stringWithFormat:@"%ld", (long)ecpm];
    if ([priceStr doubleValue] < 0) { priceStr = @"0"; }

    NSDictionary *extra = @{
        ATAdSendC2SBidPriceKey: priceStr,
        ATAdSendC2SCurrencyTypeKey: @(ATBiddingCurrencyTypeCNYCents)
    };
    [self.adStatusBridge atOnRewardedAdLoadedExtra:extra];
}

- (void)rewardedVideoAdVideoLoadFailed:(MHRewardedVideoAd *)rewardedVideoAd
                           placementID:(NSString *)placementID
                             errorCode:(NSInteger)errorCode
                          errorMessage:(NSString *)errorMessage {
    NSLog(@"[ATMH] %@ errorCode=%ld msg=%@", NSStringFromSelector(_cmd), (long)errorCode, errorMessage);
    NSError *error = [NSError errorWithDomain:@"MHRewardedVideoAd"
                                         code:errorCode
                                     userInfo:@{NSLocalizedDescriptionKey: errorMessage ?: @"unknown"}];
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
}

- (void)rewardedVideoAdWillAppear:(MHRewardedVideoAd *)rewardedVideoAd
                      placementID:(NSString *)placementID {
    NSLog(@"[ATMH] %@", NSStringFromSelector(_cmd));
}

- (void)rewardedVideoAdDidAppear:(MHRewardedVideoAd *)rewardedVideoAd
                     placementID:(NSString *)placementID {
    NSLog(@"[ATMH] %@", NSStringFromSelector(_cmd));
    [self.adStatusBridge atOnAdShow:nil];
}

- (void)rewardedVideoAdDidDisappear:(MHRewardedVideoAd *)rewardedVideoAd
                        placementID:(NSString *)placementID {
    NSLog(@"[ATMH] %@", NSStringFromSelector(_cmd));
    [self.adStatusBridge atOnAdClosed:nil];
}

- (void)rewardedVideoAdDidClicked:(MHRewardedVideoAd *)rewardedVideoAd
                      placementID:(NSString *)placementID {
    NSLog(@"[ATMH] %@", NSStringFromSelector(_cmd));
    [self.adStatusBridge atOnAdClick:nil];
}

- (void)rewardedVideoAdVideoDidRewarded:(MHRewardedVideoAd *)rewardedVideoAd
                                 result:(BOOL)success
                            placementID:(NSString *)placementID {
    NSLog(@"[ATMH] %@ success=%d", NSStringFromSelector(_cmd), success);
    if (success) {
        [self.adStatusBridge atOnRewardedVideoAdRewarded];
    }
}

- (void)rewardedVideoAdVideoDidFinished:(MHRewardedVideoAd *)rewardedVideoAd
                            placementID:(NSString *)placementID {
    NSLog(@"[ATMH] %@", NSStringFromSelector(_cmd));
    [self.adStatusBridge atOnAdVideoEnd:nil];
}

@end
