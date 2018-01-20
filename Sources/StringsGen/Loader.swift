//
//  Loader.swift
//  StringsGen
//
//  Created by Arror on 2018/1/13.
//

import Foundation
import PathKit

public struct LangProj {
    public let xmlPath: Path
    public let stringsPaths: [Path]
}

public enum Loader {
    
    public static func loadLangProjs(at path: Path) -> [LangProj] {
        var langProjs: [LangProj] = []
        let children = (try? path.children()) ?? []
        let directories = children.filter { $0.isDirectory && $0.lastComponent.contains(".lproj") }
        var intefaceMapping: [String: Path] = [:]
        var stringsMapping: [String: [Path]] = [:]
        directories.forEach { p in
            if p.lastComponent == "Base.lproj" {
                let interfaces = ((try? p.children()) ?? []).filter({ filePath -> Bool in
                    if !filePath.isFile {
                        return false
                    }
                    let ex = filePath.extension ?? ""
                    if !(ex == "storyboard") && !(ex == "xib") {
                        return false
                    }
                    return true
                })
                interfaces.forEach({ p in
                    intefaceMapping[p.lastComponentWithoutExtension] = p
                })
            } else {
                let stringss = ((try? p.children()) ?? []).filter({ stringsPath -> Bool in
                    let ex = stringsPath.extension ?? ""
                    return ex == "strings"
                })
                stringss.forEach({ p in
                    var paths = stringsMapping[p.lastComponentWithoutExtension] ?? []
                    paths.append(p)
                    stringsMapping[p.lastComponentWithoutExtension] = paths
                })
            }
        }
        intefaceMapping.forEach { key, path in
            langProjs.append(LangProj(xmlPath: path, stringsPaths: stringsMapping[key] ?? []))
        }
        
        let otherDirectories = children.filter { $0.isDirectory && !$0.lastComponent.contains(".lproj") }
        if !otherDirectories.isEmpty {
            otherDirectories.forEach { langProjs += Loader.loadLangProjs(at: $0) }
            return langProjs
        } else {
            return langProjs
        }
    }
}
