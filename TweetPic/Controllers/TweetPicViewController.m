
#import "MBProgressHUD.h"
#import "TweetPic.h"
#import "TweetPicManager.h"
#import "TweetPicViewController.h"
#import "TweetPicViewController+Private.h"

@implementation TweetPicViewController

@synthesize tweetPics;
@synthesize tweetSearchBar;
@synthesize tweetPicTableView;
@synthesize segmentedControl;

#pragma mark - UIViewController methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self 
                      selector:@selector(didReceiveTweetPicNotification:) 
                          name:TweetPicCreatedNotification 
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TweetPicCell" owner:nil options:nil] objectAtIndex:0];
    }
    
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

- (void) didReceiveTweetPicNotification: (NSNotification *) notification
{
    TweetPic *tweetPic = [notification.userInfo valueForKey:TweetPicKey];
    [self.tweetPics addObject:tweetPic];
    [self.tweetPicTableView reloadData];
}

@end

NSString * const DidEnterSearchTermNotification = @"DidEnterSearchTerm";
NSString * const SearchTermKey = @"SearchTermKey";
