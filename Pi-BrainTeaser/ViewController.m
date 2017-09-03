//
//  ViewController.m
//  Pi-BrainTeaser
//
//  Created by Fangxiang Wang on 9/18/15.
//  Copyright © 2015 Fangxiang Wang. All rights reserved.
//

#import "ViewController.h"
#import "Pi.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *numDot;
@property (nonatomic) Pi *myPi;

@property (weak, nonatomic) IBOutlet UIButton *hintButton;

@property (nonatomic) NSInteger currentScreenPiIndex;
@property (nonatomic) NSInteger currentPiIndex;

@property (strong, nonatomic)NSMutableArray *piPageArray;
@property (nonatomic)NSInteger currentPiPage;
@property (weak, nonatomic) IBOutlet UIPickerView *piPagePicker;
@end

@implementation ViewController

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //remove border on UITextField for pi digits
    for (UITextField *numTextField in self.numDot) {
        numTextField.borderStyle = UITextBorderStyleNone;
    }
    
    //page picker
    self.piPagePicker.delegate = self;
    self.piPagePicker.dataSource = self;
    self.piPagePicker.showsSelectionIndicator = YES;
   // CGAffineTransform t0 = CGAffineTransformMakeTranslation (0, self.piPagePicker.bounds.size.height/2);
   // CGAffineTransform s0 = CGAffineTransformMakeScale(1, 1);
   // CGAffineTransform t1 = CGAffineTransformMakeTranslation (0, -self.piPagePicker.bounds.size.height/2);
   // self.piPagePicker.frame = CGRectMake(150, 250, 60, 162);
  //  self.piPagePicker.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1));
  //  self.piPagePicker.transform = CGAffineTransformRotate(self.piPagePicker.transform, -M_PI/2);
}

#pragma mark - viewWillAppear: refresh the view every time when a tab bar item is clicked

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // You code here to update the view.
    
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
    UILabel * label = [[UILabel alloc]init];
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
    UITextField *curentNumDot = [self.numDot objectAtIndex:self.currentScreenPiIndex];
    curentNumDot.text = [sender currentTitle];
    
    if ([[sender currentTitle] isEqualToString:[self.myPi choosePiAtIndex:self.currentPiIndex]]) {
        self.currentPiIndex = self.currentPiIndex + 1;
        self.currentScreenPiIndex = self.currentScreenPiIndex + 1;
        if ([curentNumDot.textColor isEqual:[UIColor redColor]]) {
            curentNumDot.textColor = [UIColor blueColor];
        }
    } else {
        curentNumDot.textColor = [UIColor redColor];
    }

    if (![[self.hintButton currentTitle] isEqualToString:@"?"] ){
        [self.hintButton setTitle:@"?" forState:UIControlStateNormal];
        [self.hintButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
- (IBAction)pressHintNum:(id)sender {
    [self.hintButton setTitle:[self.myPi choosePiAtIndex:self.currentPiIndex] forState:UIControlStateNormal];
    [self.hintButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}

#pragma mark - update pi number on screen

- (void)updateUI {
    for (UITextField *numTextField in self.numDot) {
        numTextField.textColor = [UIColor blackColor];
        int index = (int) ((self.currentPiPage-1)*30 + [self.numDot indexOfObject:numTextField]);
        if (index < self.currentPiIndex) {
            numTextField.text = [self.myPi choosePiAtIndex:index];
        } else {
            numTextField.text = @".";
        }
    }
}

@end
