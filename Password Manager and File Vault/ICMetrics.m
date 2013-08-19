//
//  ICMetrics.m
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 13/02/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import "ICMetrics.h"
#import "Login.h"

@implementation ICMetrics
@synthesize sPrivateKey;

-( id )initICMetricsWithRootViewController: ( Login * )loginViewController {
    self = [ super init ];
    if( self ) {
        /*
        // Has to be in this function as ViewWillAppear can't load view from controller as view(modal) not loaded (view is not in heirarchy warning).
        if( ![ [ DBSession sharedSession ] isLinked ] ) {
            [ [ DBSession sharedSession ] linkFromController: loginViewController ];
        }

        getFeatures = [ [ GetFeatures alloc ] init ];
        if( !restClient ) {
            restClient = [ [ DBRestClient alloc ] initWithSession: [ DBSession sharedSession ] ];
            restClient.delegate = getFeatures;
        }

        [ restClient loadMetadata: @"/" ];
         */
    }

    return self;
}

-( void )generateKey {
    [ self _getFeatureValues ];
}

-( void )_getFeatureValues {
    //
}

-( void )_applyNormalisedMappings {
    //
}

-( void )_combineNormalisedValues {
    //
}

-( void )_createSecretShares {
    //
}

@end
