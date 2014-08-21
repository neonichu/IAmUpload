//
//  BBUUploadsImUploader.m
//  Pods
//
//  Created by Boris Bügling on 21/08/14.
//
//

#import <AFNetworking/AFNetworking.h>

#import "BBUUploadsImUploader.h"

@interface BBUUploadsImUploader ()

@property (nonatomic) AFHTTPRequestOperationManager* manager;

@end

#pragma mark -

@implementation BBUUploadsImUploader

+(instancetype)sharedUploader {
    static dispatch_once_t once;
    static BBUUploadsImUploader *sharedUploader;
    dispatch_once(&once, ^ {
        sharedUploader = [BBUUploadsImUploader new];
    });
    return sharedUploader;
}

#pragma mark -

-(id)init {
    self = [super init];
    if (self) {
        NSURL* url = [NSURL URLWithString:@"http://uploads.im"];
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    return self;
}

-(void)uploadFileWithData:(NSData *)data completionHandler:(BBUFileUploadHandler)handler {
    NSParameterAssert(data);
    NSParameterAssert(handler);

    [self.manager POST:@"api" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data
                                    name:@"upload"
                                fileName:@"file.jpg"
                                mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSURL* uploadUrl = [NSURL URLWithString:responseObject[@"data"][@"img_url"]];
        handler(uploadUrl, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, error);
    }];
}

-(void)uploadImage:(UIImage *)image completionHandler:(BBUFileUploadHandler)handler {
    NSData* data = UIImageJPEGRepresentation(image, 1.0);
    [self uploadFileWithData:data completionHandler:handler];
}

@end
