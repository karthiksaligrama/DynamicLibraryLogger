//
//  CRViewController.m
//  LoggerExample
//
//  Created on 8/12/14.
//
//

#import "CRViewController.h"
#import "CRSecondViewController.h"

@interface CRViewController (){
    UIButton *segueToSecondScreen;
}
@end

@implementation CRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"First Screen";
    
    segueToSecondScreen = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [segueToSecondScreen setTitle:@"Next Screen" forState:UIControlStateNormal];
    [segueToSecondScreen addTarget:self action:@selector(nextScreen) forControlEvents:UIControlEventTouchUpInside];
    
    [segueToSecondScreen sizeToFit];
    
    CGRect frame = segueToSecondScreen.frame;
    frame.origin.x = self.view.bounds.size.width/2-frame.size.width/2;
    frame.origin.y =self.view.bounds.size.height/2-frame.size.height/2;
    segueToSecondScreen.frame = frame;
    [self.view addSubview:segueToSecondScreen];
}

-(void)nextScreen{
    CRSecondViewController *vc = [[CRSecondViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
