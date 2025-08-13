//
//  LightPlainView.swift
//  BLELightSampler
//
//  Created by Wataru Fujiwara on 2025/08/13.
//

import SwiftUI

struct LightPlainView: View {
  @Bindable var model: LightPlainModel

  init(model: LightPlainModel) { self.model = model }

  var body: some View {
    VStack(spacing: 16) {
      if model.connectedDevice == nil {
        Text("Select a BLE Device").font(.headline)
        List(model.discoveredDevices) { device in
          Button(device.name) {
            model.select(device)
          }
        }
      } else {
        Text("Connected: \(model.connectedDevice?.name ?? "-")").font(.headline)

        Slider(
          value: .init(
            get: { model.brightness },
            set: { model.setBrightness($0) }
          ),
          in: 0...1
        )
        Text("Brightness: \(Int(model.brightness * 100))%")
      }

      if model.isLoading { ProgressView() }
      if let e = model.errorMessage { Text(e).foregroundColor(.red) }
    }
    .padding()
    .onAppear { model.onAppear() }
  }
}
