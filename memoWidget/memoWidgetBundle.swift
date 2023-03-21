//
//  memoWidgetBundle.swift
//  memoWidget
//
//  Created by 송민준 on 2023/03/17.
//

import WidgetKit
import SwiftUI

@main
struct memoWidgetBundle: WidgetBundle {
    var body: some Widget {
        memoWidget()
        memoWidgetLiveActivity()
    }
}
