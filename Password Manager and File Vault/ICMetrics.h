//
//  ICMetrics.h
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 13/02/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetFeatures.h"
@class Login;

@interface ICMetrics : NSObject {
    DBRestClient *restClient;
    GetFeatures *getFeatures;

    NSMutableDictionary *normalisationMappings_dictionary;
}

@property( nonatomic, retain )NSString *sPrivateKey;

-( id )initICMetricsWithRootViewController: ( Login * )loginViewController;
-( void )generateKey;

@end
