
#include "user.h"
#include "types.h"
#include "fcntl.h"
#include "stat.h"


int main(int argc, char *argv[]){

int num;
printf(1,"enter the corresponding systemCall number:\n");
scanf("%d",&num);

printf(1,"the number of times this systemCall has been invoked is: %d times\n",getCount(num));

    exit();

}