//
//  ViewController.m
//  高德地图
//
//  Created by 赵宏亚 on 16/5/17.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<MAMapViewDelegate>


@property (weak, nonatomic) IBOutlet MAMapView *mapView; //地图view



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mapView.delegate = self;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
