//
//  Factory.swift
//  StringsGen
//
//  Created by Arror on 2018/1/13.
//

import Foundation
import SWXMLHash

public enum Factory {
    
    private static let mapping: [StringsItemType: StringsItem.Type] = [
        .label:             Label.self,
        .textField:         TextField.self,
        .segmentedControl:  SegmentedControl.self,
        .button:            Button.self,
        .tabBarItem:        TabBarItem.self,
        .navigationItem:    NavigationItem.self,
        .barButtonItem:     BarButtonItem.self
    ]
    
    public static func makeStringsItem(indexer: XMLIndexer) -> StringsItem? {
        guard
            let type = StringsItemType(rawValue: indexer.element?.name ?? ""),
            let itemType = self.mapping[type] else {
                return nil
        }
        return itemType.init(indexer: indexer)
    }
}
