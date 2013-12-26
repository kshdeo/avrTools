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
    self.clockFrequencySlider.maximumValue=[frequencyArray count]-1;
    
    baudArray=[NSArray arrayWithObjects:@"1200",@"2400",@"4800",@"9600",@"14400",@"19200",@"28800",@"38400",@"57600",@"76800",@"115200",@"230400",@"250000",@"460800",@"500000",@"921000",@"1000000",@"1152000",@"1250000",@"1843200",@"2000000",@"2304000",@"2500000" ,nil];
    self.baudRateSlider.maximumValue=[baudArray count]-1;
    
    UIImage *toolTipsImage = [UIImage imageNamed:@"textbox_bg.png"];
    self.backgroundImage.image = [toolTipsImage resizableImageWithCapInsets:UIEdgeInsetsMake(12.0f, 12.0f, 12.0f, 12.0f)];
}


-(void)viewDidAppear:(BOOL)animated
{
    [self updateConfigs];
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

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self updateConfigs];
}

- (IBAction)moreButtonPressed:(id)sender
{
    if (up)
    {
        [UIView animateWithDuration:0.8
                         animations:^{
                             self.outputView.frame=CGRectMake(0, 480, 320, 300);
                             self.moreButton.frame=CGRectMake(290, 484, 26, 26);
                         }];
        [self.moreButton setImage:[UIImage imageNamed:@"arrow-up.png"] forState:UIControlStateNormal];
        up=FALSE;
    }
    else
    {
        up=TRUE;
        
        [UIView animateWithDuration:0.8
                         animations:^{
                             self.outputView.frame=CGRectMake(0, 310, 320, 300);
                             self.moreButton.frame=CGRectMake(290, 314, 26, 26);
                         }];
        [self.moreButton setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
    }
}


- (IBAction)clockFrequencyChanged:(id)sender
{
    [self updateConfigs];

}


- (IBAction)baudRateChanged:(id)sender
{

    [self updateConfigs];
}


-(void)updateConfigs
{
    int stepSize =1;
    
    float newStep = roundf((self.baudRateSlider.value) / stepSize);
    self.baudRateSlider.value = newStep * stepSize;
    int val = self.baudRateSlider.value;
    self.baudRateTextBox.text=[NSString stringWithFormat:@"%d",[[baudArray objectAtIndex:val] integerValue]];
    
    newStep = roundf((self.clockFrequencySlider.value) / stepSize);
    self.clockFrequencySlider.value = newStep * stepSize;
    val = self.clockFrequencySlider.value;
    self.clockTextBox.text=[NSString stringWithFormat:@"%3f",[[frequencyArray objectAtIndex:val] floatValue]];
    
    
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

    if (error>20 || error<-20)
    {
        self.baudRateTextBox.textColor=[UIColor redColor];
    }
    else
    {
        self.baudRateTextBox.textColor=[UIColor blackColor];
    }
    
    self.errorLabel.text = [NSString stringWithFormat:@"%2.1f%%",error];

    NSLog(@"actual = %3f,  target = %3f, error = %3f",actual,target,error);
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
