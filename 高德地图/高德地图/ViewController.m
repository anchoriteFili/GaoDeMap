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

@property (nonatomic,assign) BOOL isJiaoTong; //判断是否显示实时交通

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mapView.delegate = self;
    
    //后台定位
    self.mapView.pausesLocationUpdatesAutomatically = NO;
    self.mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
    
    /**
     MAUserTrackingModeNone：仅在地图上显示，不跟随用户位置。
     MAUserTrackingModeFollow：跟随用户位置移动，并将定位点设置成地图中心点。
     MAUserTrackingModeFollowWithHeading：跟随用户的位置和角度移动。
     */
//    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
    
    
    
}

#pragma mark 页面已经显示
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.mapView.showsUserLocation = YES; //开启定位
    
    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading; //跟随用户的位置和角度移动
    
    [self.mapView setZoomLevel:16.1 animated:YES];
    
}

#pragma mark 是否显示实时交通图
- (IBAction)jiaoTongButtonClick:(UIButton *)sender {
    
    self.isJiaoTong = !self.isJiaoTong;
    self.mapView.showTraffic = self.isJiaoTong;
}

#pragma mark 地图类型
- (IBAction)mapType:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"普通地图"]) {
        
        self.mapView.mapType = MAMapTypeStandard;
    } else {
        
        self.mapView.mapType = MAMapTypeSatellite;
    }
    
}


#pragma mark 自定义定位标注和精度圈儿的样式
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
        
        //定位点处标注
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        pre.image = [UIImage imageNamed:@"location.png"];
        pre.lineWidth = 3;
        pre.lineDashPattern = @[@6, @3];
        
        [self.mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
    } 
}


#pragma mark 当文职更新是你，会进行定位回调，通过回调函数，能获取到定位点的经纬度坐标
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"纬度 : %f,经度: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
