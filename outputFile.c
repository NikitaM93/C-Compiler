#include <stdio.h>
#define read(x) scanf("%d",&x)
#define write(x) printf("%d\n",x)
#include <assert.h>
 #define TOP M[0]
 #define BASE M[1]
 #define JUMP M[2]
 int M[1000];
 int main(void){
 TOP = 3;
 M[TOP] = 0;
 BASE = TOP + 1;
 goto Labelmain;

 Labelrecursedigit:; TOP = BASE + 6;
 M[BASE+1] ;
if ( M[BASE+2] == n ) goto Label1  ;
Label2:;
 M[BASE+1] = M[BASE+2] ;
if ( M[BASE+2] != ( n - ( ( n / M[BASE+3] ) * M[BASE+3] ) ) ) goto Label3  ;
Label4:;
 goto Label9;

 Label9:;
 M[TOP + 0] = n/M[BASE+3];
 M[TOP + 1] = BASE;
M[TOP + 2] = TOP;
M[TOP + 4] = 1;
BASE = TOP + 5;
goto Labelrecursedigit;

 Label10:;   if ( M[BASE+2] == M[BASE+1] ) goto Label5  ;
Label6:;
 if ( M[BASE+4] == M[BASE+1] ) goto Label7  ;
Label8:;
 

LabelrecursedigitReturn:;
JUMP = M[BASE - 1];
TOP = M[BASE - 3];
BASE = M[BASE - 4];
goto jumpTable;

 Labelmain:; TOP = BASE + 3;
 M[BASE+0] ;
M[BASE+0] = M[BASE+1] ;
while ( M[BASE+1] >= M[BASE+0] ) { printf ( "Give me a number: " ) ;
read ( M[BASE+0] ) ;
if ( M[BASE+1] >= M[BASE+0] ) goto Label11  ;
Label12:;
 }
printf ( "The binary representation of: " ) ;
write ( M[BASE+0] ) ;
printf ( "is: " ) ;
goto Label13;

 Label13:;
 M[TOP + 0] = M[BASE+0];
 M[TOP + 1] = BASE;
M[TOP + 2] = TOP;
M[TOP + 4] = 2;
BASE = TOP + 5;
goto Labelrecursedigit;

 Label14:; printf ( "\n\n" ) ;


LabelmainReturn:;
JUMP = M[BASE - 1];
TOP = M[BASE - 3];
BASE = M[BASE - 4];
goto jumpTable;

 Label1:;  return ;
 goto Label2;

 Label3:;  M[BASE+1] = M[BASE+4] ;
 goto Label4;

 Label5:;  printf ( "0" ) ;
 goto Label6;

 Label7:;  printf ( "1" ) ;
 goto Label8;

 Label11:;  printf ( "I need a positive integer.\n" ) ;
 goto Label12;

 

jumpTable:;
switch ( JUMP )
{
case 0: exit(0);
case 1: Label10;
case 2: Label14;
 default: assert(0);
}
 }
 