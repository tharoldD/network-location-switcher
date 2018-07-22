//
//  StringExtensions.swift
//  Network Location Switcher
//
//  Created by Harold Turyasingura on 21/10/2017.
//  Copyright © 2017 Harold Turyasingura. All rights reserved.
//
//  Borrowed ideas and code from...
//  https://stackoverflow.com/a/42403944

import Foundation

extension String {
    func replaceFirstOccurence(
        target: String, withString replaceString: String) -> String
    {
        if let range = self.range(of: target) {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
}

extension String {
    func replaceLastOccurrence(
        target: String, withString replaceString: String) -> String
    {
        if let range = self.range(of: target, options: String.CompareOptions.backwards) {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
}
