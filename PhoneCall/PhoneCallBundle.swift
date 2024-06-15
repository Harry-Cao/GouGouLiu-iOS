//
//  PhoneCallBundle.swift
//  PhoneCall
//
//  Created by HarryCao on 2024/6/14.
//

import WidgetKit
import SwiftUI

@main
struct PhoneCallBundle: WidgetBundle {
    var body: some Widget {
        PhoneCall()
        PhoneCallLiveActivity()
    }
}
