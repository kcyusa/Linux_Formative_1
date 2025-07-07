#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_ENTRIES 100
#define ENTRY_LEN 1024
#define PASSWORD "secret"

extern void encrypt(const char *, char *);
extern void decrypt(const char *, char *);

char encrypted_entries[MAX_ENTRIES][ENTRY_LEN];
int entry_count = 0;

void add_entry() {
    if (entry_count >= MAX_ENTRIES) {
        printf("Diary is full.\n");
        return;
    }

    char input[ENTRY_LEN];
    printf("Enter your diary entry:\n> ");
    getchar();  // clear newline
    fgets(input, ENTRY_LEN, stdin);
    input[strcspn(input, "\n")] = 0;  // remove newline

    encrypt(input, encrypted_entries[entry_count]);
    printf("Entry saved (encrypted).\n");
    entry_count++;
}

void view_entries() {
    char pwd[64];
    printf("Enter password to view entries: ");
    scanf("%63s", pwd);

    if (strcmp(pwd, PASSWORD) != 0) {
        printf("Incorrect password.\n");
        return;
    }

    printf("\n📓 Decrypted Diary Entries:\n");
    for (int i = 0; i < entry_count; i++) {
        char decrypted[ENTRY_LEN];
        decrypt(encrypted_entries[i], decrypted);
        printf("[%d] %s\n", i + 1, decrypted);
    }
}

int main() {
    int choice;

    while (1) {
        printf("\n==== Diary Manager ====\n");
        printf("1. Add Entry\n");
        printf("2. View Entries\n");
        printf("3. Exit\n");
        printf("Choose an option: ");
        scanf("%d", &choice);

        switch (choice) {
            case 1: add_entry(); break;
            case 2: view_entries(); break;
            case 3: exit(0);
            default: printf("Invalid choice.\n");
        }
    }
    return 0;
}
