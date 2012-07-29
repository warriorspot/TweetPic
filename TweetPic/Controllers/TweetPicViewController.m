
#import <QuartzCore/QuartzCore.h>
#include "my_itoa.h"
#import "MBProgressHUD.h"
#import "TweetPic.h"
#import "TweetPicCell.h"
#import "TweetPicManager.h"
#import "TweetPicViewController.h"


@interface TweetPicViewController()

@property (nonatomic, assign) IBOutlet UIButton *dismissKeyboardButton;
@property NSUInteger tweetPicCount;

- (IBAction) dismissKeyboard:(id)sender;

- (IBAction) didSelectSegmentedControl:(id)sender;

- (void) keyboardDidHide: (NSNotification *) notification;

- (void) keyboardDidShow: (NSNotification *) notification;

- (void) showMessageWithTitle: (NSString *) title message: (NSString *) message;

- (BOOL) sortTweetPics;

- (void) toggleView: (UIView *) view visible: (BOOL) isVisible animated: (BOOL) animated;

- (void) tweetPicErrorNotification: (NSNotification *) notification;

- (void) tweetPicNotification: (NSNotification *) notification;

- (void) tweetPicsCreatedNotification: (NSNotification *) notification;

@end


@implementation TweetPicViewController

@synthesize dismissKeyboardButton;
@synthesize tweetPics;
@synthesize tweetSearchBar;
@synthesize tweetPicTableView;
@synthesize segmentedControl;
@synthesize tweetPicCountLabel;
@synthesize tweetPicCount;

#pragma mark - UIViewController methods

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self 
                      selector:@selector(tweetPicNotification:)
                          name:TweetPicCreatedNotification 
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(tweetPicsCreatedNotification:)
                          name:TweetPicsCreatedNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(tweetPicErrorNotification:)
                          name:TweetPicErrorNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(keyboardDidShow:)
                          name:UIKeyboardDidShowNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(keyboardDidHide:)
                          name:UIKeyboardDidHideNotification
                        object:nil];
    
    //For fun, make a gradient
    UIView *gradientView = [[UIView alloc] initWithFrame:self.tweetPicCountLabel.frame];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = gradientView.bounds;
    UIColor *searchBarColor = [UIColor colorWithRed:110.0/255.0 green:133.0/255.0 blue:162.0/255.0 alpha:1.0];
    gradient.colors = [NSArray arrayWithObjects:(id)[searchBarColor CGColor], (id)[[UIColor whiteColor]CGColor], nil];
    [gradientView.layer addSublayer:gradient];
    [self.view addSubview:gradientView];
    [self.view insertSubview:self.tweetPicCountLabel aboveSubview:gradientView];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidAppear:(BOOL)animated
{
    if(self.tweetPics == nil || [self.tweetPics count] == 0)
    {
        [self.tweetSearchBar becomeFirstResponder];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - UIAlertView delegate methods

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
}

#pragma mark - UISearchBarDelegate methods

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = searchBar.text;
    
    if(searchTerm != nil && [searchTerm length] > 0)
    {
        [self.tweetPics removeAllObjects];
        tweetPicCount = 0;
        [self toggleView:self.tweetPicTableView visible:NO animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = NSLocalizedString(@"LOADING_LABEL", NULL);
        
        [searchBar resignFirstResponder];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:searchTerm 
                                                             forKey:SearchTermKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:DidEnterSearchTermNotification 
                                                            object:self 
                                                          userInfo:userInfo];
    }
}

#pragma mark - UITableViewDelegate methods

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    TweetPicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TweetPicCell" owner:nil options:nil] objectAtIndex:0];
        tableView.rowHeight = cell.frame.size.height;
    }
    
    TweetPic *tweetPic = [self.tweetPics objectAtIndex:indexPath.row];
    cell.imageView.image = tweetPic.image;
    cell.tweetLabel.text = tweetPic.tweet;
    cell.dateLabel.text = tweetPic.dateString;
    
    return cell;
}

#pragma mark - UITableViewDataSource delegate methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section   
{
    return [self.tweetPics count];
}

#pragma mark - IBActions

- (IBAction) didSelectSegmentedControl:(id)sender
{
    if([self sortTweetPics])
    {
        [self toggleView:self.tweetPicTableView visible:NO animated:NO];
        [self.tweetPicTableView reloadData];
        [self toggleView:self.tweetPicTableView visible:YES animated:YES];
    }
}

- (IBAction)dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - private methods
    
- (void) keyboardDidHide:(NSNotification *)notification
{
    self.dismissKeyboardButton.enabled = NO;
}

- (void) keyboardDidShow:(NSNotification *)notification
{
    self.dismissKeyboardButton.enabled = YES;
}

- (void) showMessageWithTitle: (NSString *) title message: (NSString *) message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"MESSAGE_CANCEL_BUTTON_TITLE", nil)
                                              otherButtonTitles: nil];
    
    [alertView show];
}

- (BOOL) sortTweetPics
{
    if(self.tweetPics == nil || [self.tweetPics count] == 0)
    {
        return NO;
    }
    
    NSArray *sortedArray = nil;
    
    if(self.segmentedControl.selectedSegmentIndex == 0)
    {
        sortedArray = [self.tweetPics sortedArrayUsingSelector:@selector(compareByTweet:)];
    }
    else if(self.segmentedControl.selectedSegmentIndex == 1)
    {
        sortedArray = [self.tweetPics sortedArrayUsingSelector:@selector(compareByDate:)];
    }
    
    self.tweetPics = [NSMutableArray arrayWithArray: sortedArray];
    
    return YES;
}

- (void) toggleView: (UIView *) toggleView visible: (BOOL) visible animated: (BOOL) animated
{
    CGFloat newAlpha;
    
    if(visible)
    {
        newAlpha = 1.0f;
    }
    else
    {
        newAlpha = 0.0f;
    }
    
    if(animated)
    {
        [UIView beginAnimations:@"toggle_view" context:nil];
        [UIView setAnimationDuration:0.3f];
    }
    
    toggleView.alpha = newAlpha;
    
    if(animated)
    {
        [UIView commitAnimations];
    }
}

- (void) tweetPicNotification: (NSNotification *) notification
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self toggleView:self.tweetPicTableView visible:YES animated:YES];
    
    tweetPicCount++;
    
    // For fun, here's my implementation of itoa in action ;)
    char *count_string = my_itoa((int) tweetPicCount);
    NSString *countString = [NSString stringWithCString:count_string encoding:NSUTF8StringEncoding];
    self.tweetPicCountLabel.text = countString;
    free(count_string);
    
    TweetPic *tweetPic = [notification.userInfo valueForKey:TweetPicKey];
    
    if(self.tweetPics == nil)
    {
        self.tweetPics = [[NSMutableArray alloc] init];
    }
    
    [self.tweetPics addObject:tweetPic];
    [self sortTweetPics];
    [self.tweetPicTableView reloadData];
}

- (void) tweetPicErrorNotification: (NSNotification *) notification
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [self showMessageWithTitle:NSLocalizedString(@"ERROR_TITLE", nil)
                       message:[notification.userInfo valueForKey:TweetPicErrorDescriptionKey]];
}

- (void) tweetPicsCreatedNotification: (NSNotification *) notification
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    self.tweetPicCountLabel.text = [NSString stringWithFormat:@"Created %d TweetPics", tweetPicCount];
}

@end

NSString * const DidEnterSearchTermNotification = @"DidEnterSearchTerm";
NSString * const SearchTermKey = @"SearchTermKey";
