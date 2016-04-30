#ifndef TRIE_H
#define TRIE_H

#include "TrieNode.h"

class Trie {
private:
    TrieNode* root;
public:
    Trie() ;
    int trieAux (char c);
    bool insert(string word,int place,int num) ;
    // Returns if the word is in the trie.
    int search(string word,int place);
};
#endif
