//
//  CameraViewController.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 1/10/15.
//  Copyright © 2015 Rex Jason Alobba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)useCamera:(id)sender;
- (IBAction)useCameraRoll:(id)sender;

@end
