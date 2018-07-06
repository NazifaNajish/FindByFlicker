//
//  ViewController.h
//  FindByFlicker
//
//  Created by Nazifa Najish on 7/5/18.
//  Copyright © 2018 Nazifa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *theCollectionView;
@property (weak, nonatomic) IBOutlet UITextField *queryTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicatior;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
- (IBAction)SearchAction:(UIButton *)sender;


@end

