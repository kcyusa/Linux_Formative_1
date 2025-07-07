ALU linux programming Formative 1

# How to run the question 1 program
 - compile : gcc -C Question1.c -o q1
 - Run: ./q1 <path to elf file>

# How to run the question 2 program
 - compile : nasm -f elf32 Question2.asm -o q2.o
 - run: ld -m elf_i386 q2.o -o q2
 - Run: ./q2

# How to run the question 3 program
 - move to question3 folder: cd question3
 - Run:  python3 iot_dashboard.py

# How to run the question 4 program
 - move to question4 folder: cd question4
 - compile: gcc -o diary_manager diary_manager.c -L. -ldiary
 - run: export LD_LIBRARY_PATH=.
 - Run: ./diary_manager