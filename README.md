# PrefixTrie

This package provides an implmentation of a prefix tree for a collection.

## Initializers

```
let trie = PrefixTree<String>()
```

```
let trie = PrefixTree(["category", "catacomb", "caterpillar"])
```

## Adding elements
```
trie.insert("cat")
```

## Checking membership
```
let trie = PrefixTree(["category", "catacomb", "caterpillar"])

trie.contains(prefix: "cat")

trie.contains("category")
```

## Creating a Future Trie from the built in dictionary
```
let future = PrefixTree<String>.makeDictionary(filter: { $0.count < 5 })
```
