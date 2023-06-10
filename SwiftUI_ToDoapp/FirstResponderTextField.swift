//
//  FirstResponderTextField.swift
//  SwiftUI_ToDoapp
//
//  Created by 福原雅隆 on 2023/03/19.
//

import SwiftUI

struct FirstResponderTextField: UIViewRepresentable {
    @Binding var text: String
    var onCommit: (() -> Void)?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        if context.coordinator.didBecomeFirstResponder == false {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: FirstResponderTextField
        var didBecomeFirstResponder = false

        init(_ parent: FirstResponderTextField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            parent.onCommit?()
            return true
        }
    }
}

