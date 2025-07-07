#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define KEY 4

void encrypt(const char *plaintext, char *encrypted) {
    int i;
    for (i = 0; plaintext[i] != '\0'; i++) {
        char ch = plaintext[i];
        if (isalpha(ch)) {
            char offset = isupper(ch) ? 'A' : 'a';
            encrypted[i] = ((ch - offset + KEY) % 26) + offset;
        } else {
            encrypted[i] = ch;
        }
    }
    encrypted[i] = '\0';
}

void decrypt(const char *encrypted, char *plaintext) {
    int i;
    for (i = 0; encrypted[i] != '\0'; i++) {
        char ch = encrypted[i];
        if (isalpha(ch)) {
            char offset = isupper(ch) ? 'A' : 'a';
            plaintext[i] = ((ch - offset - KEY + 26) % 26) + offset;
        } else {
            plaintext[i] = ch;
        }
    }
    plaintext[i] = '\0';
}
