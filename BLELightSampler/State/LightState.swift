//
//  LightState.swift
//  BLELightSampler
//
//  Created by Wataru Fujiwara on 2025/08/13.
//

import Foundation

public struct LightState: Equatable {
  public var discoveredDevices: [BLEDevice] = []
  public var connectedDevice: BLEDevice?
  public var brightness: Double = 0.5
  public var isLoading: Bool = false
  public var errorMessage: String?
  
  public init() {}
}
