//
//  Parser.swift
//  StringsGen
//
//  Created by Arror on 2018/1/13.
//

import Foundation
import SWXMLHash
import PathKit
import LLRegex

public enum Parser {
    
    public static func parseInterface(path: Path) -> [StringsItem] {
        guard let data = FileManager.default.contents(atPath: path.string) else { return [] }
        let indexer = SWXMLHash.parse(data)
        return self.parseInterface(indexer: indexer["document"])
    }
    
    private static func parseInterface(indexer: XMLIndexer) -> [StringsItem] {
        var items: [StringsItem] = []
        if let item = Factory.makeStringsItem(indexer: indexer) {
            items.append(item)
        }
        if !indexer.children.isEmpty {
            indexer.children.forEach { items += self.parseInterface(indexer: $0) }
            return items
        } else {
            return items
        }
    }
    
    private static let regex = Regex("^[\"](?<id>.+)[.](?<token>.+)[\"]([\\s=]{0,3})[\"](?<value>.+)[\"];$", options: .namedCaptureGroups)

    public static func parseStringsFile(path: Path) -> StringsFileDescriptor {
        
        let fileString = (try? String(contentsOf: path.url, encoding: .utf8)) ?? ""
        
        let rawStringss = fileString.components(separatedBy: CharacterSet(arrayLiteral: "\n"))
        
        let stringss = rawStringss.filter { rawStrings -> Bool in
            let trimmingStr = rawStrings.trimmingCharacters(in: CharacterSet(arrayLiteral: " "))
            if trimmingStr.hasPrefix("/*") || trimmingStr.hasSuffix("*/") || trimmingStr.isEmpty || trimmingStr.hasPrefix("//") {
                return false
            } else {
                return true
            }
        }.flatMap { rawStrings -> Strings? in
            var objectID: String = ""
            var token: String = ""
            var value: String = ""
            for m in regex.matches(in: rawStrings) {
                objectID = m.groups["id"]?.matched ?? ""
                token = m.groups["token"]?.matched ?? ""
                value = m.groups["value"]?.matched ?? ""
            }
            if objectID.isEmpty || token.isEmpty || value.isEmpty {
                fatalError("Parser Error. Raw String: \(rawStrings)")
            } else {
                return Strings(key: "\(objectID).\(token)", value: value, isValid: true, annotation: "", rawStrings: rawStrings, rawStringsPlaceholder: "")
            }
        }
        
        return StringsFileDescriptor(path: path, language: path.parent().lastComponentWithoutExtension, raw: rawStringss, stringss: stringss)
    }
}
