//
//  LightEnvironment.swift
//  BLELightSampler
//
//  Created by Wataru Fujiwara on 2025/08/13.
//

import Foundation

public struct LightEnvironment {
  public var bleClient: BLEClient
  
  public init(bleClient: BLEClient) {
    self.bleClient = bleClient
  }
}
