//  Project name: FwiCore
//  File name   : String+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/22/14
//  Version     : 2.0.0
//  --------------------------------------------------------------
//  Copyright © 2012, 2017 Fiision Studio.
//  All Rights Reserved.
//  --------------------------------------------------------------
//
//  Permission is hereby granted, free of charge, to any person obtaining  a  copy
//  of this software and associated documentation files (the "Software"), to  deal
//  in the Software without restriction, including without limitation  the  rights
//  to use, copy, modify, merge,  publish,  distribute,  sublicense,  and/or  sell
//  copies of the Software,  and  to  permit  persons  to  whom  the  Software  is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF  ANY  KIND,  EXPRESS  OR
//  IMPLIED, INCLUDING BUT NOT  LIMITED  TO  THE  WARRANTIES  OF  MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO  EVENT  SHALL  THE
//  AUTHORS OR COPYRIGHT HOLDERS  BE  LIABLE  FOR  ANY  CLAIM,  DAMAGES  OR  OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING  FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN  THE
//  SOFTWARE.
//
//
//  Disclaimer
//  __________
//  Although reasonable care has been taken to  ensure  the  correctness  of  this
//  software, this software should never be used in any application without proper
//  testing. Fiision Studio disclaim  all  liability  and  responsibility  to  any
//  person or entity with respect to any loss or damage caused, or alleged  to  be
//  caused, directly or indirectly, by the use of this software.

import Foundation


public extension String {
    
    /// Generate random identifier base on uuid.
    public static func randomIdentifier() -> String? {
        if let uuidRef = CFUUIDCreate(nil), let cfString = CFUUIDCreateString(nil, uuidRef) {
            return cfString as String
        }
        return nil
    }

    /// Generate timestamp string.
    public static func timestamp() -> String {
        return "\(time(nil))"
    }
    
    
    /// Convert html string compatible to string.
    public func decodeHTML() -> String {
        return removingPercentEncoding ?? ""
    }
    
    /// Convert string to html string compatible.
    public func encodeHTML() -> String {
        return addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed) ?? ""
    }
    
    /// Compare 2 string regardless case sensitive.
    ///
    /// - parameter otherString (required): other string to compare
    public func isEqualToStringIgnoreCase(_ otherString: String?) -> Bool {
        /* Condition validation */
        if otherString == nil {
            return false
        }

        let (text1, text2) = (self.lowercased().trim(), otherString?.lowercased().trim())
        return text1 == text2
    }
    
    /// Calculate string length.
    public func length() -> Int {
        return characters.count
    }
    
    /// Validate string.
    ///
    /// - parameter pattern (required): regular expression to validate string
    /// - parameter expressionOption (optional): regular expression searching option
    public func matchPattern(_ pattern: String, expressionOption option: NSRegularExpression.Options = .caseInsensitive) -> Bool {
        /* Condition validation */
        if pattern.length() <= 0 {
            return false
        }

        do {
            let regex = try NSRegularExpression(pattern: pattern, options: option)
            let matches = regex.numberOfMatches(in: self, options: .anchored, range: NSMakeRange(0, self.length()))
            
            return (matches == 1)
        } catch _ {
            FwiLog("Invalid regex pattern.")
        }
        return false
    }

    /// Split string into components.
    ///
    /// - parameter separator (required): string's separator
    public func split(_ separator: String) -> [String] {
        return components(separatedBy: separator)
    }
    
    /// Sub string to index.
    public func substring(endIndex index: Int) -> String {
        /* Condition validation: Validate end index */
        if index <= 0 || index >= length() {
            FwiLog("End index should be a positive number but less than string's length.")
            return ""
        }
        return substring(startIndex: 0, reverseIndex: -(length() - index))
    }
    
    /// Sub string from index to reverse index.
    ///
    /// - parameter startIndex (required): beginning index
    /// - parameter reverseIndex (optional): ending index
    public func substring(startIndex strIndex: Int, reverseIndex endIndex: Int = 0) -> String {
        /* Condition validation: Validate start index */
        if strIndex < 0 || strIndex > length() {
            FwiLog("Start index should not be a negative number or larger than string's length.")
            return ""
        }
        
        /* Condition validation: Validate end index */
        if endIndex > 0 || abs(endIndex) > length() {
            FwiLog("Reverse index should be a negative number but absolute value must less than string's length.")
            return ""
        }
        
        /* Condition validation: Validate overlap index */
        if strIndex >= length() + endIndex {
            FwiLog("Start index and reverse index should not overlap each other.")
            return ""
        }

        let range = characters.index(self.startIndex, offsetBy: strIndex) ..< characters.index(self.endIndex, offsetBy: endIndex)
        return String(self[range])
    }
    
    /// Trim all spaces before and after a string.
    public func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// Convert string to data.
    public func toData(dataEncoding encoding: String.Encoding = .utf8) -> Data? {
        return data(using: encoding, allowLossyConversion: false)
    }
}

extension String {
    
    /// Subscript get character at index.
    public subscript(index: Int) -> Character? {
        guard !(index < 0 || index >= characters.count) else {
            return nil
        }
        return self[characters.index(self.startIndex, offsetBy: index)]
    }
}