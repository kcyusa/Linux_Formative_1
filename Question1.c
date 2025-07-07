#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libgen.h>  // for basename()

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <path_to_elf_executable>\n", argv[0]);
        return EXIT_FAILURE;
    }

    char *input_path = argv[1];

    // Extract the base name of the file (e.g., /path/to/file -> file)
    char *input_path_copy = strdup(input_path);
    if (!input_path_copy) {
        perror("strdup");
        return EXIT_FAILURE;
    }

    char *base = basename(input_path_copy);

    // Remove extension if it exists
    char *dot = strrchr(base, '.');
    if (dot) {
        *dot = '\0';
    }

    // Build the output file name (e.g., file.txt)
    char output_file[256];
    snprintf(output_file, sizeof(output_file), "%s.txt", base);

    // Build the objdump command
    char command[512];
    snprintf(command, sizeof(command),
             "objdump -d --section=.text \"%s\" > \"%s\"", input_path, output_file);

    printf("Running: %s\n", command);

    // Execute the command
    int ret = system(command);
    if (ret != 0) {
        fprintf(stderr, "Failed to execute objdump command.\n");
        free(input_path_copy);
        return EXIT_FAILURE;
    }

    printf("Disassembly saved to %s\n", output_file);

    free(input_path_copy);
    return EXIT_SUCCESS;
}
