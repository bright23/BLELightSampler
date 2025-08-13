//
//  ContentView.swift
//  BLELightSampler
//
//  Created by Wataru Fujiwara on 2025/08/13.
//
// TCAと非TCAの比較

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
  var body: some View {
    TabView {
      // TCA 版
      LightView(
        store: Store(
          initialState: LightFeature.State(),
          reducer: { LightFeature() }   // 1.21系の @Reducer でOK（Dependencies注入）
        )
        // 依存を差し替える場合は .withDependencies を使う
        //.withDependencies {
        //  $0.bleClient = .mock
        //}
      )
      .tabItem { Label("TCA", systemImage: "puzzlepiece.extension") }

      // 非TCA（Observation）版
      LightPlainView(model: LightPlainModel())
        .tabItem { Label("Plain", systemImage: "square.grid.2x2") }
    }
  }
}
