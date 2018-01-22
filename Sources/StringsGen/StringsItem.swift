//
//  StringsItem.swift
//  StringsGen
//
//  Created by Arror on 2018/1/13.
//

import Foundation
import SWXMLHash

public struct Strings {
    public let key: String
    public let value: String
    public let isValid: Bool
    public let annotation: String
    public let rawStrings: String
    public let rawStringsPlaceholder: String
}

public enum StringsItemType: String {
    case label
    case textField
    case textView
    case segmentedControl
    case button
    case tabBarItem
    case navigationItem
    case barButtonItem
    case searchBar
}

public protocol StringsItem {
    init(indexer: XMLIndexer)
    var stringss: [Strings] { get }
}

public struct Label: StringsItem {
    
    private let objectID: String
    private let text: String
    
    public init(indexer: XMLIndexer) {
        self.objectID = indexer.element?.attribute(by: "id")?.text ?? ""
        self.text = indexer.element?.attribute(by: "text")?.text ?? ""
    }
    
    public var stringss: [Strings] {
        return [
            Strings(
                key: "\(self.objectID).text",
                value: self.text,
                isValid: !self.text.isEmpty,
                annotation: "/* Class = \"UILabel\"; text = \"\(self.text)\"; ObjectID = \"\(self.objectID)\"; */",
                rawStrings: "\"\(self.objectID).text\" = \"\(self.text)\";",
                rawStringsPlaceholder: "\"\(self.objectID).text\" = \"<#需要更新#>\";"
            )
        ]
    }
}

public struct TextField: StringsItem {
    
    private let objectID: String
    private let text: String
    private let placeholder: String
    
    public init(indexer: XMLIndexer) {
        self.objectID = indexer.element?.attribute(by: "id")?.text ?? ""
        self.text = indexer.element?.attribute(by: "text")?.text ?? ""
        self.placeholder = indexer.element?.attribute(by: "placeholder")?.text ?? ""
    }
    
    public var stringss: [Strings] {
        return [
            Strings(
                key: "\(self.objectID).text",
                value: self.text,
                isValid: !self.text.isEmpty,
                annotation: "/* Class = \"UITextField\"; text = \"\(self.text)\"; ObjectID = \"\(self.objectID)\"; */",
                rawStrings: "\"\(self.objectID).text\" = \"\(self.text)\";",
                rawStringsPlaceholder: "\"\(self.objectID).text\" = \"<#需要更新#>\";"
            ),
            Strings(
                key: "\(self.objectID).placeholder",
                value: self.placeholder,
                isValid: !self.placeholder.isEmpty,
                annotation: "/* Class = \"UITextField\"; placeholder = \"\(self.placeholder)\"; ObjectID = \"\(self.objectID)\"; */",
                rawStrings: "\"\(self.objectID).placeholder\" = \"\(self.placeholder)\";",
                rawStringsPlaceholder: "\"\(self.objectID).placeholder\" = \"<#需要更新#>\";"
            )
        ]
    }
}

public struct TextView: StringsItem {
    
    private let objectID: String
    private let text: String
    
    public init(indexer: XMLIndexer) {
        self.objectID = indexer.element?.attribute(by: "id")?.text ?? ""
        self.text = indexer["string"].element?.text ?? ""
    }
    
    public var stringss: [Strings] {
        return [
            Strings(
                key: "\(self.objectID).text",
                value: self.text,
                isValid: !self.text.isEmpty,
                annotation: "/* Class = \"UITextView\"; text = \"\(self.text)\"; ObjectID = \"\(self.objectID)\"; */",
                rawStrings: "\"\(self.objectID).text\" = \"\(self.text)\";",
                rawStringsPlaceholder: "\"\(self.objectID).text\" = \"<#需要更新#>\";"
            )
        ]
    }
}

public struct SegmentedControl: StringsItem {
    
    private let objectID: String
    private let segmentTitles: [String]
    
    public init(indexer: XMLIndexer) {
        self.objectID = indexer.element?.attribute(by: "id")?.text ?? ""
        self.segmentTitles = indexer["segments"].children.flatMap({ idxer -> String? in
            return idxer.element?.attribute(by: "title")?.text
        })
    }
    
    public var stringss: [Strings] {
        return self.segmentTitles.enumerated().map({ idx, value -> Strings in
            Strings(
                key: "\(self.objectID).segmentTitles[\(idx)]",
                value: value,
                isValid: !value.isEmpty,
                annotation: "/* Class = \"UISegmentedControl\"; \(self.objectID).segmentTitles[\(idx)] = \"\(value)\"; ObjectID = \"\(self.objectID)\"; */",
                rawStrings: "\"\(self.objectID).segmentTitles[\(idx)]\" = \"\(value)\";",
                rawStringsPlaceholder: "\"\(self.objectID).segmentTitles[\(idx)]\" = \"<#需要更新#>\";"
            )
        })
    }
}

public struct Button: StringsItem {
    
    private let objectID: String
    private let normalTitle: String
    private let selectedTitle: String
    private let highlightedTitle: String
    private let disabledTitle: String
    
    public init(indexer: XMLIndexer) {
        self.objectID = indexer.element?.attribute(by: "id")?.text ?? ""
        var nt: String = ""
        var st: String = ""
        var ht: String = ""
        var dt: String = ""
        indexer["state"].all.forEach { idxer in
            let key = idxer.element?.attribute(by: "key")?.text ?? ""
            let title = idxer.element?.attribute(by: "title")?.text ?? ""
            switch key {
            case "normal":
                nt = title
            case "selected":
                st = title
            case "highlighted":
                ht = title
            case "disabled":
                dt = title
            default:
                break
            }
        }
        self.normalTitle = nt
        self.selectedTitle = st
        self.highlightedTitle = ht
        self.disabledTitle = dt
    }
    
    public var stringss: [Strings] {
        return [
            Strings(
                key: "\(self.objectID).normalTitle",
                value: self.normalTitle,
                isValid: !self.normalTitle.isEmpty,
                annotation: "/* Class = \"UIButton\"; normalTitle = \"\(self.normalTitle)\"; ObjectID = \"\(self.objectID)\"; */",
                rawStrings: "\"\(self.objectID).normalTitle\" = \"\(self.normalTitle)\";",
                rawStringsPlaceholder: "\"\(self.objectID).normalTitle\" = \"<#需要更新#>\";"
            ),
            Strings(
                key: "\(self.objectID).selectedTitle",
                value: self.selectedTitle,
                isValid: !self.selectedTitle.isEmpty,
                annotation: "/* Class = \"UIButton\"; selectedTitle = \"\(self.selectedTitle)\"; ObjectID = \"\(self.objectID)\"; */",
                rawStrings: "\"\(self.objectID).selectedTitle\" = \"\(self.selectedTitle)\";",
                rawStringsPlaceholder: "\"\(self.objectID).selectedTitle\" = \"<#需要更新#>\";"
            ),
            Strings(
                key: "\(self.objectID).highlightedTitle",
                value: self.highlightedTitle,
                isValid: !self.highlightedTitle.isEmpty,
                annotation: "/* Class = \"UIButton\"; highlightedTitle = \"\(self.highlightedTitle)\"; ObjectID = \"\(self.objectID)\"; */",
                rawStrings: "\"\(self.objectID).highlightedTitle\" = \"\(self.highlightedTitle)\";",
                rawStringsPlaceholder: "\"\(self.objectID).highlightedTitle\" = \"<#需要更新#>\";"
            ),
            Strings(
                key: "\(self.objectID).disabledTitle",
                value: self.disabledTitle,
                isValid: !self.disabledTitle.isEmpty,
                annotation: "/* Class = \"UIButton\"; disabledTitle = \"\(self.disabledTitle)\"; ObjectID = \"\(self.objectID)\"; */",
                rawStrings: "\"\(self.objectID).disabledTitle\" = \"\(self.disabledTitle)\";",
                rawStringsPlaceholder: "\"\(self.objectID).disabledTitle\" = \"<#需要更新#>\";"
            )
        ]
    }
}

public struct TabBarItem: StringsItem {
    
    private let objectID: String
    private let title: String
    
    public init(indexer: XMLIndexer) {
        self.objectID = indexer.element?.attribute(by: "id")?.text ?? ""
        self.title = indexer.element?.attribute(by: "title")?.text ?? ""
    }
    
    public var stringss: [Strings] {
        return [
            Strings(
                key: "\(self.objectID).title",
                value: self.title,
                isValid: !self.title.isEmpty,
                annotation: "/* Class = \"UITabBarItem\"; title = \"\(self.title)\"; ObjectID = \"\(self.objectID)\"; */",
                rawStrings: "\"\(self.objectID).title\" = \"\(self.title)\";",
                rawStringsPlaceholder: "\"\(self.objectID).title\" = \"<#需要更新#>\";"
            )
        ]
    }
}

public struct NavigationItem: StringsItem {
    
    private let objectID: String
    private let title: String
    private let prompt: String
    
    public init(indexer: XMLIndexer) {
        self.objectID = indexer.element?.attribute(by: "id")?.text ?? ""
        self.title = indexer.element?.attribute(by: "title")?.text ?? ""
        self.prompt = indexer.element?.attribute(by: "prompt")?.text ?? ""
    }
    
    public var stringss: [Strings] {
        return [
            Strings(
                key: "\(self.objectID).title",
                value: self.title,
                isValid: !self.title.isEmpty,
                annotation: "/* Class = \"UINavigationItem\"; title = \"\(self.title)\"; ObjectID = \"\(self.objectID)\"; */",
                rawStrings: "\"\(self.objectID).title\" = \"\(self.title)\";",
                rawStringsPlaceholder: "\"\(self.objectID).title\" = \"<#需要更新#>\";"
            ),
            Strings(
                key: "\(self.objectID).prompt",
                value: self.prompt,
                isValid: !self.prompt.isEmpty,
                annotation: "/* Class = \"UINavigationItem\"; prompt = \"\(self.prompt)\"; ObjectID = \"\(self.objectID)\"; */",
                rawStrings: "\"\(self.objectID).prompt\" = \"\(self.prompt)\";",
                rawStringsPlaceholder: "\"\(self.objectID).prompt\" = \"<#需要更新#>\";"
            )
        ]
    }
}

public struct BarButtonItem: StringsItem {
    
    private let objectID: String
    private let title: String
    
    public init(indexer: XMLIndexer) {
        self.objectID = indexer.element?.attribute(by: "id")?.text ?? ""
        self.title = indexer.element?.attribute(by: "title")?.text ?? ""
    }
    
    public var stringss: [Strings] {
        return [
            Strings(
                key: "\(self.objectID).title",
                value: self.title,
                isValid: !self.title.isEmpty,
                annotation: "/* Class = \"UIBarButtonItem\"; title = \"\(self.title)\"; ObjectID = \"\(self.objectID)\"; */",
                rawStrings: "\"\(self.objectID).title\" = \"\(self.title)\";",
                rawStringsPlaceholder: "\"\(self.objectID).title\" = \"<#需要更新#>\";"
            )
        ]
    }
}

public struct SearchBar: StringsItem {
    
    private let objectID: String
    private let text: String
    private let prompt: String
    private let placeholder: String
    
    public init(indexer: XMLIndexer) {
        self.objectID = indexer.element?.attribute(by: "id")?.text ?? ""
        self.text = indexer.element?.attribute(by: "text")?.text ?? ""
        self.prompt = indexer.element?.attribute(by: "prompt")?.text ?? ""
        self.placeholder = indexer.element?.attribute(by: "placeholder")?.text ?? ""
    }
    
    public var stringss: [Strings] {
        return [
            Strings(
                key: "\(self.objectID).text",
                value: self.text,
                isValid: !self.text.isEmpty,
                annotation: "/* Class = \"UISearchBar\"; text = \"\(self.text)\"; ObjectID = \"\(self.objectID)\"; */",
                rawStrings: "\"\(self.objectID).text\" = \"\(self.text)\";",
                rawStringsPlaceholder: "\"\(self.objectID).text\" = \"<#需要更新#>\";"
            ),
            Strings(
                key: "\(self.objectID).prompt",
                value: self.prompt,
                isValid: !self.prompt.isEmpty,
                annotation: "/* Class = \"UISearchBar\"; prompt = \"\(self.text)\"; ObjectID = \"\(self.objectID)\"; */",
                rawStrings: "\"\(self.objectID).prompt\" = \"\(self.prompt)\";",
                rawStringsPlaceholder: "\"\(self.objectID).prompt\" = \"<#需要更新#>\";"
            ),
            Strings(
                key: "\(self.objectID).placeholder",
                value: self.placeholder,
                isValid: !self.placeholder.isEmpty,
                annotation: "/* Class = \"UISearchBar\"; placeholder = \"\(self.placeholder)\"; ObjectID = \"\(self.objectID)\"; */",
                rawStrings: "\"\(self.objectID).placeholder\" = \"\(self.placeholder)\";",
                rawStringsPlaceholder: "\"\(self.objectID).placeholder\" = \"<#需要更新#>\";"
            )
        ]
    }
}
