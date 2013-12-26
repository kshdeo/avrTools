//
//  MainViewController.h
//  avrtools
//
//  Created by Kshitij-Deo on 26/12/13.
//  Copyright (c) 2013 Buffer Labs Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITextFieldDelegate>
{
    NSArray *baudArray;
    NSArray *frequencyArray;
    BOOL up;
}


@property (strong, nonatomic) IBOutlet UISlider *clockFrequencySlider;
@property (strong, nonatomic) IBOutlet UITextField *clockTextBox;
@property (strong, nonatomic) IBOutlet UITextField *baudRateTextBox;
@property (strong, nonatomic) IBOutlet UISlider *baudRateSlider;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UITextView *outputView;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;


- (IBAction)moreButtonPressed:(id)sender;
- (IBAction)clockFrequencyChanged:(id)sender;
- (IBAction)baudRateChanged:(id)sender;
- (IBAction)rxEnabled:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;

@end