//
//  ViewController.m
//  FindByFlicker
//
//  Created by Nazifa Najish on 7/5/18.
//  Copyright © 2018 Nazifa. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCell.h"
#import "PhotoAPI.h"
#import "Photo.h"
#import "CacheImage.h"
#import "Reachability.h"

const int MAX_NUMBER_OF_COLUMNS = 3;

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UITextFieldDelegate> {
    PhotoAPI* photoAPI;
    
    NSString *flickrRestServiceUrl;
    NSString *flickrPhotoUrlFormat;
    NSMutableArray *photoList;
    
    int currentPageNo;
    BOOL loadingPhotos;
    
    CGRect screenRect;
}

@end

@implementation ViewController
@synthesize theCollectionView, queryTextField, loadingIndicatior, alertLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self initialization];
    [self UISetup];
    
    // To check internet connection
    [self performSelector:@selector(checkInternetConnection) withObject:nil afterDelay:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Initialization & UI Setup
/*!
 * @discussion Initializes values first time
 */
-(void)initialization {
    
    // Set Delegates
    theCollectionView.delegate = self;
    queryTextField.delegate = self;
    
    // Initialize
    photoAPI = [[PhotoAPI alloc] init];
    photoList = [[NSMutableArray alloc] init];

    flickrRestServiceUrl = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FlickrRestServiceUrl"];
    flickrPhotoUrlFormat = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FlickrPhotoUrlFormat"];
    
    currentPageNo = 1;
    loadingPhotos = NO;
    
    screenRect = [[UIScreen mainScreen] bounds];
}

/*!
 * @discussion Initializes UI status first time
 */
-(void)UISetup{
    
    [loadingIndicatior stopAnimating];
    alertLabel.hidden = YES;
}

#pragma mark - Service Call
/*!
 * @discussion Service call to get photo from flickr
 * @param query entered by user
 */
- (void)getPhotos:(NSString*)query {
    
    // queries photos by specified text
    [loadingIndicatior startAnimating];
    
    loadingPhotos = YES;
    [photoAPI photosByQuery:^(NSArray *photos) {
        
        [self->loadingIndicatior stopAnimating];
        
        if (photos.count > 0) {
            
            if (self->currentPageNo == 1) {
                
                [self->photoList addObjectsFromArray:photos];
                [self.theCollectionView reloadData];
            
            } else {
                
                [self->photoList addObjectsFromArray:photos];
                [self.theCollectionView reloadData];
            }
            
            self->currentPageNo++;
        }
        self->loadingPhotos = NO;
        
    } failure:^(NSError *error) {
        
        self->loadingPhotos = NO;
        [self->loadingIndicatior stopAnimating];
        
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Error"
                                    message:error.localizedDescription
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:nil];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } textQuery:query page:currentPageNo];
        
}

/*!
 * @discussion check Internet Connection
 */
- (void)checkInternetConnection {
    
    Reachability *reach = [Reachability reachabilityWithHostname:flickrRestServiceUrl];
    // service is available
    reach.reachableBlock = ^(Reachability *reach) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self->alertLabel.hidden = YES;
        });
        
    };
    // service is unavailable
    reach.unreachableBlock = ^(Reachability*reach) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self->alertLabel.hidden = NO;
        });
        
    };
    [reach startNotifier];
}


#pragma mark - Search Action
- (IBAction)SearchAction:(UIButton *)sender {
    [self performPhotoSearch];
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self performPhotoSearch];
    return YES;
}

/*!
 * @discussion Initiates search operation
 */
-(void)performPhotoSearch {
    
    [queryTextField resignFirstResponder];
    if (queryTextField.text != nil && ![queryTextField.text isEqualToString:@""]) {
        
        // Reset
        photoList = [[NSMutableArray alloc] init];
        [self.theCollectionView reloadData];
        
        // Fetch data
        [self getPhotos:[queryTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return photoList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat itemWidth = (CGRectGetWidth(collectionView.frame) - MAX_NUMBER_OF_COLUMNS) / MAX_NUMBER_OF_COLUMNS;
    return CGSizeMake(itemWidth, itemWidth);
}

- (PhotoCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ImageCell";
    PhotoCell *cell = [theCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
    Photo *photo = [photoList objectAtIndex:indexPath.row];
    
    NSString *photoUrl = [NSString stringWithFormat:flickrPhotoUrlFormat, photo.farm, photo.server, photo.id, photo.secret, @"_q"];
    
    cell.photoView.image = nil;
    
    // checking for a cached version of the image to list
    [CacheImage loadImage:photoUrl complete:^(UIImage *image) {
        cell.photoView.image = image;
    }];
    
    // return the cell
    return cell;
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.theCollectionView) {
        
        float scrollViewHeight = scrollView.frame.size.height;
        float scrollContentSizeHeight = scrollView.contentSize.height;
        float scrollOffset = scrollView.contentOffset.y;
        
        if (scrollOffset == 0) {
            // then we are at the top
        }
        else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight && photoList.count > 10) {
            // then we are at the end
            [self getPhotos:[queryTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]  ];
        }
        
    }
}
@end
