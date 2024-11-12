//
//  PanelManager.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/03.
//

import SwiftUI

@Observable
class PanelManager {
    static let shared = PanelManager()
        
    static let iconWidth = 200.0
    static let panelSize = CGSize(width: 240, height: 520)
    
    static let screenWidth = NSScreen.main?.frame.size.width
    static let screenHeight = NSScreen.main?.frame.size.height
    static let auxiliaryTopAreaHeight = NSScreen.main?.auxiliaryTopLeftArea?.height
    
    private static let hiddenPoint = CGPoint(x: (screenWidth ?? 1500) + panelSize.width, y: (PanelManager.screenHeight ?? 1000) - panelSize.height)
    private static let showingPoint: CGPoint = CGPoint(x: (screenWidth ?? 1500) - panelSize.width, y: (PanelManager.screenHeight ?? 1000) - panelSize.height)

    
    private let edgeThreshold: CGFloat = 200
    
    private var panel: FloatingPanel = FloatingPanel(view: {
        PanelView()
    }, contentRect: NSRect(origin: hiddenPoint, size: panelSize))
    
    @ObservationIgnored var isHovering: Bool = false
    private var isShowing: Bool = false
    private let idolTime = 0.5
    
    private var localEventMonitor: Any?
    private var globalEventMonitor: Any?
    
    
    init() {
        NSApplication.shared.activate()
        panel.orderFront(nil)
        panel.makeKey()
        
        globalEventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { event in
            self.handleMouseMoved(event)
        }
        
        localEventMonitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
            self.handleMouseMoved(event)
            return event
        }
    }
    
    func disableMonitor() {
//        localEventMonitor?.invalidate()
//        globalEventMonitor?.invalidate()
        if let localEventMonitor, let globalEventMonitor {
            NSEvent.removeMonitor(localEventMonitor)
            NSEvent.removeMonitor(globalEventMonitor)
        }
    }
    
    func enableMonitor() {
        globalEventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { event in
            self.handleMouseMoved(event)
        }
        
        localEventMonitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
            self.handleMouseMoved(event)
            return event
        }
    }
 
    func showPanel() {
        self.isShowing = true
        panel.setFrame(NSRect(origin: Self.showingPoint, size: Self.panelSize), display: true, animate: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + idolTime, execute: {
            self.isShowing = false
            PasteboardManager.shared.showItemAdded = false
        })

    }
    
    func hidePanel() {
        if isHovering {
            return
        }
        PasteboardManager.shared.showItemAdded = false
        panel.setFrame(NSRect(origin: Self.hiddenPoint, size: Self.panelSize), display: true, animate: true)
    }
    
    
    private func handleMouseMoved(_ event: NSEvent) {
        if isShowing { return }
        var location = event.locationInWindow
        
        if isHovering {
            return
        }

        // convert event location to global coordinate if applicable, ie: when hovering in a window
        if let locationOnScreen = event.window?.convertPoint(toScreen: event.locationInWindow) {
            location = locationOnScreen
        }

        let xLocation = location.x
        let yLocation = location.y
        guard let screenWidth = Self.screenWidth, let screenHeight = Self.screenHeight, let auxiliaryTopAreaHeight = Self.auxiliaryTopAreaHeight else { return }
        if xLocation > screenWidth - edgeThreshold && yLocation > screenHeight - edgeThreshold - auxiliaryTopAreaHeight {
            self.showPanel()
        } else {
            hidePanel()
        }
    }
    
}
