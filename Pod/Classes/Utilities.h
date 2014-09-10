//
//  Utilities.h
//  Pods
//
//  Created by Boris Bügling on 09/09/14.
//
//

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

NSData* bbu_convert_image_to_data(UIImage* image);

#else

#import <Cocoa/Cocoa.h>

NSData* bbu_convert_image_to_data(NSImage* image);

#endif
