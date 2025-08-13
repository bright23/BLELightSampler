//
//  LightView.swift
//  BLELightSampler
//
//  Created by Wataru Fujiwara on 2025/08/13.
//

import SwiftUI
import ComposableArchitecture

public struct LightView: View {
  let store: StoreOf<LightFeature>
  
  public init(store: StoreOf<LightFeature>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 16) {
        if viewStore.connectedDevice == nil {
          Text("Select a BLE Device").font(.headline)
          List(viewStore.discoveredDevices) { device in
            Button(device.name) {
              viewStore.send(.selectDevice(device))
            }
          }
        } else {
          Text("Connected: \(viewStore.connectedDevice?.name ?? "-")").font(.headline)
          Slider(
            value: viewStore.binding(
              get: \.brightness,
              send: { .setBrightness($0) }
            ),
            in: 0...1
          )
          Text("Brightness: \(Int(viewStore.brightness * 100))%")
        }
        
        if viewStore.isLoading {
          ProgressView()
        }
        
        if let e = viewStore.errorMessage {
          Text(e).foregroundColor(.red)
        }
      }
      .padding()
      .onAppear { viewStore.send(.onAppear) }
    }
  }
}


//#Preview {
//  LightView()
//}
