
#import "Movie.h"
#import "MovieRequest.h"
#import "SimpleRESTRequest.h"

/// Private interface.
///
@interface MovieRequest()

/// The SimpleRESTRequest used to perform the actual request.
@property (nonatomic, strong) SimpleRESTRequest *request;

@end


@implementation MovieRequest

@synthesize active;
@synthesize request;

- (id) init
{
    self = [super init];
    if(self)
    {
        self.request = [[SimpleRESTRequest alloc] init];
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

- (void) startWithSearchTerm: (NSString *) searchTerm
{
    NSString *term = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *apiKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"RottenTomatoesAPIKey"];
    NSString *baseURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"RottenTomatoesBaseURL"];
    NSMutableString *targetPath = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"RottenTomatoesPath"];
    
    self.request.baseURL = baseURL;
    self.request.targetURL = [NSString stringWithFormat: targetPath, apiKey, term];
    
    [self.request start];
}

- (void) stop
{
    [self.request stop];
}

#pragma mark - private methods

- (NSArray *) moviesFromJSON: (NSDictionary *) json
{
    NSArray *moviesInJSON = [json valueForKey:@"movies"];
    NSMutableArray *movies = [NSMutableArray arrayWithCapacity:[moviesInJSON count]];
    
    for(NSDictionary *movie in moviesInJSON)
    {
        Movie *movieObject = [[Movie alloc] init];
        movieObject.title = [movie valueForKey:@"title"];
        NSDictionary *posters = [movie valueForKey:@"posters"];
        movieObject.imageURL = [NSURL URLWithString:[posters valueForKey:@"thumbnail"]];
        
        NSLog(@"%@", [movieObject description]);    
        
        [movies addObject:movieObject];
    }
    
    return movies;
}

- (void) requestFailed: (NSNotification *) notification
{
    NSLog(@"MovieRequest failed");
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(request:didFailWithError:)])
    {
        [self.delegate request:self didFailWithError:nil];
    }
}

- (void) requestSucceeded: (NSNotification *) notification
{
    NSLog(@"MovieRequest succeeded");
    
    NSDictionary *json = [notification.userInfo valueForKey:SimpleRESTRequestJSONKey];
    
    NSArray *movies = [self moviesFromJSON:json];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(request:didSucceedWithObject:)])
    {
        [self.delegate request:self didSucceedWithObject:movies];
    }
}

@end
