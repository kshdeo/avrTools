//
//  MainViewController.m
//  avrtools
//
//  Created by Kshitij-Deo on 26/12/13.
//  Copyright (c) 2013 Buffer Labs Pvt. Ltd. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    up=TRUE;
    
    self.clockTextBox.delegate=self;
    self.baudRateTextBox.delegate=self;
    
    frequencyArray=[NSArray arrayWithObjects:@"1",@"1.8432",@"2",@"3.6864",@"4",@"7.3728",@"8",@"11.0592",@"12",@"14.7456",@"16",@"18.432",@"20", nil];
    self.clockFrequencySlider.maximumValue=[frequencyArray count];
    
    baudArray=[NSArray arrayWithObjects:@"1200",@"2400",@"4800",@"9600",@"14400",@"19200",@"28800",@"38400",@"57600",@"62500",@"76800",@"115200",@"125000",@"230400",@"250000",@"460800",@"500000",@"921000",@"1000000",@"1152000",@"1250000",@"1843200",@"2000000",@"2304000",@"2500000" ,nil];
    self.baudRateSlider.maximumValue=[baudArray count]-1;
    
    UIImage *toolTipsImage = [UIImage imageNamed:@"textbox_bg.png"];
    self.backgroundImage.image = [toolTipsImage resizableImageWithCapInsets:UIEdgeInsetsMake(12.0f, 12.0f, 12.0f, 12.0f)];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)moreButtonPressed:(id)sender
{
    if (up)
    {
        [UIView animateWithDuration:2.0
                         animations:^{
                             self.outputView.frame=CGRectMake(0, 480, 320, 300);
                             self.moreButton.frame=CGRectMake(290, 484, 22, 22);
                         }];
        up=FALSE;
    }
    else
    {
        up=TRUE;
        
        [UIView animateWithDuration:2.0
                         animations:^{
                             self.outputView.frame=CGRectMake(0, 306, 320, 300);
                             self.moreButton.frame=CGRectMake(290, 310, 22, 22);
                         }];
    }
}

- (IBAction)clockFrequencyChanged:(id)sender
{
    int stepSize =1;
    float newStep = roundf((self.clockFrequencySlider.value) / stepSize);
    
    self.clockFrequencySlider.value = newStep * stepSize;
    int val = self.clockFrequencySlider.value;
    
    self.clockTextBox.text=[NSString stringWithFormat:@"%3f",[[frequencyArray objectAtIndex:val] floatValue]];
}


- (IBAction)baudRateChanged:(id)sender
{
    int stepSize =1;
    float newStep = roundf((self.baudRateSlider.value) / stepSize);
    
    self.baudRateSlider.value = newStep * stepSize;
    int val = self.baudRateSlider.value;
    
    self.baudRateTextBox.text=[NSString stringWithFormat:@"%d",[[baudArray objectAtIndex:val] integerValue]];
    
    [self updateConfigs];
}


-(void)updateConfigs
{
    double baudF = [self.clockTextBox.text floatValue]*1000000/(16*[self.baudRateTextBox.text floatValue]) - 1;
    NSInteger baudI = [self.clockTextBox.text floatValue]*1000000/(16*[self.baudRateTextBox.text floatValue]) - 1;
    
    if (baudF-baudI>=0.5)
    {
        baudI++;
        baudF=baudF+1;
    }
    
    double actual = [self.clockTextBox.text floatValue]*1000000/(16*(baudI+1));
    double target = [self.baudRateTextBox.text floatValue];
    double error =100*(actual/target-1);
    if (baudI==0) error=0;

    self.errorLabel.text = [NSString stringWithFormat:@"%2.1f%%",error];
    
    NSLog(@"%d,%3f,%3f",baudI,baudF,error);

}



- (IBAction)rxEnabled:(id)sender
{
    
}


- (IBAction)shareButtonPressed:(id)sender
{
    
    NSArray *activityItems = @[[NSURL URLWithString:@"http://bit.ly/prathamapp"]];
    NSMutableArray *customActivities = [[NSMutableArray alloc] init];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:customActivities];
    
    [self presentViewController:activityController animated:YES completion:nil];
}
@end
