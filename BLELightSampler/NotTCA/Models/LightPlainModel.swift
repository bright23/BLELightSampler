//
//  LightPlainModel.swift
//  BLELightSampler
//
//  Created by Wataru Fujiwara on 2025/08/13.
//

import Observation
import Dependencies
import Foundation

@Observable
final class LightPlainModel {
  @ObservationIgnored @Dependency(\.bleClient) private var ble

  var discoveredDevices: [BLEDevice] = []
  var connectedDevice: BLEDevice?
  var brightness: Double = 0.5
  var isLoading = false
  var errorMessage: String?

  func onAppear() {
    Task { await scan() }
  }

  func scan() async {
    isLoading = true
    let devices = await ble.scanDevices()
    discoveredDevices = devices
    isLoading = false
  }

  func select(_ device: BLEDevice) {
    connectedDevice = device
    isLoading = true
    Task {
      do {
        try await ble.connect(device)
        let b = await ble.getBrightness()
        await MainActor.run {
          self.brightness = b
          self.isLoading = false
          self.errorMessage = nil
        }
      } catch {
        await MainActor.run {
          self.isLoading = false
          self.errorMessage = "Failed to connect."
        }
      }
    }
  }

  func setBrightness(_ value: Double) {
    brightness = value
    isLoading = true
    Task {
      do {
        try await ble.setBrightness(value)
        await MainActor.run {
          self.isLoading = false
          self.errorMessage = nil
        }
      } catch {
        await MainActor.run {
          self.isLoading = false
          self.errorMessage = "Failed to update."
        }
      }
    }
  }
}
