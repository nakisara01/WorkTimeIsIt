//
//  WorkTimeIsItApp.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import SwiftUI
import AppKit

@MainActor
final class AppDependencies {
    static let shared = AppDependencies()

    let timeManager = TimeManager()
    let settingsManager = UserDefaultsManager.shared
    let spriteRenderer = StatusItemSpriteRenderer()

    private init() {}
}

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let deps = AppDependencies.shared
    private var statusItem: NSStatusItem?
    private let popover = NSPopover()
    private var labelHostingView: NSHostingView<MenuBarLabel>?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        setupPopover()
    }

    private func setupStatusItem() {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem = item

        guard let button = item.button else { return }
        button.target = self
        button.action = #selector(handleStatusItemClick(_:))
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])

        let labelView = MenuBarLabel(
            timeManager: deps.timeManager,
            spriteRenderer: deps.spriteRenderer,
            settingsManager: deps.settingsManager
        )
        let host = NSHostingView(rootView: labelView)
        host.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(host)
        NSLayoutConstraint.activate([
            host.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            host.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            host.topAnchor.constraint(equalTo: button.topAnchor),
            host.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])
        labelHostingView = host
    }

    private func setupPopover() {
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 320, height: 550)
        popover.contentViewController = NSHostingController(
            rootView: ContentView()
                .environment(deps.timeManager)
                .environment(deps.settingsManager)
        )
    }

    @objc
    private func handleStatusItemClick(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }

        if event.type == .rightMouseUp {
            showContextMenu(from: sender)
        } else {
            togglePopover(from: sender)
        }
    }

    private func togglePopover(from button: NSStatusBarButton) {
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    private func showContextMenu(from button: NSStatusBarButton) {
        let menu = NSMenu()

        let displayModeMenuItem = NSMenuItem(title: "표시 모드", action: nil, keyEquivalent: "")
        let displayModeSubmenu = NSMenu()

        let remainingItem = NSMenuItem(
            title: DisplayMode.remainingTime.displayName,
            action: #selector(selectDisplayModeRemaining),
            keyEquivalent: ""
        )
        remainingItem.target = self
        remainingItem.state = deps.settingsManager.displayMode == .remainingTime ? .on : .off

        let endTimeItem = NSMenuItem(
            title: DisplayMode.endTime.displayName,
            action: #selector(selectDisplayModeEndTime),
            keyEquivalent: ""
        )
        endTimeItem.target = self
        endTimeItem.state = deps.settingsManager.displayMode == .endTime ? .on : .off

        displayModeSubmenu.addItem(remainingItem)
        displayModeSubmenu.addItem(endTimeItem)
        menu.setSubmenu(displayModeSubmenu, for: displayModeMenuItem)
        menu.addItem(displayModeMenuItem)

        let spriteMenuItem = NSMenuItem(title: "캐릭터", action: nil, keyEquivalent: "")
        let spriteSubmenu = NSMenu()

        let spriteOptions: [(index: Int, name: String)] = [
            (0, String(localized: "sprite.miner")),
            (1, String(localized: "sprite.runner")),
            (2, String(localized: "sprite.rocket")),
            (3, String(localized: "sprite.surfer"))
        ]

        for option in spriteOptions {
            let item = NSMenuItem(
                title: option.name,
                action: #selector(selectSprite(_:)),
                keyEquivalent: ""
            )
            item.target = self
            item.tag = option.index
            item.state = deps.settingsManager.selectedSpriteIndex == option.index ? .on : .off
            spriteSubmenu.addItem(item)
        }

        menu.setSubmenu(spriteSubmenu, for: spriteMenuItem)
        menu.addItem(spriteMenuItem)

        menu.addItem(.separator())
        let quitItem = NSMenuItem(title: "앱 종료", action: #selector(quitApp), keyEquivalent: "")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem?.menu = menu
        button.performClick(nil)
        statusItem?.menu = nil
    }

    @objc
    private func selectDisplayModeRemaining() {
        deps.settingsManager.displayMode = .remainingTime
    }

    @objc
    private func selectDisplayModeEndTime() {
        deps.settingsManager.displayMode = .endTime
    }

    @objc
    private func selectSprite(_ sender: NSMenuItem) {
        deps.settingsManager.selectedSpriteIndex = sender.tag
    }

    @objc
    private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

@main
struct WorkTimeIsItApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
