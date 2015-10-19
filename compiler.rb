require_relative 'parser.rb'

#generated code array for the output program
$genCodeArray=Array.new

#this is the main calls used to call the tokenizer and parser procedure
#on an input file.
#the tokenizing procedure tokenizes twice, the second retoknization is used
#to check for any tricky cases that have end of line characters, meta statements and etc..
#the outputFile shows the tokenized tokens from the input file.
#the outputFileChecker (makde in the tokenizer) shows the tokens from the file 
#before they have been completely and correctly retokenized. 

newFileTester=ARGV[0]
object=Scanner.new
object.init newFileTester

#token tester file:
#outputFileMain=File.new("tokens.txt", "w")
#outputFileMain.write($calcArray)

object2=Parser.new
object2.parse
#the counters of variables, functions and statements are printed out in the event 
#of a successful parse of the input file.

puts"-------------------"

#puts"#{$genCodeArray}"

#the following script creates the output.c file.
#this output file will have the compiled version of the input program from ARGV[0].
for i in 0..$genCodeArray.length-1

    if $genCodeArray[i].returnData==";" || $genCodeArray[i].returnData=="}"
        #print"#{x.returnData}\n"
        $outputFile.write("#{$genCodeArray[i].returnData}\n")
        i+=1
    elsif $genCodeArray[i].returnTok=="metaStatement"
        $outputFile.write("#{$genCodeArray[i].returnData}\n")
        #if $genCodeArray[i+1].returnTok!="metaStatement"
        #    $outputFile.write("int lvar[#{$localvar.length}];\n")
        #end
        i+=1
    elsif $genCodeArray[i].returnData=="$$"
        i+=1
    else
        $outputFile.write("#{$genCodeArray[i].returnData} ")
        #print"#{x.returnData} "
        i+=1
    end
end 

#main terminal output
puts"-------------------"

#puts"#{$globalvar}"
#puts"#{$localvar}"
$finalGenCodeArray=Array.new

puts"#{$masterLocalArray}"

puts"-------------------"

puts "Parser Passed."
puts "Variables: #{$vars.length}"
puts "Functions: #{$funcs.length}"
puts "Statements: #{$states.length}"

puts"-------------------"
#puts "#{$maybeFuncArray}"


#I was not able to finish on this call. 
#this script was meant to be used to find the correct insertion point for local array declarations.
i=0
j=0

# while (i<$genCodeArray.length)
#     if $funcs.include? $genCodeArray[i].returnData
#         $finalGenCodeArray<<$genCodeArray[i]
#         $funcs.delete $genCodeArray[i].returnData
#         for counter in (i+1)..$inputArray.length-1
#             if $genCodeArray[i].returnData=="{"
#                 $finalGenCodeArray<<$genCodeArray[i]
#                 temp=TokenCalc.new("lvar#{$masterLocalArray[j].length};","identifier")
#                 $finalGenCodeArray<<temp
#                 j+=1
#                 i=counter+2
#                 break
#             else 
#                 $finalGenCodeArray<<$genCodeArray[i]
#                 i+=1
#             end
#         end
#         #puts $genCodeArray[i]
#     else
#         $finalGenCodeArray<<$genCodeArray[i]
#         i+=1
#     end 
# end
