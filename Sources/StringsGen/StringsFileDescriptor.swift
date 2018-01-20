//
//  StringsFileDescriptor.swift
//  StringsGen
//
//  Created by Arror on 2018/1/20.
//

import Foundation
import PathKit

private extension Date {
    
    static var currentFormatDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
}

public final class StringsFileDescriptor {
    
    public let path: Path
    public let language: String
    public private(set) var raw: [String]
    public let stringss: [Strings]
    
    public init(path: Path, language: String, raw: [String], stringss: [Strings]) {
        self.path = path
        self.language = language
        self.raw = raw
        self.stringss = stringss
    }
    
    private var newsHeader: String {
        return """
        \n// ====================================================
        // = 新增
        // = \(Date.currentFormatDate)
        // ====================================================\n
        """
    }
    
    private var updatesHeader: String {
        return """
        \n// ====================================================
        // = 更新
        // = \(Date.currentFormatDate)
        // ====================================================\n
        """
    }
    
    private var deleteHeader: String {
        return """
        // ====================================================
        // = 删除
        // = \(Date.currentFormatDate)
        // ====================================================
        """
    }
    
    public func merge(with diff: Diff, baseLang: String) {
        diff.deletes.forEach { strings in
            if let idx = self.raw.index(where: { $0.hasPrefix("\"\(strings.key)\"") }) {
                self.raw[idx] = "// \(self.raw[idx])"
                self.raw.insert(self.deleteHeader, at: idx)
            }
        }
        if !diff.updates.isEmpty {
            self.raw.append(self.updatesHeader)
            diff.updates.forEach({ strings in
                if let idx = self.raw.index(where: { $0.hasPrefix("\"\(strings.key)\"") }) {
                    self.raw.remove(at: idx)
                    for i in (0..<idx).reversed() {
                        if self.raw[i].hasPrefix("\"") || self.raw[i].hasPrefix("//") {
                            break
                        } else {
                            self.raw.remove(at: i)
                        }
                    }
                }
                if self.language == baseLang {
                    self.raw.append(strings.annotation + "\n" + strings.rawStrings + "\n")
                } else {
                    self.raw.append(strings.annotation + "\n" + strings.rawStringsPlaceholder + "\n")
                }
            })
        }
        if !diff.news.isEmpty {
            self.raw.append(self.newsHeader)
            diff.news.forEach({ strings in
                if self.language == baseLang {
                    self.raw.append(strings.annotation + "\n" + strings.rawStrings + "\n")
                } else {
                    self.raw.append(strings.annotation + "\n" + strings.rawStringsPlaceholder + "\n")
                }
            })
        }
        self.raw = Array(self.raw.drop(while: { $0.isEmpty }))
    }
}

extension Array where Element == StringsFileDescriptor {
    subscript(lang: String) -> Element? {
        guard let idx = self.index(where: { $0.language == lang }) else { return nil }
        return self[idx]
    }
}
