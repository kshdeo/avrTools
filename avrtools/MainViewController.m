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
    uartDoubleSpeed=FALSE;
    
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
    uartDoubleSpeed=FALSE;
    int stepSize =1;
    
    float newStep = roundf((self.baudRateSlider.value) / stepSize);
    self.baudRateSlider.value = newStep * stepSize;
    int val = self.baudRateSlider.value;
    self.baudRateTextBox.text=[NSString stringWithFormat:@"%d",[[baudArray objectAtIndex:val] integerValue]];
    
    newStep = roundf((self.clockFrequencySlider.value) / stepSize);
    self.clockFrequencySlider.value = newStep * stepSize;
    val = self.clockFrequencySlider.value;
    self.clockTextBox.text=[NSString stringWithFormat:@"%2.4f",[[frequencyArray objectAtIndex:val] floatValue]];
    
    
    baudF = [self.clockTextBox.text floatValue]*1000000/(16*[self.baudRateTextBox.text floatValue]) - 1;
    baudI = [self.clockTextBox.text floatValue]*1000000/(16*[self.baudRateTextBox.text floatValue]) - 1;
    
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
        uartDoubleSpeed=TRUE;
        
        baudF = [self.clockTextBox.text floatValue]*1000000/(8*[self.baudRateTextBox.text floatValue]) - 1;
        baudI = [self.clockTextBox.text floatValue]*1000000/(8*[self.baudRateTextBox.text floatValue]) - 1;
        
        if (baudF-baudI>=0.5)
        {
            baudI++;
            baudF=baudF+1;
        }
        
        actual = [self.clockTextBox.text floatValue]*1000000/(8*(baudI+1));
        target = [self.baudRateTextBox.text floatValue];
        error =100*(actual/target-1);
        
        if (error>20 || error<-20)
        {
            self.baudRateTextBox.textColor=[UIColor redColor];
        }
    }
    else
    {
        self.baudRateTextBox.textColor=[UIColor blackColor];
    }
    
    self.errorLabel.text = [NSString stringWithFormat:@"%2.1f%%",error];
    
    
#define INIT_BEGIN @"void uart_init(void)\n{\n"
#define LINE1 @"  UBRR0H=%d;\n"
#define LINE2 @"  UBRR0L=%d;\n\n"
#define LINE3 @"  UCSR0A |= (_BV(U2X0));\n\n"
#define LINE3A @"  UCSR0A &= ~(_BV(U2X0));\n\n"

#define LINE4 @"  UCSR0B |= "
#define LINE4A @"  UCSR0B &= ~( "

#define LINE5 @"  UCSR0C = _BV(UCSZ00) | _BV(UCSZ01);\n"
#define INIT_END @"}"
    
    NSString *outputText = INIT_BEGIN;
    if (uartDoubleSpeed)
    {
        outputText = [outputText stringByAppendingString:LINE3];
    }
    else
    {
        outputText = [outputText stringByAppendingString:LINE3A];
    }
    
    outputText = [outputText stringByAppendingFormat:LINE1,baudI/255];
    outputText = [outputText stringByAppendingFormat:LINE2,baudI%255];
    
    outputText = [outputText stringByAppendingString:LINE4];

    if (self.rxEnable.isOn)
    {
        outputText = [outputText stringByAppendingString:@"_BV(RXEN0) "];
    }
    if (self.txEnable.isOn)
    {
        outputText = [outputText stringByAppendingString:@"| _BV(TXEN0) "];
    }
    if (self.rxInterrupt.isOn)
    {
        outputText = [outputText stringByAppendingString:@"| _BV(RXCIE0) "];
    }
    if (self.txInterrupt.isOn)
    {
        outputText = [outputText stringByAppendingString:@"| _BV(TXCIE0) "];
    }
    outputText = [outputText stringByAppendingString:@";\n\n"];
    
    
    BOOL already = FALSE;
    if (!self.rxEnable.isOn)
    {
        outputText = [outputText stringByAppendingString:LINE4A];
        outputText = [outputText stringByAppendingString:@"_BV(RXEN0) "];
        already=TRUE;
    }
    if (!self.txEnable.isOn)
    {
        if (already) outputText = [outputText stringByAppendingString:@"| _BV(TXEN0) "];
        else
        {
            outputText = [outputText stringByAppendingString:LINE4A];
            outputText = [outputText stringByAppendingString:@"_BV(TXEN0) "];
        }
        already = TRUE;
    }
    if (!self.rxInterrupt.isOn)
    {
        if (already) outputText = [outputText stringByAppendingString:@"| _BV(RXCIE0) "];
        else
        {
            outputText = [outputText stringByAppendingString:LINE4A];
            outputText = [outputText stringByAppendingString:@"_BV(RXCIE0) "];
        }
        already = TRUE;
    }
    if (!self.txInterrupt.isOn)
    {
        if (already) outputText = [outputText stringByAppendingString:@"| _BV(TXCIE0) "];
        else
        {
            outputText = [outputText stringByAppendingString:LINE4A];
            outputText = [outputText stringByAppendingString:@"_BV(TXCIE0) "];
        }
        already=TRUE;
    }
    if (already) outputText = [outputText stringByAppendingString:@");\n\n"];
 
    
    
    
    outputText = [outputText stringByAppendingString:LINE5];
    outputText = [outputText stringByAppendingString:INIT_END];
    
    self.outputView.text = outputText;

    
//    NSLog(@"actual = %3f,  target = %3f, error = %3f",actual,target,error);
}



- (IBAction)rxEnabled:(id)sender
{
    [self updateConfigs];
    
    /*
    
        UBRR0H = 0;
        UBRR0L = 207;
        UCSR0A |= (_BV(U2X0));
        
        UCSR0C = _BV(UCSZ00) | _BV(UCSZ01); // Use 8 bit character sizes
        UCSR0B |= _BV(TXEN0) | _BV(RXEN0) | _BV(RXCIE0); // Enable TX and RX
    }
    ISR(USART0_RX_vect)
    {
            //Receive interrupt routine
    }
     */

}


- (IBAction)shareButtonPressed:(id)sender
{
    
    NSArray *activityItems = @[[NSURL URLWithString:@"http://bit.ly/prathamapp"]];
    NSMutableArray *customActivities = [[NSMutableArray alloc] init];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:customActivities];
    
    [self presentViewController:activityController animated:YES completion:nil];
}
@end
