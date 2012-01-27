MXMLC = ./fcsh-wrap
#MXMLC = mxmlc
#MXMLC = fcsh
OPTIONS = -static-link-runtime-shared-libraries=true\ 
	  -debug=true
FLIXEL = src
SRC = src/*.as
MAIN = src/main.as
SWF = bin/leap.swf

$(SWF) : $(SRC) clean
	$(MXMLC) $(OPTIONS) -sp $(FLIXEL) -o $(SWF) -- $(MAIN)

clean :
	rm -f $(SWF)
