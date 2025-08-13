//
//  BLEDevice.swift
//  BLELightSampler
//
//  Created by Wataru Fujiwara on 2025/08/13.
//

import Foundation

public struct BLEDevice: Equatable, Identifiable {
  public let id: UUID
  public let name: String
  public init(id: UUID = UUID(), name: String) {
    self.id = id
    self.name = name
  }
}
