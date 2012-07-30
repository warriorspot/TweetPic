
#import <QuartzCore/QuartzCore.h>
#include "my_itoa.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "TweetPic.h"
#import "TweetPicCell.h"
#import "TweetPicManager.h"
#import "TweetPicViewController.h"

/// Private interface
///
@interface TweetPicViewController()

/// This is an invisible UIButton that is enable when the keyboard is visible.
/// Tapping this button (i.e. tapping anywhere other than the search bar)
/// dismisses the keyboard.
@property (nonatomic, assign) IBOutlet UIButton *dismissKeyboardButton;

/// A count of the number of TweetPicCreatedNotifications received since
/// entering the current search term.
@property NSUInteger tweetPicCount;

/// Dismisses the keyboard.
///
/// @param sender
///     dismissKeyboardButton
///
- (IBAction) dismissKeyboard:(id)sender;

/// Sent by sortingControl to sort the contents of the tweetPics array.
/// Sorting only occurs if the array has contents.
///
/// @param sender
///     sortingControl
///
- (IBAction) didSelectSortingControl:(id)sender;

/// Handler for the system-generated UIKeyboardDidHideNotification.
/// Disables the dismissKeyboardButton button.
///
/// @param
///     the notification object
///
- (void) keyboardDidHide: (NSNotification *) notification;

/// Handler for the system-generated UIKeyboardDidShowNotification.
/// Enables the dismissKeyboardButton button.
///
/// @param
///     the notification object
///
- (void) keyboardDidShow: (NSNotification *) notification;

/// A helper method that displays a UIAlertView with the given title and
/// message.  Sets the delegate of the UIAlertView to 'self'
///
/// @param title
///     the text to use as the title of the alert
///
/// @param message
///     the test to use as the body of the alert
///
- (void) showMessageWithTitle: (NSString *) title message: (NSString *) message;

/// Sorts the contents of the tweetPics array according to the current selection
/// of the sortingControl segmented control.  Returns YES if sorting occurred,
/// NO if no sorting occured (the array was nil or empty).
///
- (BOOL) sortTweetPics;

/// A helper method that toggle the visibility of a view by setting the alpha
/// value appropriately.  The property change can optionally be animated.
///
/// @param view
///     the view to toggle
///
/// @param isVisible
///     YES to make the view visible, NO to make it invisible
///
/// @param animated
///     YES to animate the change, NO otherwise
///
- (void) toggleView: (UIView *) view visible: (BOOL) isVisible animated: (BOOL) animated;

/// Handler for the TweetPicErrorNotification.  Reads the value in the
/// TweetPicErrorDescriptionKey key and displays it in a UIAlertView.
///
/// @param notification
///     the notification object
///
- (void) tweetPicErrorNotification: (NSNotification *) notification;

/// Handler for the TweetPicCreatedNotification.  Stores the TweetPic
/// accessed via the TweetPicKey key in the tweetPics array.  Resorts the
/// the resulting array and reloads the data in the table view.
///
/// @param notification
///     the notification object
///
- (void) tweetPicNotification: (NSNotification *) notification;

/// Handler for the TweetPicsCreatedNotification.  Updates tweetPicsCountLabel
/// to indicate that all TweetPics have been created for the current search
/// term.
///
/// @param notification
///     the notification object
///
- (void) tweetPicsCreatedNotification: (NSNotification *) notification;

@end


@implementation TweetPicViewController

@synthesize dismissKeyboardButton;
@synthesize tweetPics;
@synthesize tweetSearchBar;
@synthesize tweetPicTableView;
@synthesize sortingControl;
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
    //Stub
}

#pragma mark - UISearchBarDelegate methods

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [self showMessageWithTitle:NSLocalizedString(@"ERROR_TITLE", nil)
                           message:NSLocalizedString(@"ERROR_NOT_CONNECTED", nil)];
        return;
    }
    
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

- (IBAction) didSelectSortingControl:(id)sender
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
    
    if(self.sortingControl.selectedSegmentIndex == 0)
    {
        sortedArray = [self.tweetPics sortedArrayUsingSelector:@selector(compareByTweet:)];
    }
    else if(self.sortingControl.selectedSegmentIndex == 1)
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
