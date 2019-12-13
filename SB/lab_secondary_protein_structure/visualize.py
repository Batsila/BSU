from pymol import cmd

f = open("result.txt","r")
text = f.read()
lines = text.split('\n')

for line in lines: 
    print(line)
    cmd.color("red", "/protein//A/" + line)