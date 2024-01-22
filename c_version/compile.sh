gcc -O2 stdout_tester.c -o stdout_tester
gcc -DFLIP -O2 stdout_tester.c -o stdout_tester_reversed_bits
gcc simple_test.c -o simple_test
./simple_test