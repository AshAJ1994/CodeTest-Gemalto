//
//  ViewController.m
//  Vidzeeeee
//
//  Created by Alli on 6/3/19.
//  Copyright © 2019 Alli. All rights reserved.
//

#define API_key "2890e8790acb886380376be2ab281a35"

#import "ViewController.h"
//#import "Sorting.h"
//#import "libSortingStaticLibrary.a"
//#import "libStaticLibrary.a"
#import "gemaltoStaticLibrary.h"
#import "MovieTableViewCell.h"
#import "KeychainItemWrapper.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate>
{
    NSDictionary *responseJsonDict;
    NSString *movieTitle;
    NSDate *releaseDate;
    NSDateFormatter *dateFormatter;
    NSArray *movies;
    NSArray *sortedMoviesList;
    float movieRating;
    NSSortDescriptor *ratingDescriptor;
    __weak IBOutlet UISearchBar *searchBar;
    __weak IBOutlet UITableView *movieListTableView;
    MovieTableViewCell *movieCell;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self fetchMovies:@"https://api.themoviedb.org/3/movie/550?api_key=2890e8790acb886380376be2ab281a35"];
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"API_Key" accessGroup:nil];
//    [keychainItem setObject:@"2890e8790acb886380376be2ab281a35" forKey:kSecValueRef];
    
    movieListTableView.delegate = self;
    movieListTableView.dataSource = self;
    [movieListTableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"cell"];
    movieCell.title.text = @"Movie Title";
    searchBar.delegate = self;
    searchBar.placeholder = @"Enter your favourite movie title here";
    searchBar.barTintColor = [UIColor blackColor];
    searchBar.enablesReturnKeyAutomatically = false;
    checkBubbleSort();
}

- (void)fetchMovies:(NSString *)apiUrl {
    
    NSURL *baseURL = [NSURL URLWithString:apiUrl];
    NSLog(@"%@", baseURL);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:baseURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpresponse = (NSHTTPURLResponse *)response;
        NSInteger statusCode = [httpresponse statusCode];
        NSError *parseError = nil;
        if (statusCode == 200)
        {
            self->responseJsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            self->movies = self->responseJsonDict[@"results"];
//            self->movieTitle = self->responseJsonDict[@"title"];
//            self->releaseDate = self->responseJsonDict[@"release_date"];
//            self->dateFormatter.dateFormat = @"yyyy-MM-dd";
//            self->movieRating = [self->responseJsonDict[@"vote_average"] floatValue];
            self->ratingDescriptor = [[NSSortDescriptor alloc] initWithKey:@"vote_average" ascending:false];
            self->sortedMoviesList = [self->movies sortedArrayUsingDescriptors:[NSArray arrayWithObject:self->ratingDescriptor]];
        }
        else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Authorizaton unsuccessful" preferredStyle:UIAlertControllerStyleAlert];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
        }
    }] resume];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (sortedMoviesList.count > 0) {
        movieCell = (MovieTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"movieCell"];
        NSDictionary *dict = [sortedMoviesList objectAtIndex:indexPath.row];
        movieCell.title.text = dict[@"original_title"];
        movieCell.rating.text = [NSString stringWithFormat:@"%@",dict[@"vote_average"]];
        return movieCell;
    }
    return nil;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (sortedMoviesList.count > 0) {
        return sortedMoviesList.count;
    }
    else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (sortedMoviesList.count > 0) {
        return UITableViewAutomaticDimension;
    }
    return 0;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length > 0) {
        NSString *searchUrl = [NSString stringWithFormat: @"https://api.themoviedb.org/3/search/movie?api_key=%s&query=%@&&primary_release_year=%d&language=en-US",API_key,searchText,2017];
        //    NSString *discoverUrl = [NSString stringWithFormat:@"https://api.themoviedb.org/3/discover/movie?api_key=2890e8790acb886380376be2ab281a35&language=en-US&sort_by=vote_average.desc&include_adult=false&include_video=false&page=1&primary_release_date.gte=2017-01-10&primary_release_date.lte=2018-10-25"];
        [self fetchMovies:searchUrl];
        [movieListTableView reloadData];
        //    [self fetchMovies:discoverUrl];
        NSLog(@"query called %@", searchBar.text);
    }
    else {
        sortedMoviesList = @[];
        [movieListTableView reloadData];
    }
}

@end
