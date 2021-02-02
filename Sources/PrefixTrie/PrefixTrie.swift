//
//  PrefixTree.swift
//  Boggle-SwiftUI
//
//  Created by Joshua Homann on 12/13/19.
//  Copyright © 2019 Joshua Homann. All rights reserved.
//

import Foundation
import Combine

public final class PrefixTree<SomeCollection: RangeReplaceableCollection> where SomeCollection.Element: Hashable  {
  typealias Element = SomeCollection.Element

  private var children: [Element: PrefixTree<SomeCollection>]
  private var isTerminal: Bool = false

  public required init() {
    self.children = [:]
  }

  public init(elements: [SomeCollection]) {
    self.children = [:]
    elements.forEach { self.insert($0) }
  }

  public func insert(_ collection: SomeCollection) {
    let terminalNode = collection.reduce(into: self) { node, element in
      let child = node.children[element, default: Self()]
      node.children[element] = child
      node = child
    }
    terminalNode.isTerminal = true
  }

  public func contains(_ collection: SomeCollection) -> Bool {
    collection.reduce(into: self, { $0 = $0?.children[$1]})?.isTerminal == true
  }

  public func contains(prefix: SomeCollection) -> Bool {
    prefix.reduce(into: self, { $0 = $0?.children[$1]}) != nil
  }
}

extension PrefixTree {
  public enum Error: Swift.Error {
    case invalidURL
  }
  public static func makeDictionary(filter predicate: @escaping (String) -> Bool = { _ in true }) -> Future<PrefixTree<String>, Swift.Error> {
    .init { promise in
      DispatchQueue.global(qos: .userInteractive).async {
        guard let json = Bundle.module.url(forResource: "words" as String?, withExtension: "json") else {
          return promise(.failure(Error.invalidURL))
        }
        switch (Result {
          try JSONDecoder().decode([String].self, from: try Data(contentsOf: json))
        }) {
        case .success(let words):
          promise(.success(PrefixTree<String>(elements: words.filter(predicate))))
        case .failure(let error):
          promise(.failure(error))
        }
      }
    }
  }
}

