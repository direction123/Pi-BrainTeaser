//
//  ScoreViewController.m
//  Pi-BrainTeaser
//
//  Created by Fangxiang Wang on 9/26/15.
//  Copyright © 2015 Fangxiang Wang. All rights reserved.
//

#import "ScoreViewController.h"
#import "CustomTableViewCell.h"
#import <Social/Social.h>

@interface ScoreViewController ()
@property (weak, nonatomic) IBOutlet UITableView *scoreTableView;
@property (weak, nonatomic) IBOutlet UIButton *clearHistoryButton;
@property (nonatomic) NSArray *scoreArray;
- (IBAction)didTapCellShareButton:(UIButton *)sender;
@end

@implementation ScoreViewController

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //table view
    self.scoreTableView.delegate = self;
    self.scoreTableView.dataSource = self;
    [self.scoreTableView reloadData];
    self.scoreTableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    
    //read data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.scoreArray = [defaults objectForKey:@"scoreArray"];
    
    //update clearHistoryButton
    if([self.scoreArray count]!=0) {
        self.clearHistoryButton.enabled = true;
    } else {
        self.clearHistoryButton.enabled = false;
    }
}

#pragma mark - viewWillAppear: refresh the view every time when a tab bar item is clicked

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // read data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.scoreArray = [defaults objectForKey:@"scoreArray"];
    [self.scoreTableView reloadData];
    
    //update clearHistoryButton
    if([self.scoreArray count]!=0) {
        self.clearHistoryButton.enabled = true;
    } else {
        self.clearHistoryButton.enabled = false;
    }
}
/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 34;
}*/

#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [self.scoreArray count];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *identifier = @"defaultHeader";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
    }
    headerView.textLabel.text = @"Score History";
    headerView.textLabel.textAlignment = NSTextAlignmentCenter;
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {static NSString *cellid=@"CustomCell";
    CustomTableViewCell *cell=(CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellid];;
    if(cell==nil)
    {
        cell=[[CustomTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    
    NSString *score = [NSString stringWithFormat:@"%@ digits", [self.scoreArray objectAtIndex:indexPath.row]];
    cell.scoreLabel.text = score;
    [cell.cellShareButton setTitle:@"Share" forState:UIControlStateNormal];
    cell.cellShareButton.tag = 101+indexPath.row;
    cell.swipableUIView.tag=301+indexPath.row;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - share on facebook

- (IBAction)didTapCellShareButton:(UIButton *)sender {
    SLComposeViewController *mySLComposerSheet = [[SLComposeViewController alloc] init];
    mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    NSInteger selectedIndex = sender.tag - 101;
    CustomTableViewCell *selectedCell = [self.scoreTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
    [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"I could remember %@ in pi!",selectedCell.scoreLabel.text]];
    
    [self presentViewController:mySLComposerSheet animated:YES completion:nil];
}
- (IBAction)clearHistory:(UIButton *)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Clear All Histories"
                                                                   message:[NSString stringWithFormat:@"Are you sure to clear all hisotries"]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"OK", @"yes action")
                                style:UIAlertActionStyleDestructive
                                handler:^(UIAlertAction *action)
                                {
                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                    NSArray *scoreArray = NULL;
                                    [defaults setObject:scoreArray forKey:@"scoreArray"];
                                    [defaults synchronize];
                                    
                                    self.scoreArray = [defaults objectForKey:@"scoreArray"];
                                    [self.scoreTableView reloadData];

                                }];
    UIAlertAction *cancelAction = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Cancel", @"cancle action")
                                style:UIAlertActionStyleDestructive
                                handler:^(UIAlertAction *action)
                                {
                                    
                                }];
    [alert addAction:yesAction];
    [alert addAction:cancelAction];

    [self presentViewController:alert animated:YES completion:nil];
    
    //update clearHistoryButton
    self.clearHistoryButton.enabled = false;
    
}
@end
