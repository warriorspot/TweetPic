
#import "MovieRequest.h"
#import "SimpleRESTRequest.h"

@implementation MovieRequest

@synthesize active;
@synthesize request;

- (id) init
{
    self = [super init];
    if(self)
    {
        request = [[SimpleRESTRequest alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(requestFailed:) 
                                                     name:SimpleRESTRequestDidFailNotification 
                                                   object:self.request];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(requestSucceeded:) 
                                                     name:SimpleRESTRequestDidSucceedNotification 
                                                   object:self.request];
    }
    
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - instance methods

- (BOOL) isActive
{
    return request.running;
}

- (void) start
{
    [request start];
}

- (void) stop
{
    [request stop];
}

#pragma mark - private methods

- (void) requestFailed: (NSNotification *) notification
{
    
}

- (void) requestSucceeded: (NSNotification *) notification
{
    
}

@end
