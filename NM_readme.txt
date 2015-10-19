——————————————————————————————
Readme: Assignment 6 Compiler: The 5th and Final Part: Function Code Generation

Nikita Miroshnichenko
Student ID: 27554869
——————————————————————————————

Overview:
I have worked on generating assembly-like code for the given C subset language and have made a working output file for input ab.c and a semi-working output file for the other test files. I will explain what has worked and what has not in the next section. 

I’ve implemented a jumptable instead of using GNU.
——————————————————————————————

To run the assignment in terminal:

ruby compiler example.c
(where example.c can be replaced by the filename which you want to parse)
(the output compiled c file is outputFile.c)

Files:
compiler.rb	(Main caller file)
parser.rb	(Parser and Compiler)
scanner.rb	(Tokenizer)
evaluation.rb	(Expression evaluation file)
outputFile.c	(The file displaying the compiled output program)

——————————————————————————————

Report: 
I’ve been working very hard to make my code more modular and correctly using the previous parts of this assignment. Earlier, when I was working on the previous project parts I misunderstood what the final goal entailed and moreover what it required. Some parts of my parser were not fit to deal with function code generation so I had to make a large (function code generation) method, which was triggered by global flags triggered from respective parts in the parser process. The function code generation method (called funcGeneration in my parser.rb file) is used to generate function code for the new language, make the respective labels and also generate the jumptable.

Through this project I’ve learned how the stack in such a compiler would work and below I will explain how I have implemented my own stack.


|_________| M[3]
|_________| M[2] -> JUMP
|_________| M[1] -> BASE
|_________| M[0] -> TOP

I declared a new int main(void) function that stored all of the generated function code for the input file. The original main() method form the input file is converted in the Labelmain and its return is LabelmainReturn. The function generation method does the same procedure respectfully for all of the declared functions within the input file. 

Before the Labelmain is called (which is the first label to be called in each generated code function), the int main(void) method declares the positions of the current TOP, BASE and JUMP in the M[0], M[1] and M[2] locations.

|____0____| M[3]
|_________| M[2] -> JUMP
|____4____| M[1] -> BASE
|____3____| M[0] -> TOP

Once a new function label is made, the stack is incremented based on the number of declared local variables. For instance, in binrep.c the main’s function label (Labelmain) would have TOP = BASE + 2 as there is one variable declared within the function. The layout for main in the generated code file has the top move to:
		TOP = BASE + 2
(Because of) 	M[BASE+0] = 0
Looking at the recursedigit method (which becomes Labelrecursedigit in the generated file) where two local variables are used, the output generated file has the top move to:
		TOP = BASE + 3
Because of the declaration of the two variables below the Top. 

The return labels used for each function label move the TOP and BASE and reassign the value for JUMP for the program to know where to go through the jumptable. These return labels use the jumptable and based on the JUMP value choose the correct case to go to the label generated after the function call. So for the instance of LabelrecursedigitReturn, the label leads to the jumptable which in turn leads to the label right after the original call to Labelrecursedigit. 

To put the base pointer back to where it was before the function call, the LabelrecursedigitReturn decrements the TOP, BASE and JUMP values back as:
		JUMP = M[BASE - 1]
		TOP = M[BASE - 3]
		BASE = M[BASE - 4]
		goto jumpTable
This is the epilogue and it leads to the goto jumptable to decide where to go back to. And the position M[BASE - 2] is left empty for the purpose of storing the return value, if there is one.

I’ve worked on completing the prologue and epilogue of function calls and they properly work for ab.c and partially-work for other files because of Label mis-numberings. Once a function is called, a prologue is generated which increments the TOP, BASE and JUMP in relation to how many parameters are passed. 

The jumptable is generated at the end of the newly generated code file. This jumptable is used for parameterized gotos. Above it, I generate a list for gotos used for If-statements. 

————————————————————————————————————————————————
I’ve had the following results when compiling my generated programs in gcc:

ab.c : gave no errors, and has no errors in label numberings.

binrep.c : gives errors due to label mis-numberbings, which I was not able to fix. Nonetheless, the prologue/epilogue implementations work as described in lecture.

Other files generate errors in compiling because of label mis-numberings and failure in some parts of function generation.

Finally, the automaton.c file failed in the compiling process when using my parser.rb. The issues arise in the <functiongeneration> method within my parser.rb file, when n empty token is met. I was not able to fix this problem.
————————————————————————————————————————————————

As an overview of the whole compiler project, I want to list what I have been able and not able to do:

Part1: Tokenizer:
-I have correctly implemented the tokenizer and have fixed any bugs that my previously submitted tokenizer had.

Part2: Calculator:
-I have correctly implemented the described functions for the calculator. I have used the calculator in my expression evaluation method and have put it into the evaluation.rb file.

Part3: Parser:
-I have fixed all of the problems that my parser had before. I’ve implemented correct LL grammar and a correct parsing procedure.

Part 4: Intra-Function Code Generation:
-My compiler prints out the meta-statements into the output file
-I was not able to implement the new assignment statement where at most 2 operands on the right-hand side can be used.
-I was able to implement intra-function gotos for If-statements but not While-statements.
-I have removed the use of variables locally and globally and have put them into the global and local arrays. 

Part 5: Function Code Generation
-I have put all of the global and local variables into int M[1000] array, whose large size of 1000 was set arbitrarily in assumption that this size would be enough to use on the test cases.
-I was not able to put the parameters into the new int M[1000] array.
-I’ve made the new generated code have no functions but the main()/printf()/scanf()/read()/write(). My code generator would make make all other functions into labels.
-I have used a jumptable for parameterized gotos.
-I did not do the extra credit.

————————————————————————————————————————————————
My parser grammar:

<program>—> <metaStatements> <typeName> <id> <start> $$
<start>—> <startDataDecls> <funcList> | <startFuncList>
<startFuncList>—> ( <parameterList> ) <funcTail> <funcList>
<metaStatements>—> metaStatement <metaStatements> | empty

<funcList>—> <func> <funcList> | empty
<func>—> <funcDecl> <funcTail>
<funcTail>—> ; | { <dataDecls> <statements> }
<funcDecl>—> <typeName> ID ( <parameterList> )
<dataDecls>—> <typeName> <idList> ; <dataDecls> | empty

<typeName>—> int | void
<parameterList>-> void | <nonEmptyList> | empty
<nonEmptyList>-->  ID <nonEmptyListTail>
<nonEmptyListTail>—> , <nonEmptyList> | empty

<idList>—> <id> <idListTail>
<idListTail>—> , <id> <idListTail> | empty
<id>—> ID <idTail>
<idTail>—> [ <expression> ] | empty

<expressionList>—> <nonEmptyExpressionList> | empty
<nonEmptyExpressionList>—> <expression> <nonEmptyExpressionListTail>
<nonEmptyExpressionListTail>—> , <expression> | empty

<expression>—> <term> <termTail>
<expressionTail>—> <addop> <expression> | empty
<mulop>—> * | /
<addop>—> + | -
<term>—> <factor> <termTail>
<termTail>—> <mulop> <term> | empty
<factor>—> ID <factorTail> | Number | - Number | ( <expression> )
<factorIdTail>—>  [ <expression> ] |  ( <expressionList> ) | empty

<statements>—> <statement> <statements> | empty
<statement>—> ID <generalStatement> | <printfFuncCall> | <scanfFuncCall> | <ifStatement> |  <whileStatement> | <returnStatement> | <breakStatement> | <continueStatement> 

<generalStatement>—> <assignment> | <generalFuncCall>
<assignment>—> <idTail> = <expression> ;
<generalFuncCall>—> ( <expressionList> ) ; 

<printfFuncCall>—>  printf ( String <printfFuncCallTail> ) ; 
<printfFuncCallTail>—> , <expression> | empty
<scanfFuncCall>—> scanf ( String , & <expression> ) ;

<blockStatements>—> { <statements> }
<ifStatement>—> if ( <conditionExpression> ) <blockStatements> <elseStatement>
<elseStatement>—> else <blockStatements> | empty
<comparisonOp>—> == | != | > | >= | < | <=
<whileStatement>—> while ( <conditionExpression> ) <blockStatements>
<returnStatement>—> return <returnExpressionTail> ;
<returnStatementTail>—> <expression> | empty
<breakStatement>—> break ;
<continueStatement>—> continue;

<conditionExpression>—> <condition> <conditionExpressionTail>
<conditionExpressionTail>—> <conditionOp> <condition> | empty
<conditionOp>—> $$ | ||
<condition>—> <expression> <comparisonOp> <expression>

————————————————————————————————————————————————
Conclusion: 

I have learned a lot by doing this project. I have spent a very large amount of time on working around many different problems that I have encountered because of my parser implementation. Although I was not able to make the my compiled code work for all of the test files, I’m still very happy that I’ve managed to make it work for ab.c and for most of binrep.c. My generated code has trouble dealing with recursion, which is very important in the other files. Due to recursion, my generated code has label mis-numberings and therefore fails in compilation by gcc. Nonetheless, I have learned a great deal by working on this project and redoing parts of the assignments that I implemented incorrectly before.

————————————————————————————————————————————————


Resources:
http://www.cs.cornell.edu/courses/cs4120/2013fa/lectures/lec05-fa13.pdf
http://www.montefiore.ulg.ac.be/~geurts/Cours/compil/2012/03-syntaxanalysis-2-2012-2013.pdf
http://pages.cpsc.ucalgary.ca/~robin/class/411/LL1.3.html