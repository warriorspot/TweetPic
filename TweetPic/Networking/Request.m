
#import "Request.h"
#import "SimpleRESTRequest.h"

@implementation Request

@synthesize delegate;
@synthesize active;

#pragma mark - instance methods

- (void) startWithSearchTerm: (NSString *) searchTerm
{
    // Implement in subclass
}

- (void) stop
{
    // Implement in subclass
}

@end
