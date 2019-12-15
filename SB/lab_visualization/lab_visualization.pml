fetch 1ubq
bbPlane

fetch 1a00
as cartoon
color orange, chain A+C
color marine, chain B+D

show sticks, not polymer
orient resn HEM and chain A
color atomic, not elem C

#Exercises 1
fetch 2x1g
extract new_object, chain C+D+G
get_chains new_object
get_chains 2x1g
alter new_object(chain C),chain='A'
alter new_object(chain D),chain='B'
alter new_object(chain G),chain='F'

#Exercises 2
fetch 1t46
alter 1t46(resi 565),resi=1
rebuild
sort

#Exercises 3
set_key F1, bg_color white
set_key F2, bg_color black
set_key F3, set seq_view, 1
set_key F4, set seq_view, 0

alias ligand_zoom, orient organic
set_key F6, ligand_zoom

alias nice, as cartoon; show sticks, organic; show spheres, inorganic
set_key F5, nice