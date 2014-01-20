//
//  MainViewController.m
//  avrtools
//
//  Created by Kshitij-Deo on 26/12/13.
//  Copyright (c) 2013 Buffer Labs Pvt. Ltd. All rights reserved.
//

#import "MainViewController.h"
#import "AboutViewController.h"

#define IPHONE5_FRAME_DOWN CGRectMake(0, 422, 320, 263)
#define IPHONE5_FRAME_UP CGRectMake(0, 300, 320, 268)
#define IPHONE4_FRAME_DOWN CGRectMake(0, 422, 320, 263)
#define IPHONE4_FRAME_UP CGRectMake(0, 300, 320, 268)


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
    
    self.navigationItem.rightBarButtonItem = self.shareButton;
    self.navigationItem.leftBarButtonItem = self.infoButton;
    self.title = @"USART config tool";
    
    up=TRUE;
    uartDoubleSpeed=FALSE;
    
    self.clockTextBox.delegate=self;
    self.baudRateTextBox.delegate=self;
    
    frequencyArray=[NSArray arrayWithObjects:@"1",@"1.8432",@"2",@"3.6864",@"4",@"7.3728",@"8",@"11.0592",@"12",@"14.7456",@"16",@"18.432",@"20", nil];
    self.clockFrequencySlider.maximumValue=[frequencyArray count]-1;
    
    baudArray=[NSArray arrayWithObjects:@"1200",@"2400",@"4800",@"9600",@"14400",@"19200",@"28800",@"38400",@"57600",@"76800",@"115200",@"230400",@"250000",@"460800",@"500000",@"921000",@"1000000",@"1152000",@"1250000",@"1843200",@"2000000",@"2304000",@"2500000" ,nil];
    self.baudRateSlider.maximumValue=[baudArray count]-1;
    
    [self.modeSegmentControl setSelectedSegmentIndex:0];
    [self.paritySegmentControl setSelectedSegmentIndex:2];
    [self.stopbitSegmentControl setSelectedSegmentIndex:0];
    
    UIImage *toolTipsImage = [UIImage imageNamed:@"textbox_bg.png"];
    self.backgroundImage.image = [toolTipsImage resizableImageWithCapInsets:UIEdgeInsetsMake(12.0f, 12.0f, 12.0f, 12.0f)];
    
    self.outputContainerView.frame=IPHONE5_FRAME_UP;
    [self.view addSubview:self.outputContainerView];
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
                             self.outputContainerView.frame = IPHONE5_FRAME_DOWN;
                         }];
        [self.moreButton setImage:[UIImage imageNamed:@"arrow-up.png"] forState:UIControlStateNormal];
        up=FALSE;
    }
    else
    {
        up=TRUE;
        
        [UIView animateWithDuration:0.8
                         animations:^{
                             self.outputContainerView.frame=IPHONE5_FRAME_UP;
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
    self.baudRateTextBox.text=[NSString stringWithFormat:@"%d",[[baudArray objectAtIndex:val] intValue]];
    
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
    
    
    
/*
 * Code generation section
 */
    
#define INIT_BEGIN @"void uart_init(void)\n{\n"
#define LINE1 @"\tUBRR0H=%d;\n"
#define LINE2 @"\tUBRR0L=%d;\n\n"
#define LINE3 @"\tUCSR0A |= (_BV(U2X0));\n\n"
#define LINE3A @"\tUCSR0A &= ~(_BV(U2X0));\n\n"
#define LINE4 @"\tUCSR0B |= "
#define LINE4A @"\tUCSR0B &= ~( "
    
    
#define LINE5 @"\tUCSR0C = _BV(UCSZ00) | _BV(UCSZ01)"
#define LINE6 @" | _BV(UMSEL00) | _BV(UMSEL01)"  //Master SPI
#define LINE6A @" | _BV(UMSEL00)"   //Synchronous
#define LINE7 @" | _BV(UPM00) | _BV(UPM01)" //Odd Parity
#define LINE7A @" | _BV(UPM01)"  //Even parity
#define LINE8 @" | _BV(USBS0)"  //2 stop bits
#define INIT_END @";\n\n}"

    
//  UCSR0A setting
    NSString *outputText = INIT_BEGIN;
    if (uartDoubleSpeed)
    {
        outputText = [outputText stringByAppendingString:LINE3];
    }
    else
    {
        outputText = [outputText stringByAppendingString:LINE3A];
    }

    
    
//  UBRR setting
    outputText = [outputText stringByAppendingFormat:LINE1,baudI/255];
    outputText = [outputText stringByAppendingFormat:LINE2,baudI%255];
    
    

//  UCSR0B setting
    BOOL already = FALSE;
    if (self.rxEnable.isOn)
    {
        outputText = [outputText stringByAppendingString:LINE4];
        outputText = [outputText stringByAppendingString:@"_BV(RXEN0)"];
        already=TRUE;
    }
    if (self.txEnable.isOn)
    {
        if (already) outputText = [outputText stringByAppendingString:@" | _BV(TXEN0)"];
        else
        {
            outputText = [outputText stringByAppendingString:LINE4];
            outputText = [outputText stringByAppendingString:@"_BV(TXEN0)"];
        }
        already=TRUE;
    }
    if (self.rxInterrupt.isOn)
    {
        if (already) outputText = [outputText stringByAppendingString:@" | _BV(RXCIE0)"];
        else
        {
            outputText = [outputText stringByAppendingString:LINE4];
            outputText = [outputText stringByAppendingString:@"_BV(RXCIE0)"];
        }
        already=TRUE;
    }
    if (self.txInterrupt.isOn)
    {
        if (already) outputText = [outputText stringByAppendingString:@" | _BV(TXCIE0)"];
        else
        {
            outputText = [outputText stringByAppendingString:LINE4];
            outputText = [outputText stringByAppendingString:@"_BV(TXCIE0)"];
        }
        already=TRUE;
    }
    if (already) outputText = [outputText stringByAppendingString:@";\n\n"];
    
    outputText = [outputText stringByAppendingString:LINE5];
    switch (self.modeSegmentControl.selectedSegmentIndex)
    {
        case 0:   //Asynchronous
            break;
        
        case 1:    //Synchronous
            outputText = [outputText stringByAppendingString:LINE6A];
            break;
            
        case 2:    //Master SPI
            outputText = [outputText stringByAppendingString:LINE6];
            break;
            
        default:
            break;
    }

    
    switch (self.paritySegmentControl.selectedSegmentIndex)
    {
        case 0:   //Odd
            outputText = [outputText stringByAppendingString:LINE7];
            break;
            
        case 1:    //Even
            outputText = [outputText stringByAppendingString:LINE7A];
            break;
            
        case 2:    //Disabled
            break;
            
        default:
            break;
    }
    
    
    switch (self.stopbitSegmentControl.selectedSegmentIndex)
    {
        case 0:   //1 stop bit
            break;
            
        case 1:    //2 stop bit
            outputText = [outputText stringByAppendingString:LINE8];
            break;
            
        default:
            break;
    }
    
    
    if (self.txInterrupt.isOn | self.rxInterrupt.isOn)
    {
        outputText = [outputText stringByAppendingString:@";\n\n\tsei();//Enable global interrupts\n}\n"];
    }
    else outputText = [outputText stringByAppendingString:INIT_END];
    
    
/*
 *  Interrupt service routine generation
 */
    if (self.rxInterrupt.isOn)
    {
        outputText = [outputText stringByAppendingString:@"\nISR(USART0_RX_vect)\n{\n\t//Receive interrupt\n}\n"];
    }
    
    if (self.txInterrupt.isOn)
    {
        outputText = [outputText stringByAppendingString:@"\nISR(USART0_TX_vect)\n{\n\t//Transmit complete interrupt\n}\n"];
    }
    
    self.outputView.text = outputText;
}



- (IBAction)rxEnabled:(id)sender
{
    [self updateConfigs];
}



- (IBAction)segmentControlChanged:(id)sender
{
    [self updateConfigs];
}


- (IBAction)infoPressed:(id)sender
{
    AboutViewController *aboutVC = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:aboutVC animated:YES];
}


- (IBAction)shareButtonPressed:(id)sender
{
    NSArray *activityItems = [NSArray arrayWithObjects:self.outputView.text, nil];
    NSMutableArray *customActivities = [[NSMutableArray alloc] init];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:customActivities];
    
    [self presentViewController:activityController animated:YES completion:nil];
}

@end
