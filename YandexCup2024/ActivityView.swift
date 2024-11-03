//
//  ActivityView.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 03.11.2024.
//

import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]
    var excludedActivityTypes: [UIActivity.ActivityType]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems as [AnyObject],
            applicationActivities: nil
        )

        controller.excludedActivityTypes = excludedActivityTypes

        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {
        
    }
}
