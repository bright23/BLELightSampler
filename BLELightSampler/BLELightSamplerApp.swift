//
//  BLELightSamplerApp.swift
//  BLELightSampler
//
//  Created by Wataru Fujiwara on 2025/08/13.
//

import SwiftUI
import ComposableArchitecture

@main
struct BLELightSamplerApp: App {
  var body: some Scene {
    WindowGroup {
      LightView(
        store: Store(
          initialState: LightFeature.State(),
          reducer: { LightFeature() }   // ← ここが重要（クロージャで渡す）
        )
        // 依存を差し替える場合は .withDependencies を使う
        //.withDependencies {
        //  $0.bleClient = .mock
        //}
      )
    }
  }
}
