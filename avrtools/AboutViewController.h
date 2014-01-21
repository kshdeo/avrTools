//
//  AboutViewController.h
//  avrtools
//
//  Created by Kshitij-Deo on 01/01/14.
//  Copyright (c) 2014 Buffer Labs Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AboutViewController : UIViewController<MFMailComposeViewControllerDelegate>
{

}

- (IBAction)rateAppClicked:(id)sender;
- (IBAction)feedbackPressed:(id)sender;

@end
