//
//  PikachuIcon.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/09.
//

import SwiftUI

struct PikachuIcon: View {
    var body: some View {
        Image("pikachu")
            .resizable()
            .scaledToFit()
            .frame(width: 56)
            .padding(.all, 4)
            .background(Circle().fill(.black))
    }
}
