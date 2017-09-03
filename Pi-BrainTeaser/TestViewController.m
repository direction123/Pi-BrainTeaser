//
//  TestViewController.m
//  Pi-BrainTeaser
//
//  Created by Fangxiang Wang on 9/26/15.
//  Copyright © 2015 Fangxiang Wang. All rights reserved.
//

#import "TestViewController.h"
#import "Pi.h"

@interface TestViewController ()
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *testDotNums;
@property (nonatomic) Pi *myPi;
@property (nonatomic) NSInteger currentScreenPiIndex;
@property (nonatomic) NSInteger currentPiIndex;

@property (weak, nonatomic) IBOutlet UIPickerView *piPagePicker;
@property (strong, nonatomic)NSMutableArray *piPageArray;
@property (nonatomic)NSInteger currentPiPage;
@end

@implementation TestViewController

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    for (UITextField *numTextField in self.testDotNums) {
        numTextField.borderStyle = UITextBorderStyleNone;
    }
    //page picker
    self.piPagePicker.delegate = self;
    self.piPagePicker.dataSource = self;
    self.piPagePicker.showsSelectionIndicator = YES;
  //  CGAffineTransform t0 = CGAffineTransformMakeTranslation (0, self.piPagePicker.bounds.size.height/2);
  //  CGAffineTransform s0 = CGAffineTransformMakeScale(0.7, 0.7);
  //  CGAffineTransform t1 = CGAffineTransformMakeTranslation (0, -self.piPagePicker.bounds.size.height/2);
 //   self.piPagePicker.frame = CGRectMake(150, 250, 60, 162);
 //   self.piPagePicker.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1));
  //  self.piPagePicker.transform = CGAffineTransformRotate(self.piPagePicker.transform, -M_PI/2);
}

#pragma mark - viewWillAppear: refresh the view every time when a tab bar item is clicked

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // You code here to update the view.
    
    [self  resetView];
}

- (void) resetView {
    //page number && pi index init
    self.currentPiPage = 1;
    self.currentScreenPiIndex = 0;
    self.currentPiIndex = 0;
    [self updateUI];
    
    //page range
    _piPageArray = [[NSMutableArray alloc]init];
    [_piPageArray addObject:@"1"];

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
    NSString *resultString = _piPageArray[row];
    self.currentPiPage = resultString.intValue;
    [self updateUI];
}

-(UIView *) pickerView: (UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
  //  CGRect rect = CGRectMake(0, 0, 30, 21);
  //  UILabel * label = [[UILabel alloc]initWithFrame:rect];
    UILabel * label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"page %@",_piPageArray[row]];
    label.opaque = NO;
    label.font=[label.font fontWithSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.clipsToBounds = YES;
  //  label.transform = CGAffineTransformRotate(label.transform, M_PI/2);
    return label;
}

#pragma mark - digits keyboard action

- (IBAction)pressNum:(UIButton *)sender {
    if (self.currentScreenPiIndex == 30) {
        NSString *nextPage = [NSString stringWithFormat: @"%ld", (long)[[self.piPageArray lastObject] integerValue]+1];
        [self.piPageArray addObject:nextPage];
        [self.piPagePicker reloadAllComponents];
        [self.piPagePicker selectRow:([nextPage integerValue]-1) inComponent:0 animated:YES];
        
        //clear screen
        self.currentScreenPiIndex = 0;
        self.currentPiPage = [nextPage integerValue];
        [self updateUI];
    }
    UITextField *curentNumDot = [self.testDotNums objectAtIndex:self.currentScreenPiIndex];
    curentNumDot.text = [sender currentTitle];
    
    if ([[sender currentTitle] isEqualToString:[self.myPi choosePiAtIndex:self.currentPiIndex]]) {
        self.currentPiIndex = self.currentPiIndex + 1;
        self.currentScreenPiIndex = self.currentScreenPiIndex + 1;
        if ([curentNumDot.textColor isEqual:[UIColor redColor]]) {
            curentNumDot.textColor = [UIColor blueColor];
        }
    } else {
      //  curentNumDot.textColor = [UIColor redColor];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Test Over"
                                                                       message:[NSString stringWithFormat:@"You score is %ld digits", (long)self.currentPiIndex]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        if (self.currentPiIndex <= 1) {
            alert.message = [NSString stringWithFormat:@"You score is %ld digit", (long)self.currentPiIndex];
        }
        UIAlertAction *tryagainAction = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"Try again", @"tryagainAction")
                                    style:UIAlertActionStyleDestructive
                                    handler:^(UIAlertAction *action)
                                    {
                                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                        NSArray *scoreArray = [defaults objectForKey:@"scoreArray"];

                                        NSMutableArray *scoreMutableArray=[[NSMutableArray alloc] init];
                                        
                                        if ([scoreArray count]!=0) {
                                            for (NSString *pastScore in scoreArray) {
                                                [scoreMutableArray addObject:pastScore];
                                            }
                                        }

                                        NSString *currentScore = [NSString stringWithFormat:@"%ld", (long)self.currentPiIndex];

                                        [scoreMutableArray addObject:currentScore];
                                        
                                        scoreArray = [scoreMutableArray copy];
                                        
                                        [defaults setObject:scoreArray forKey:@"scoreArray"];

                                        [defaults synchronize];
                                        
                                        [self  resetView];
                                    }];
        UIAlertAction *viewScoreAction = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"View Socre", @"viewScoreAction")
                                    style:UIAlertActionStyleDestructive
                                    handler:^(UIAlertAction *action)
                                    {
                                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                        NSArray *scoreArray = [defaults objectForKey:@"scoreArray"];
                                        
                                        NSMutableArray *scoreMutableArray=[[NSMutableArray alloc] init];
                                        
                                        if ([scoreArray count]!=0) {
                                            for (NSString *pastScore in scoreArray) {
                                                [scoreMutableArray addObject:pastScore];
                                            }
                                        }
                                        
                                        NSString *currentScore = [NSString stringWithFormat:@"%ld", (long)self.currentPiIndex];
                                        
                                        [scoreMutableArray addObject:currentScore];
                                        
                                        scoreArray = [scoreMutableArray copy];
                                        
                                        [defaults setObject:scoreArray forKey:@"scoreArray"];
                                        
                                        [defaults synchronize];
                                        
                                        [self.tabBarController setSelectedIndex:2];

                                    }];

        [alert addAction:tryagainAction];
        [alert addAction:viewScoreAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - update pi number on screen

- (void)updateUI {
    for (UITextField *numTextField in self.testDotNums) {
        int index = (int) ((self.currentPiPage - 1)*30 + [self.testDotNums indexOfObject:numTextField]);
        if (index < self.currentPiIndex) {
            numTextField.text = [self.myPi choosePiAtIndex:index];
        } else {
            numTextField.text = @".";
        }
    }
}


@end
