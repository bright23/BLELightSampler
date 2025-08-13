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
    NavigationStack {
      WithViewStore(store, observe: { $0 }) { viewStore in
        VStack(spacing: 16) {
          if viewStore.connectedDevice == nil {
            // —— デバイス一覧 —— //
            Text("Select a BLE Device")
              .font(.headline)
            
            List(viewStore.discoveredDevices) { device in
              Button(device.name) {
                viewStore.send(.selectDevice(device))
              }
            }
            
          } else {
            // —— スライダー画面 —— //
            Text("Connected: \(viewStore.connectedDevice?.name ?? "-")")
              .font(.headline)
            
            // 電球アイコン（明るさで色と発光を変える）
            let b = viewStore.brightness // 0...1
            // 暖色で明るさに応じて輝度と発光を変化
            let bulbColor = Color(hue: 0.13, saturation: 0.85, brightness: 0.25 + 0.75 * b)
            
            ZStack {
              Image(systemName: "lightbulb.fill")
                .font(.system(size: 120, weight: .regular))
                .foregroundStyle(bulbColor)
                .shadow(color: bulbColor.opacity(0.6 * b), radius: 30 * b, x: 0, y: 0)
                .padding(.bottom, 8)
              
              // ほんのり周囲が光る演出
              Circle()
                .fill(bulbColor.opacity(0.15 * b))
                .frame(width: 200 + 80 * b, height: 200 + 80 * b)
                .blur(radius: 20)
            }
            .frame(height: 220)
            
            // 明るさスライダー
            Slider(
              value: viewStore.binding(
                get: \.brightness,
                send: { .setBrightness($0) }
              ),
              in: 0...1
            )
            Text("Brightness: \(Int(viewStore.brightness * 100))%")
              .monospacedDigit()
          }
          
          if viewStore.isLoading {
            ProgressView()
          }
          
          if let e = viewStore.errorMessage {
            Text(e).foregroundColor(.red)
          }
        }
        .padding()
        .navigationTitle(viewStore.connectedDevice == nil ? "BLE Devices" : "Brightness")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          if viewStore.connectedDevice != nil {
            ToolbarItem(placement: .topBarLeading) {
              Button {
                viewStore.send(.disconnectTapped)
              } label: {
                Label("Back", systemImage: "chevron.left")
              }
            }
          } else {
            ToolbarItem(placement: .topBarTrailing) {
              Button {
                viewStore.send(.scanDevices)
              } label: {
                Image(systemName: "arrow.clockwise")
              }
              .accessibilityLabel("Rescan")
            }
          }
        }
        .onAppear { viewStore.send(.onAppear) }
      }
    }
  }
}


//#Preview {
//  LightView()
//}
