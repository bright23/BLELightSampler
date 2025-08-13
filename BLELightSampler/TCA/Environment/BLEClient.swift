//
//  BLEClient.swift
//  BLELightSampler
//
//  Created by Wataru Fujiwara on 2025/08/13.
//
// Mock BLE + 将来CoreBluetoothに置き換え可能

import Dependencies
import Foundation

public struct BLEClient {
  public var scanDevices: @Sendable () async -> [BLEDevice]
  public var connect: @Sendable (_ device: BLEDevice) async throws -> Void
  public var getBrightness: @Sendable () async -> Double
  public var setBrightness: @Sendable (_ value: Double) async throws -> Void

  public init(
    scanDevices: @escaping @Sendable () async -> [BLEDevice],
    connect: @escaping @Sendable (BLEDevice) async throws -> Void,
    getBrightness: @escaping @Sendable () async -> Double,
    setBrightness: @escaping @Sendable (Double) async throws -> Void
  ) {
    self.scanDevices = scanDevices
    self.connect = connect
    self.getBrightness = getBrightness
    self.setBrightness = setBrightness
  }
}

// 依存キー
private enum BLEClientKey: DependencyKey {
  static let liveValue = BLEClient.mock    // とりあえず mock を既定に
  static let testValue = BLEClient.mock
}

public extension DependencyValues {
  var bleClient: BLEClient {
    get { self[BLEClientKey.self] }
    set { self[BLEClientKey.self] = newValue }
  }
}

// 簡単なモック実装
public extension BLEClient {
  static let mock = BLEClient(
    scanDevices: {
      try? await Task.sleep(nanoseconds: 300_000_000)
      return [
        .init(id: UUID(), name: "Living Room Light"),
        .init(id: UUID(), name: "Desk Lamp")
      ]
    },
    connect: { _ in
      try? await Task.sleep(nanoseconds: 200_000_000)
    },
    getBrightness: {
      0.5
    },
    setBrightness: { _ in
      try? await Task.sleep(nanoseconds: 150_000_000)
    }
  )
}
