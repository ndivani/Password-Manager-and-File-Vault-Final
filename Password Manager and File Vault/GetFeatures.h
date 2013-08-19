//
//  GetFeatures.h
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 15/02/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>

@interface GetFeatures : NSObject <DBRestClientDelegate>

-( void )restClient: ( DBRestClient * )client loadedMetadata: ( DBMetadata * )metadata;
-( NSString * )getFilePath: ( NSString * )sFileName;

@end
