//
//  LightReducer.swift
//  BLELightSampler
//
//  Created by Wataru Fujiwara on 2025/08/13.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct LightFeature {
  @ObservableState
  public struct State: Equatable {
    public var discoveredDevices: [BLEDevice] = []
    public var connectedDevice: BLEDevice?
    public var brightness: Double = 0.5
    public var isLoading = false
    public var errorMessage: String?
    
    public init() {}
  }
  
  public enum Action: Equatable {
    case onAppear
    case scanDevices
    case devicesDiscovered([BLEDevice])
    case selectDevice(BLEDevice)
    case setBrightness(Double)
    case bleUpdate(Result<Double, BLEError>)
  }
  
  @Dependency(\.bleClient) var bleClient
  
  public init() {}
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .send(.scanDevices)
      
    case .scanDevices:
      state.isLoading = true
      return .run { send in
        let devices = await bleClient.scanDevices()
        await send(.devicesDiscovered(devices))
      }
      
    case .devicesDiscovered(let devices):
      state.discoveredDevices = devices
      state.isLoading = false
      return .none
      
    case .selectDevice(let device):
      state.connectedDevice = device
      state.isLoading = true
      return .run { send in
        do {
          try await bleClient.connect(device)
          let b = await bleClient.getBrightness()
          await send(.bleUpdate(.success(b)))
        } catch {
          await send(.bleUpdate(.failure(.unknown)))
        }
      }
      
    case .setBrightness(let value):
      state.brightness = value
      state.isLoading = true
      return .run { send in
        do {
          try await bleClient.setBrightness(value)
          await send(.bleUpdate(.success(value)))
        } catch {
          await send(.bleUpdate(.failure(.unknown)))
        }
      }
      
    case .bleUpdate(let result):
      state.isLoading = false
      switch result {
      case .success(let b):
        state.brightness = b
        state.errorMessage = nil
      case .failure:
        state.errorMessage = "Failed to update."
      }
      return .none
    }
  }
}
