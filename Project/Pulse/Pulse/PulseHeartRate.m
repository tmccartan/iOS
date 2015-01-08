
//
//  PulseHeartRate.m
//  Pulse
//
//  Created by CSIADMIN on 15/03/2014.
//  Copyright (c) 2014 ie.ucd.csi.comp41550. All rights reserved.
//

#import "PulseHeartRate.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface PulseHeartRate () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) NSTimer *timer;
@property  NSInteger bpm;
@property (nonatomic)  BOOL isRunningInSimulator;
@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@end


@implementation PulseHeartRate

-(BOOL)isRunningInSimulator{

    // change this to 0 if using IPHONE and POLAR H7 BLE device
    return 1;
}

-(void) startHeartRateCapture{
    
    if(self.isRunningInSimulator)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector: @selector(receiveHeartBeat) userInfo:Nil repeats:YES];
    }
    else
    {
        self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        [self startScan];

    }

}
-(void) stopHeartRateCapture{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector: @selector(receiveHeartBeat) userInfo:Nil repeats:YES];
    
}
-(void) receiveHeartBeat{
    
    self.bpm = 80 + arc4random() % (180 - 80 + 1);
    [self fireHeartBeat: self.bpm];
    
}
-(void) fireHeartBeat:(NSInteger) bpm
{
   [self.delegate heartBeat:bpm ];
}
- (void) updateWithHRMData:(NSData *)data
{
    const uint8_t *reportData = [data bytes];
    uint16_t bpm = 0;
    
    if ((reportData[0] & 0x01) == 0) {
        // uint8 bpm
        bpm = reportData[1];
    }
    NSLog(@"bpm %d", bpm);
    [self fireHeartBeat:bpm];
}
- (void) startScan
{
    [self.manager scanForPeripheralsWithServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"180D"]] options:nil];
}
- (void) stopScan
{
    [self.manager stopScan];
}

- (BOOL) isLECapableHardware
{
    NSString * state = nil;
    switch ([self.manager state]) {
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            return TRUE;
        case CBCentralManagerStateUnknown:
        default:
            return FALSE;
    }
    NSLog(@"Central manager state: %@", state);
    return FALSE;
}
#pragma mark - CBCentralManager delegate methods
- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    [self isLECapableHardware];
}

- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)aPeripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    self.peripheral = aPeripheral;
    self.peripheral.delegate = self;
    [self.manager connectPeripheral:self.peripheral options:nil];
}
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"Retrieved peripheral: %lu - %@", (unsigned long)[peripherals count], peripherals);
    [self stopScan];
    // If there are any known devices, automatically connect to it.
    if(peripherals.count >0)
    {
        self.peripheral = [peripherals objectAtIndex:0];
        [self.manager connectPeripheral:self.peripheral
        options:[NSDictionary dictionaryWithObject:
         [NSNumber numberWithBool:YES]
                                    forKey:
         CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    }
}

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)aPeripheral
{
    NSLog(@"connected");
    [aPeripheral setDelegate:self];
    [aPeripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
}
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
}
#pragma mark - CBPeripheral delegate methods

- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error

{
    for (CBService *aService in aPeripheral.services) {
        NSLog(@"Service found with UUID: %@", aService.UUID);
        
        /* Heart Rate Service */
        if ([aService.UUID isEqual:[CBUUID UUIDWithString:@"180D"]]) {
            [aPeripheral discoverCharacteristics:nil forService:aService];
        }
    }

}
- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180D"]]) {
        for (CBCharacteristic *aChar in service.characteristics) {
            // Set notification on heart rate measurement
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A37"]]) {
                [self.peripheral setNotifyValue:YES forCharacteristic:aChar];
                NSLog(@"Found a Heart Rate Measurement Characteristic");
            }
        }
    }

}
- (void) peripheral:(CBPeripheral *)aPeripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // Updated value for heart rate measurement received
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A37"]]) {
        if(characteristic.value || !error) {
            NSLog(@"received value: %@", characteristic.value);
            // Update UI with heart rate data
            [self updateWithHRMData:characteristic.value];
        }
    }
}
@end
