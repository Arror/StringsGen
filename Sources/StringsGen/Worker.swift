//
//  Worker.swift
//  StringsGen
//
//  Created by Arror on 2018/1/13.
//

import Foundation

public struct Diff {
    let news: [Strings]
    let updates: [Strings]
    let deletes: [Strings]
}

public enum Worker {
    
    public static func execute(for langProj: LangProj, baseLang: String) {
        let stringss = Parser.parseInterface(path: langProj.xmlPath).reduce([]) { $0 + $1.stringss }.filter { $0.isValid }
        let descriptors = langProj.stringsPaths.map { Parser.parseStringsFile(path: $0) }
        let diff = self.diff(stringss: stringss, descriptors: descriptors, baseLang: baseLang)
        descriptors.forEach { self.genFiles(diff: diff, descriptor: $0, baseLang: baseLang) }
    }
    
    private static func diff(stringss: [Strings], descriptors: [StringsFileDescriptor], baseLang: String) -> Diff {
        guard let descriptor = descriptors[baseLang] else { fatalError("StringsFileDescriptor for lang: \(baseLang) not found.") }
        var news: [Strings] = []
        var updates: [Strings] = []
        var deletes: [Strings] = []
        var currentStringss = stringss
        descriptor.stringss.forEach { prior in
            if let idx = currentStringss.index(where: { $0.key == prior.key }) {
                if currentStringss[idx].value != prior.value {
                    updates.append(currentStringss[idx])
                }
                currentStringss.remove(at: idx)
            } else {
                deletes.append(prior)
            }
        }
        news = currentStringss
        return Diff(news: news, updates: updates, deletes: deletes)
    }
    
    private static func genFiles(diff: Diff, descriptor: StringsFileDescriptor, baseLang: String) {
        descriptor.merge(with: diff, baseLang: baseLang)
        print(descriptor.path.string)
        try! descriptor.raw.joined(separator: "\n").write(to: descriptor.path.url, atomically: true, encoding: .utf8)
    }
}
