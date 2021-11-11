//
//  File.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

struct ASN1Sequence: ASN1Value {
  var values = [ASN1Value]()
  
  public init(_ first: ASN1Value, _ next: ASN1Value...) {
    values = [first] + next
  }
  
  public init(_ values: [ASN1Value]) throws {
    guard !values.isEmpty else {
      throw ASN1ConstructionError.emptySequence
    }
    self.values = values
  }
  
  init(data: Data) throws {
    var offset = data.startIndex
    while offset < data.endIndex {
      values.append(try ASN1Parser.parseTLV(data, offset: &offset))
    }
    
    guard !values.isEmpty else {
      throw ASN1ParsingError.invalidSequence
    }
  }
}

extension ASN1Sequence: Equatable {
  static func == (lhs: ASN1Sequence, rhs: ASN1Sequence) -> Bool {
    guard lhs.values.count == rhs.values.count else { return false }
    return zip(lhs.values, rhs.values).allSatisfy({ (v1, v2) in v1.isEqualTo(v2) })
  }
}
