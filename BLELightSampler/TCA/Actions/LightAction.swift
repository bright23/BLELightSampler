//
//  LightAction.swift
//  BLELightSampler
//
//  Created by Wataru Fujiwara on 2025/08/13.
//

import Foundation

public enum LightAction: Equatable {
  case onAppear
  case scanDevices
  case selectDevice(BLEDevice)
  case setBrightness(Double)
  case bleUpdate(Result<Double, BLEError>)
  case devicesDiscovered([BLEDevice])
  case disconnectTapped
}
