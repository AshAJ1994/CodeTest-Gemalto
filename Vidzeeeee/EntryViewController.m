//
//  EntryViewController.m
//  Vidzeeeee
//
//  Created by Alli on 12/3/19.
//  Copyright © 2019 Alli. All rights reserved.
//

#import "EntryViewController.h"
#import "SearchViewController.h"
@interface EntryViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFiled;

@end

@implementation EntryViewController {
    
    NSString *textEntered;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFiled.delegate = self;
    // Do any additional setup after loading the view.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    [self performSegueWithIdentifier:@"apiKeyEntered" sender:self];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"apiKeyEntered"])
    {
        SearchViewController *movieSearchVC = [segue destinationViewController];
        movieSearchVC.apiKey = self.textFiled.text;
    }
}

@end
