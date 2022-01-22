#include <corelib.h>
#include <stdio.h>
int main ()
{

 int n, i;
    unsigned long long fact = 1;

	n= 10;
    // shows error if the user enters a negative integer
    if (n < 0)
        return fact;
    else {
        for (i = 1; i <= n; ++i) {
            fact *= i;
        }
        //printf("Factorial of %d = %llu", n, fact);
    }

    return fact;


}