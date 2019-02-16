
set sites [get_sites *]
set type {}
foreach x $sites {
   set prop [get_property SITE_TYPE $x]
   if { [lsearch -exact $type $prop] == -1 } {
      lappend type $prop
   }
}

foreach y $type {
   puts "SITE_TYPE: $y"
}
