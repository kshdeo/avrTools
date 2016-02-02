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
    int baudI;
    double baudF;
    BOOL uartDoubleSpeed;
}



@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoButton;

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UISlider *clockFrequencySlider;
@property (weak, nonatomic) IBOutlet UITextField *clockTextBox;
@property (weak, nonatomic) IBOutlet UITextField *baudRateTextBox;
@property (weak, nonatomic) IBOutlet UISlider *baudRateSlider;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UITextView *outputView;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UISwitch *rxEnable;
@property (weak, nonatomic) IBOutlet UISwitch *txEnable;
@property (weak, nonatomic) IBOutlet UISwitch *rxInterrupt;
@property (weak, nonatomic) IBOutlet UISwitch *txInterrupt;
@property (weak, nonatomic) IBOutlet UIView *outputContainerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSegmentControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *paritySegmentControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stopbitSegmentControl;


- (IBAction)moreButtonPressed:(id)sender;
- (IBAction)clockFrequencyChanged:(id)sender;
- (IBAction)baudRateChanged:(id)sender;
- (IBAction)rxEnabled:(id)sender;
- (IBAction)segmentControlChanged:(id)sender;
- (IBAction)infoPressed:(id)sender;

- (IBAction)shareButtonPressed:(id)sender;

@end
