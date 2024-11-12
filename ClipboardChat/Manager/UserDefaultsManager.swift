//
//  UserDefaultsManager.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/09.
//


import Foundation
import Combine

extension UserDefaults {

    @objc dynamic var apiKeyValue: String {
        get { string(forKey: UserDefaultsManager.apiUserDefaultsKey) ?? ""}
        set { setValue(newValue, forKey: UserDefaultsManager.apiUserDefaultsKey) }
    }
    
    @objc dynamic var languageValue: String {
        get { string(forKey: UserDefaultsManager.translationTargetLanguageKey) ?? "Japanese"}
        set { setValue(newValue, forKey: UserDefaultsManager.translationTargetLanguageKey) }
    }
    
    @objc dynamic var pollingIntervalValue: Double {
        get {
            let currentValue = double(forKey: UserDefaultsManager.pollingIntervalKey)
            return currentValue == 0 ? PasteboardManager.defaultPollingInterval : currentValue
        }
        set { setValue(newValue, forKey: UserDefaultsManager.pollingIntervalKey) }
    }
    
    @objc dynamic var customTaskValue: Data? {
        get { data(forKey: UserDefaultsManager.customTasksKey)}
        set { setValue(newValue, forKey: UserDefaultsManager.customTasksKey) }
    }
}

@Observable
class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    static let apiUserDefaultsKey = "ItsukiChatAPIKey"
    static let translationTargetLanguageKey = "ItsukiChatTargetLanguage"
    static let pollingIntervalKey = "ItsukiChatPollingInterval"
    static let customTasksKey = "ItsukiChatCustomTasks"
    static let userDefaults = UserDefaults(suiteName: "ItsukiChat") ?? UserDefaults.standard
    
    static private let encoder = JSONEncoder()
    static private let decoder = JSONDecoder()
    
    var pollingInterval: Double = userDefaults.pollingIntervalValue {
        didSet {
            Self.userDefaults.pollingIntervalValue = pollingInterval
        }
    }

    var apiKey: String = userDefaults.apiKeyValue {
        didSet {
            Self.userDefaults.apiKeyValue = apiKey
        }
    }
    
    var translationTargetLanguage: String = userDefaults.languageValue {
        didSet {
            Self.userDefaults.languageValue = translationTargetLanguage
        }
    }
    
    private var customTasksData: Data? = userDefaults.customTaskValue {
        didSet {
            Self.userDefaults.customTaskValue = customTasksData
        }
    }
    
    var customTasks: [CustomTask] {
        get {
            guard let customTasksData else {
                return []
            }
            do {
                return try Self.decoder.decode([CustomTask].self, from: customTasksData)
            } catch (let error) {
                print(error)
                return []
            }
        }
        set(newValue) {
            self.customTasksData = try? Self.encoder.encode(newValue)
        }
    }

    
    private var apiKeyCancellable: AnyCancellable?
    private var languageCancellable: AnyCancellable?
    private var pollingIntervalCancellable: AnyCancellable?
    private var customTasksCancellable: AnyCancellable?

    
    init() {
//        print(Self.userDefaults)
        apiKeyCancellable = Self.userDefaults
            .publisher(for: \.apiKeyValue)
            .sink(receiveValue: { value in
                print("api key received: \(value)")
                if self.apiKey != value {
                    self.apiKey = value
                }
            })
        
        languageCancellable = Self.userDefaults
            .publisher(for: \.languageValue)
            .sink(receiveValue: { value in
                print("translationTargetLanguage received: \(value)")
                if self.translationTargetLanguage != value {
                    self.translationTargetLanguage = value
                }
            })
        
        pollingIntervalCancellable = Self.userDefaults
            .publisher(for: \.pollingIntervalValue)
            .sink(receiveValue: { value in
                print("pooling interval: \(value)")
                if self.pollingInterval != value {
                    self.pollingInterval = value
                }
            })
        
        customTasksCancellable = Self.userDefaults
            .publisher(for: \.customTaskValue)
            .sink(receiveValue: { value in
                print("custom task data: \(String(describing: String(data: value ?? Data(), encoding: .utf8)))")
                if self.customTasksData != value {
                    self.customTasksData = value
                }
            })
    }
}
