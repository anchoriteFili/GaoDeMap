//
//  ViewController.m
//  高德地图
//
//  Created by 赵宏亚 on 16/5/17.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate>


@property (weak, nonatomic) IBOutlet MAMapView *mapView; //地图view

@property (nonatomic,assign) BOOL isJiaoTong; //判断是否显示实时交通
@property (nonatomic,assign) BOOL isDingWei; //判断是否开启定位
@property (nonatomic,retain) AMapLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [MAMapServices sharedServices].apiKey = APIKEY;
    [AMapSearchServices sharedServices].apiKey = APIKEY;
    [AMapLocationServices sharedServices].apiKey = APIKEY;
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES; //开启定位
         //后台定位
    self.mapView.pausesLocationUpdatesAutomatically = NO;
    self.mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
    
    [self.mapView addObserver:self forKeyPath:@"showsUserLocation" options:NSKeyValueObservingOptionNew context:nil];
    
    
}

#pragma mark 页面已经显示
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading; //跟随用户的位置和角度移动
    [self.mapView setZoomLevel:16.1 animated:YES];
    
    /**
     MAUserTrackingModeNone：仅在地图上显示，不跟随用户位置。
     MAUserTrackingModeFollow：跟随用户位置移动，并将定位点设置成地图中心点。
     MAUserTrackingModeFollowWithHeading：跟随用户的位置和角度移动。
     */
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
    
#pragma mark 添加大头针
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
    pointAnnotation.title = @"方恒国际";
    pointAnnotation.subtitle = @"阜通东大街6号";
    
    [self.mapView addAnnotation:pointAnnotation];
    
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
    
    NSLog(@"设置定位圈儿");
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

#pragma mark 大头针代理方法
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
//    if ([annotation isKindOfClass:[MAPointAnnotation class]])
//    {
//        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
//        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
//        }
//        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
//        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
//        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
//        annotationView.pinColor = MAPinAnnotationColorPurple;
//        
//        return annotationView;
//    }
    
    //自定义标注样式
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"location"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    
    return nil;
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
}

#pragma mark 点击定位按钮
- (IBAction)dingWeiButtonClick:(UIButton *)sender {
    
    self.isDingWei = !self.isDingWei;
    
    if (self.isDingWei) {
        //停止定位
        [self.locationManager stopUpdatingLocation];
        [sender setTitle:@"开" forState:UIControlStateNormal];
    } else {
        
        [sender setTitle:@"关" forState:UIControlStateNormal];
        //开始定位
        [self.locationManager startUpdatingLocation];
    }
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    //定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [self.mapView removeObserver:self forKeyPath:@"showsUserLocation"];
}






@end
