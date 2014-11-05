//
//  BBUS3Uploader.h
//  image-uploader
//
//  Created by Boris Bügling on 03/09/14.
//  Copyright (c) 2014 Contentful GmbH. All rights reserved.
//

#import <IAmUpload/BBUFileUpload.h>

@interface BBUS3Uploader : NSObject <BBUFileUpload>

+(NSString*)mimeTypeForFileExtension:(NSString*)fileExtension;

@property (nonatomic, copy) NSString* path;

-(instancetype)initWithBucket:(NSString*)bucket key:(NSString*)key secret:(NSString*)secret;

@end
