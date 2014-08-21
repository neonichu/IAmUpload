//
//  BBUUploadsImUploader.h
//  Pods
//
//  Created by Boris Bügling on 21/08/14.
//
//

#import <IAmUpload/BBUFileUpload.h>
#import <Foundation/Foundation.h>

@interface BBUUploadsImUploader : NSObject <BBUFileUpload>

+(instancetype)sharedUploader;

@end
