#include "TrieNode.h"
class TrieNode {
public:
    TrieNode *abc[62];
    bool termina;
    int varNo;
    TrieNode() {
        termina=false;
        varNo=-1;
        for (int i = 0 ; i < 62;i++)
            abc[i]=NULL;
    }
};