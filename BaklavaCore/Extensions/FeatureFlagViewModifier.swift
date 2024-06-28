//
//  FeatureFlagViewModifier.swift
//
//
//  Created by Baris Cem Baykara on 28.06.2024.
//

import SwiftUI

/// A view modifier that checks whether a flag is enabled or not
public struct FeatureFlagViewModifier: ViewModifier {
    
    var flag: any FeatureFlag
   
    public func body(content: Content) -> some View {
        if flag.enabled {
            content
        }
    }
}

extension View {
    
    /// Checks whether the feature flag is enabled.
    /// If not, the view will not be displayed.
    func checkFlag(_ flag: any FeatureFlag) -> some View {
        modifier(FeatureFlagViewModifier(flag: flag))
    }
}
