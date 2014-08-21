//
//  BBUViewController.m
//  IAmUpload
//
//  Created by Boris Bügling on 08/21/2014.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <IAmUpload/BBUUploadsImUploader.h>

#import "BBUViewController.h"

@implementation BBUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];

    UIImage* doge = [UIImage imageNamed:@"doge.jpeg"];
    [[BBUUploadsImUploader sharedUploader] uploadImage:doge
                                     completionHandler:^(NSURL *uploadURL, NSError *error) {
                                         if (!uploadURL) {
                                             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
                                             [alert show];
                                             
                                             return;
                                         }

                                         [imageView setImageWithURL:uploadURL];
                                     }];
}

@end
