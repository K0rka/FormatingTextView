//
//  ViewController.m
//  LJPostCreate
//
//  Created by Korovkina Ekaterina on 08.05.15.
//  Copyright (c) 2015 Korovkina Ekaterina. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>



@interface ViewController () <UITextViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *editTextView;
@property (nonatomic, strong)  CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self restorePostIfExist];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)restorePostIfExist
{
    [self.editTextView setText:nil];
}

#pragma mark - UITextView Delegate




@end
