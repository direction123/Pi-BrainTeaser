//
//  PiViewController.m
//  Pi-BrainTeaser
//
//  Created by Fangxiang Wang on 9/23/15.
//  Copyright © 2015 Fangxiang Wang. All rights reserved.
//

#import "PiViewController.h"
#import "Pi.h"

@interface PiViewController ()
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *piDotNums;
@property (nonatomic) Pi *myPi;
@property (strong, nonatomic)NSArray *piPageArray;
@property (nonatomic)NSInteger currentPiPage;
@property (weak, nonatomic) IBOutlet UIPickerView *piPagePicker;

@end

@implementation PiViewController

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //remove border on UITextField for pi digits
    for (UITextField *numTextField in self.piDotNums) {
        numTextField.borderStyle = UITextBorderStyleNone;
    }
    
    //page range
    _piPageArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10",
                     @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20",
                     @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30",
                     @"31", @"32", @"33", @"34"];
    
    //page picker
    self.piPagePicker.delegate = self;
    self.piPagePicker.dataSource = self;
    self.piPagePicker.showsSelectionIndicator = YES;
 //   CGAffineTransform t0 = CGAffineTransformMakeTranslation (0, self.piPagePicker.bounds.size.height/2);
//    CGAffineTransform s0 = CGAffineTransformMakeScale(0.7, 0.7);
 //   CGAffineTransform t1 = CGAffineTransformMakeTranslation (0, -self.piPagePicker.bounds.size.height/2);
//    self.piPagePicker.frame = CGRectMake(150, 300, 60, 162);
  //  self.piPagePicker.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1));
   // self.piPagePicker.transform = CGAffineTransformRotate(self.piPagePicker.transform, -M_PI/2);
}

#pragma mark - viewWillAppear: refresh the view every time when a tab bar item is clicked

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // You code here to update the view.
    
    //page number init
    self.currentPiPage = 1;
    [self updateUI];
}

#pragma mark - lazy initialization

- (Pi*) myPi {
    if (!_myPi) {
        _myPi = [[Pi alloc] init];
    }
    return _myPi;
}

#pragma mark - pick view delegate

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    return  _piPageArray.count;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.currentPiPage = [[_piPageArray objectAtIndex:row] integerValue];
    [self updateUI];
}

-(UIView *) pickerView: (UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
   // CGRect rect = CGRectMake(0, 0, 30, 21);
   // UILabel * label = [[UILabel alloc]initWithFrame:rect];
    UILabel * label = [[UILabel alloc]init];
    label.text = [NSString stringWithFormat:@"page %@",_piPageArray[row]];
    label.opaque = NO;
    label.font=[label.font fontWithSize:26];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.clipsToBounds = YES;
 //   label.transform = CGAffineTransformRotate(label.transform, M_PI/2);
    return label;
}

#pragma mark - update pi number on screen

- (void)updateUI {
    for (UITextField *numTextField in self.piDotNums) {
        int index = (int) ((self.currentPiPage-1)*30 + [self.piDotNums indexOfObject:numTextField]);
        if (index < [self.myPi piLength]) {
            numTextField.text = [self.myPi choosePiAtIndex:index];
        } else {
            numTextField.text = @".";
        }
    }
}
@end
