//
//  AboutViewController.m
//  avrtools
//
//  Created by Kshitij-Deo on 01/01/14.
//  Copyright (c) 2014 Buffer Labs Pvt. Ltd. All rights reserved.
//

#import "AboutViewController.h"
#import <MessageUI/MessageUI.h>

#define APP_ID @"803440421"
    //#define APP_ID @"654625246"


@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)rateAppClicked:(id)sender
{
    NSString *iTunesLink = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",APP_ID ];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)feedbackPressed:(id)sender
{
    if ( [MFMailComposeViewController canSendMail] )
    {
        MFMailComposeViewController * mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        [mailComposer setToRecipients:[NSArray arrayWithObject:@"contact@bufferlabs.in"]];
        [mailComposer setSubject:@"AVRTools app feedback"];
        [self presentViewController:mailComposer animated:YES completion:nil];
    }
}

@end
