#include "trie.h"


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
class Trie {
private:
    TrieNode* root;
public:
    Trie() {
        root = new TrieNode();
    }
    int trieAux (char c){
        if (c>= '0' && c<= '9'){
            return c-'0';
        }
        if (c>= 'a' && c<= 'z'){
            return (c-'a') + 10;
        }
        if (c>= 'A' && c<= 'Z'){
            return (c-'Z') + 26;
        }
        return -1;
    }
    bool insert(string word,int place,int num) {
        TrieNode *aux;
        aux=root;
        int val;
        //se guarda(al revez) con el valor place, que es un int y representa el bloque
        do{
            if(aux->abc[place%10]==NULL){
                aux->abc[place%10]=new TrieNode();
            }
            aux = aux->abc[place%10];
            place /= 10;
        }while (place>0);
        
        for (int i = 0 ; i < word.size();i++){
            val=trieAux(word[i]);
            if(aux->abc[val]==NULL){
                aux->abc[val]=new TrieNode();
            }
            aux = aux->abc[val];
        }
        if (aux->termina){
            return false;
        }
        aux->varNo=num;
        num++;
        aux->termina=true;
        return true;
    }
    
    // Returns if the word is in the trie.
    int search(string word,int place) {
        TrieNode *aux;
        aux=root;
        int val;
        do{
            if(aux->abc[place%10]==NULL){
                return -1;
            }
            aux = aux->abc[place%10];
            place /= 10;
        }while (place>0);
        for (int i = 0 ; i < word.size();i++){
            val=trieAux(word[i]);
            if(aux->abc[val]==NULL){
                return -1;
            }
            aux = aux->abc[val];
        }
        return aux->varNo;
    }
};

