//
//  MovieTableViewCell.h
//  Vidzeeeee
//
//  Created by Alli on 11/3/19.
//  Copyright © 2019 Alli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *rating;

@end

NS_ASSUME_NONNULL_END
