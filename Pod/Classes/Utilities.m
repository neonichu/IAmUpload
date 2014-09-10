//
//  Utilities.m
//  Pods
//
//  Created by Boris Bügling on 09/09/14.
//
//

#import "Utilities.h"

#if TARGET_OS_IPHONE

NSData* bbu_convert_image_to_data(UIImage* image) {
    return UIImageJPEGRepresentation(image, 1.0);
}

#else

NSData* bbu_convert_image_to_data(NSImage* image) {
    NSData *data = [image TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:data];
    NSDictionary *imageProperties = @{ NSImageCompressionFactor: @(1.0) };
    return [imageRep representationUsingType:NSJPEGFileType properties:imageProperties];
}

#endif
