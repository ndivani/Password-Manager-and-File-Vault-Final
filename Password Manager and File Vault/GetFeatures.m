//
//  GetFeatures.m
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 15/02/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import "GetFeatures.h"

@implementation GetFeatures

-( void )restClient: ( DBRestClient * )client loadedMetadata: ( DBMetadata * )metadata {
    NSLog( @"Metadata loaded." );
    if( metadata.isDirectory ) {
        // sFileNames_array = [ [ NSMutableArray alloc ] init ];
        for( DBMetadata *file in metadata.contents )
            NSLog( @"File found in dropbox directory: %@", file.filename ); // [ sFileNames_array addObject: file.filename ];

        // File directory information downloaded from dropbox, we can now copy it to a local file on device.
        // Load dropbox files into iPhone file system to access locally.
        // [ [ self restClient ] loadFile: [ NSString stringWithFormat: @"/%@", [ sFileNames_array objectAtIndex: 0 ] ] intoPath: [ self getFilePath: [ sFileNames_array objectAtIndex: 0 ] ] ];
    }
}

-( void )restClient: ( DBRestClient * )client loadMetadataFailedWithError: ( NSError * )error {
    NSLog( @"Error loading metadata: %@.", error );
}

// This function called when file downloaded from Dropbox from function fired in restClient: loadedMetadata.
-( void )restClient: ( DBRestClient * )client loadedFile: ( NSString * )localPath {
    NSArray *sFilePathAndName = [ [ NSArray alloc ] init ];
    sFilePathAndName = [ localPath componentsSeparatedByString: @"/" ];
    NSString *sFileName =  [ sFilePathAndName objectAtIndex: [ sFilePathAndName count ] - 1 ];
    NSLog( @"Loaded %@.", sFileName );
}

-( void )restClient: ( DBRestClient * )client loadFileFailedWithError: ( NSError * )error {
    NSLog( @"There was an error loading the file - %@", error );
}

-( NSString * )getFilePath: ( NSString * )sFileName {
    return [ [ [ NSBundle mainBundle ] resourcePath ] stringByAppendingPathComponent: sFileName ];
}

@end
