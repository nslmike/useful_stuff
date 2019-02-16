
set sites [get_sites SLICE_*]
foreach x $sites {
   set prop [get_property SITE_TYPE $x]
   if { $prop == "SLICEM" } {
      lappend slicem_list $x
   }
}
llength $slicem_list
