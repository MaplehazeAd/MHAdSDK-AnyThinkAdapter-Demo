//
//  ATMHAdSDKBaseAdapter.m
//  MHAdSDK-TopOnAdapter
//

#import "ATMHAdSDKBaseAdapter.h"
#import "ATMHAdSDKInitAdapter.h"

@implementation ATMHAdSDKBaseAdapter

- (Class)initializeClassName {
    return [ATMHAdSDKInitAdapter class];
}

@end
