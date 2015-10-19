class Scanner
    $inputFile
    $currentChar
    $inputArray

    $rcounterup=0

    $variableCounter=0

    $outputArray=Array.new
    $calcArray=Array.new

    def init(file_name)
    	#new input file and new array for the input file are made
    	$inputFile=File.new(file_name,"rb")
       	$inputArray=Array.new

       	#if the input file exists then the next_token method is called
       	if $inputFile
       		next_token
       		
       		#$inputArray.each do |x|   #prints original $inputArray with comments split into many tokens
       		#	puts x
       		#end
       	else
       		puts "Not able to open file."
    	end 

        retokenize	
        makeTokenArray
        tokenCalcRetoken
    end

    def retokenize()
        #---------------------
        #retokenizes to make sure comments containing blank spaces are single tokens
        stringChar="\""
        commentChar="/"
        spaceChar=""
        endLineChar="\r"
        inString=""
        $newTokenArray=Array.new

        i=0
        while (i<$inputArray.length)
            inString=""
            
            if $inputArray[i]==commentChar && $inputArray[i+1]==spaceChar && $inputArray[i+2]==commentChar 
                
                inString<<"//"
                
                for counter in (i+3)..$inputArray.length-1
                    if $inputArray[counter].include? endLineChar then
                        inString<< " "
                        temp=$inputArray[counter].delete(endLineChar)
                        inString<<temp
                        break
                        #here need to update the value for i
                    end
                    inString<< " "
                    inString<<$inputArray[counter]
                    
                end
                #puts inString
                $newTokenArray<<inString
                i=counter+1
                instring=""
                next
            end


            if $inputArray[i]=="&" && $inputArray[i+1]==spaceChar && $inputArray[i+2]=="&"
                inString<<$inputArray[i]
                inString<<$inputArray[i+2]
                $newTokenArray<<inString
                i=i+3
                instring=""
                next
            end

            if $inputArray[i]=="|" && $inputArray[i+1]==spaceChar && $inputArray[i+2]=="|"
                inString<<$inputArray[i]
                inString<<$inputArray[i+2]
                $newTokenArray<<inString
                i=i+3
                instring=""
                next
            end

            if $inputArray[i]=="=" && $inputArray[i+1]==spaceChar && $inputArray[i+2]=="="
                inString<<$inputArray[i]
                inString<<$inputArray[i+2]
                $newTokenArray<<inString
                i=i+3
                instring=""
                next
            end

            if $inputArray[i]=="!" && $inputArray[i+1]==spaceChar && $inputArray[i+2]=="="
                inString<<$inputArray[i]
                inString<<$inputArray[i+2]
                $newTokenArray<<inString
                i=i+3
                instring=""
                next
            end

            if $inputArray[i]=="!" && $inputArray[i+1]=="="
                inString<<$inputArray[i]
                inString<<$inputArray[i+1]
                $newTokenArray<<inString
                i=i+2
                instring=""
                next
            end

            if $inputArray[i]==">" && $inputArray[i+1]==spaceChar && $inputArray[i+2]=="="
                inString<<$inputArray[i]
                inString<<$inputArray[i+2]
                $newTokenArray<<inString
                i=i+3
                instring=""
                next
            end

            if $inputArray[i]=="<" && $inputArray[i+1]==spaceChar && $inputArray[i+2]=="="
                inString<<$inputArray[i]
                inString<<$inputArray[i+2]
                $newTokenArray<<inString
                i=i+3
                instring=""
                next
            end

            #checking for strings containg spaces 
            if $inputArray[i].count(stringChar)==1
                #puts "FOUND"
            #if $inputArray[i].include? stringChar 
                inString<<$inputArray[i]
                #puts inString
                
                for counter in (i+1)..$inputArray.length-1
                    if $inputArray[counter].include? stringChar then
                        inString<< " "
                        inString<<$inputArray[counter]
                        break
                        #here need to update the value for i
                    end
                    inString<< " "
                    inString<<$inputArray[counter]

                end
                #puts inString
                $newTokenArray<<inString
                i=counter+1
                instring=""
                next
            end

            newString=$inputArray[i]
            if newString.start_with?("\t")
                newString.slice!("\t")
                while newString.start_with?("\t")
                    newString.slice!("\t")
                end

                $newTokenArray<<newString
                i+=1
                next
            end

            inString=""
            $newTokenArray<<$inputArray[i]
            i+=1
        end
        #---------------------

    end

    #this function makes the output array, not including the tokens that are blanks
    def makeTokenArray()
        $newTokenArray.each do |x| #could use $inputArray, but then comments would be split into diff. tokens
            newToken=Tokenizer.new(x)
            if newToken.returnType=="ERROR"
                puts "Problem with input token"
                break
            elsif newToken.returnType=="blankspace"
                next
            end
            $outputArray<<newToken
        end
    end

    def tokenCalcRetoken()
        $outputArray.each do |x|
            if x.returnType=="identifier"
                if x.returnData[0]=="/" && x.returnData[1]=="/"
                    newTokenCalc=TokenCalc.new(x.returnData,"metaStatement")
                    $calcArray<<newTokenCalc
                else
                    newTokenCalc=TokenCalc.new(x.returnData,"identifier")
                    $variableCounter+=1
                    $calcArray<<newTokenCalc  
                end
            #elsif x.returnType=="reservedWord"
            #    newTokenCalc=TokenCalc.new(x.returnData,"identifier")
            #    $calcArray<<newTokenCalc
            else
                newTokenCalc=TokenCalc.new(x.returnData,x.returnType)
                $calcArray<<newTokenCalc
            end
        end
        finalEndLineCharacter=TokenCalc.new("$$","eof")
        $calcArray<<finalEndLineCharacter
    end

    #next_token method takes in the input file and reads it character by character.
    #the method runs until the eof and checks whether a character is not a symbol,
    #(meaning it is in the letter or number array) and not a blank.
    def next_token()
    	inputString=""
    	#the arrays used for checking input characters from input file.
    	letterArray=Array["a","A","b","B","c","C","d","D","e","E","f","F","g","G","h","H","i","I","j","J","k","K","l","L","m","M","n","N","o","O","p","P","q","Q","r","R","s","S","t","T","u","U","v","V","w","W","x","X","y","Y","z","Z"]
    	numberArray=Array["0","1","2","3","4","5","6","7","8","9"]
    	symbolArray=Array["(",")","{","}","[","]",",",";","+","-","*","/","==","!=",">",">=","<","<=","=","&&","||","&","|"]
    
        

    	while !$inputFile.eof?
    		$currentChar=$inputFile.getc
    		
    		x=letterArray.include? $currentChar
    		y=numberArray.include? $currentChar
    		z=symbolArray.include? $currentChar
    		w=$currentChar!=" "
            v=$currentChar!="\n"
            v1=$currentChar!="\r"
            v2=$currentChar!="\t"

            #subroutine for finding and recording meta statements
            if $currentChar=="#"
                inputString<<$currentChar

                @testerBol=1
                while @testerBol==1
                    $currentChar=$inputFile.getc
                    if $currentChar=="\n"||$currentChar=="\r"
                        @testerBol=0
                        break
                    end
                    inputString<<$currentChar
                end
                $inputArray<<inputString
                inputString=""
                next
            end

    		#if the current character is not a symbol, or a space
    		#(meaning a number or letter) the method keeps reading the next character.
    		#once a blank space is reached, that is the end of the variable, string or method name
    		#hence it is recorded in the input array as an element.
        	
        	if !z&&w&&v
    			inputString<<$currentChar
    		elsif $currentChar==" " 
    			$inputArray<<inputString
    			inputString=""
            elsif $currentChar=="\n" || $currentChar=="\r" || $currentChar=="\t" 
                $inputArray<<inputString
                inputString=""    
    		#if the input character is a symbol or blank space, the current input string
    		#is put into the input array
    		else 
    			$inputArray<<inputString
    			inputString=""
    			$inputArray<<$currentChar
    		end
            
    	end
   	end

end

class Tokenizer
	#an initialization of a token records the token's data.
	#the the elementType method is called to identify the token's type.
	def initialize(element)
		@data=element
		elementType
	end

	#return method for type to be used when running the script.
	def returnType()
		return @type
	end

	#return method for data to be used when running the script.
	def returnData()
		return @data
	end 

	#when a token is made in the main method, 
	#this method is called for the token instance.
	def elementType()
		symbolArray=Array["(",")","{","}","[","]",",",";","+","-","*","/","==","!=",">",">=","<","<=","=","&&","||","&","|"]
		reservedArray=Array["int","void","if","while", "for", "return","continue","break","scanf","printf"] #,"main"
       	numberArray=Array["0","1","2","3","4","5","6","7","8","9"]
       	letterArray=Array["a","A","b","B","c","C","d","D","e","E","f","F","g","G","h","H","i","I","j","J","k","K","l","L","m","M","n","N","o","O","p","P","q","Q","r","R","s","S","t","T","u","U","v","V","w","W","x","X","y","Y","z","Z"]
    	metaArray=Array["#","//"]
    	miscArray=Array["_"]
    	blankArray=Array[" "]

    	#the method takes the token and checks if it is a symbol, reserved word,
		#string, meta statement, number or identifier.
		if symbolArray.include? @data
			@type="symbol"
		elsif reservedArray.include? @data
			@type="reservedWord"
		elsif @data=="" || @data=="\n" || @data=="\r" || @data=="\t"
			@type="blankspace"
		else
			if @data[0]=="\""
				@type="string"
			#the method makes sure that no token starts with a "_" 
			#and also checks if the token is a meta statement.
			elsif miscArray.include? @data[0]
				@type="ERROR"
				puts "ERROR, incorrect token"
			elsif metaArray.include? @data[0]
				@type="metaStatement"

			#I've originally had trouble here, but I've fixed it. 
			elsif numberArray.include? @data[0]
				x=0
				for i in 0..@data.length
					if letterArray.include? @data[i]
						x=1
					end
				end
				if x==1
					@type="ERROR"
					puts "ERROR, incorrect token"
				else
					@type="number"
				end
			else
				@type="identifier"
				#@data<<"_cs254" #the _cs254 identifier is no longer needed in this parser implementation
			end
		end
	end
end

class TokenCalc
    def initialize(data,tok)
        @data=data
        @tok=tok 
    end
    #return method for type to be used when running the script.
    def returnTok()
        return @tok
    end
    #return method for data to be used when running the script.
    def returnData()
        return @data
    end 

    def setData(x)
        @data=x
    end    
end







