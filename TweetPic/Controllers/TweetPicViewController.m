
#import "MBProgressHUD.h"
#import "TweetPic.h"
#import "TweetPicCell.h"
#import "TweetPicManager.h"
#import "TweetPicViewController.h"
#import "TweetPicViewController+Private.h"

@implementation TweetPicViewController

@synthesize tweetPics;
@synthesize tweetSearchBar;
@synthesize tweetPicTableView;
@synthesize segmentedControl;

#pragma mark - UIViewController methods

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self 
                      selector:@selector(didReceiveTweetPicsNotification:) 
                          name:TweetPicsCreatedNotification 
                        object:nil];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    
    self.tweetPics = nil;
    self.tweetSearchBar = nil;
    self.tweetPicTableView = nil;
    self.segmentedControl = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - UISearchBarDelegate methods

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = searchBar.text;
    
    if(searchTerm != nil || [searchTerm length] > 0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tweetPicTableView animated:YES];
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
    }
    
    TweetPic *tweetPic = [self.tweetPics objectAtIndex:indexPath.row];
    cell.imageView.image = tweetPic.image;
    cell.tweetLabel.text = tweetPic.tweet;
    
    return cell;
}

#pragma mark - UITableViewDataSource delegate methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section   
{
    return [self.tweetPics count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

#pragma mark - private methods

- (void) didReceiveTweetPicsNotification: (NSNotification *) notification
{
    [MBProgressHUD hideHUDForView:self.tweetPicTableView animated:YES];
    
    NSArray *newTweetPics = [notification.userInfo valueForKey:TweetPicsKey];
    
    if(self.tweetPics == nil)
    {
        self.tweetPics = [[NSMutableArray alloc] init];
    }
    
    [self.tweetPics removeAllObjects];
    [self.tweetPics addObjectsFromArray:newTweetPics];
    [self.tweetPicTableView reloadData];
}

@end

NSString * const DidEnterSearchTermNotification = @"DidEnterSearchTerm";
NSString * const SearchTermKey = @"SearchTermKey";
