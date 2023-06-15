//
//  UIViewPreview.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.06.2023.
//

import SwiftUI

struct UIViewPreview: UIViewRepresentable {
    
    private let view: UIView
    
    init(_ view: UIView) {
        self.view = view
    }

    // MARK: - UIViewRepresentable
    
    func makeUIView(context: Context) -> UIViewType {
        return self.view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
