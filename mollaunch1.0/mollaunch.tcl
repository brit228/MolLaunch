# mollaunch.tcl
# 	Basic launch software for Visual Molecular Dynamics (VMD) for 
# 	preloaded example molecules and molecules from Protein Data Bank
# 	using preloaded archive file.
# 
# 	Authors:	Michael Beck and Harish Vashisth
# 
# 	Please send feature requests and bug reports to
# 	mpj59@wildcats.unh.edu. Thank you.
# 
# 	All Rights Reserverd.

package provide mollaunch 1.0
package require http 2.5

## Global Namespace

namespace eval ::mollaunch:: {
	namespace export mollaunch

	variable examplemoleculetype ""
	variable examplemoleculename ""
	variable pdbmoleculeid ID#
	variable pdbmoleculesearch None
	variable pdbmoleculeentry Search Name
	variable pdbmoleculeresult ""
	variable additiontypepdb
	variable additiontype
	variable pdbarr
	variable pdblist [list]
	variable entrieslist
	variable dir "[pwd]/plugins/noarch/tcl/mollaunch1.0/Examples/"
	variable modifydraw
	variable modifycolor
	variable modifymaterial
	variable modifybg 16
	variable moleculeinfo ""
	variable w
}

## Main Procedure

proc ::mollaunch::mollaunch {} {
	variable w

################################################################################
#                                  GUI SETUP                                   #
################################################################################

	if {[winfo exists .mollaunch]} {
		wm deiconify $w
		return
	}

	set w [toplevel ".mollaunch"]
	wm title $w "MolLaunch : Molecular Launcher for PDB and Example Molecules"
	wm resizable $w 0 0;

## Creates list of pdb files

	::mollaunch::createpdbarr

## Examples section of GUI

	labelframe $w.examples -text "Examples" -font {-weight bold}
	label $w.examples.type -text "Type: "
	listbox $w.examples.typelist -height 10 -width 15
	::mollaunch::addtypes
	bind $w.examples.typelist <<ListboxSelect>> {::mollaunch::settype [$::mollaunch::w.examples.typelist curselection]}
	label $w.examples.molecule -text "Molecule: "
	listbox $w.examples.moleculelist -height 10 -width 40 -selectmode single
	bind $w.examples.moleculelist <<ListboxSelect>> {::mollaunch::setmolecule [$::mollaunch::w.examples.moleculelist curselection]}
	label $w.examples.pathlabel -text "Molecule selected:" -font {-weight bold}
	label $w.examples.path -text "None" -font {-weight bold}
	
## Info Section of GUI

	labelframe $w.info -text "Molecule Info" -font {-weight bold}
	frame $w.info.frame -width 270 -height 130
	label $w.info.frame.info -text "\n\n\n" -justify left
	button $w.info.copy -text "Copy Info to Clipboard" -command {::mollaunch::clipboardcopy}

## PDB Section of GUI

	labelframe $w.pdb -text "PDB Search" -font {-weight bold}
	label $w.pdb.id -text "Molecule ID: "
	entry $w.pdb.idsearch -textvariable ::mollaunch::pdbmoleculeid
	label $w.pdb.name -text "Search by name: "
	entry $w.pdb.namesearch -textvariable ::mollaunch::pdbmoleculeentry
	button $w.pdb.namebutton -text SEARCH -command "::mollaunch::search"
	label $w.pdb.namesearchlabel -text "Search term: "
	label $w.pdb.namesearchterm -text ""
	frame $w.pdb.framed -height 220 -width 500
	listbox $w.pdb.framed.nameresults -width 70
	bind $w.pdb.framed.nameresults <<ListboxSelect>> {::mollaunch::setsearchresult}
	scrollbar $w.pdb.framed.nameresultsscroll -command [list $w.pdb.framed.nameresults yview]
	scrollbar $w.pdb.framed.horizontalscroll -command [list $w.pdb.framed.nameresults xview] -orient horizontal
	label $w.pdb.framed.nameselect -text "Selected result: " -font {-weight bold}
	radiobutton $w.pdb.selectID -variable additiontypepdb -value ID -text "Add by Molecule ID"
	radiobutton $w.pdb.selectname -variable additiontypepdb -value name -text "Add by Molecule Name"

## Modify molecule section of GUI

	labelframe $w.lf_mod -text "Modify Molecule" -font {-weight bold}
	labelframe $w.lf_mod.draw -text "Drawing Method"
	labelframe $w.lf_mod.color -text "Color"
	labelframe $w.lf_mod.material -text "Material"
	labelframe $w.lf_mod.background -text "Background"
	radiobutton $w.lf_mod.draw.lines -variable ::mollaunch::modifydraw -value Lines -text Lines -indicatoron 0
	radiobutton $w.lf_mod.draw.vwd -variable ::mollaunch::modifydraw -value VDW -text "VDW (Van der Waals)" -indicatoron 0
	radiobutton $w.lf_mod.draw.ribbon -variable ::mollaunch::modifydraw -value Ribbons -text Ribbons -indicatoron 0
	radiobutton $w.lf_mod.draw.newribbon -variable ::mollaunch::modifydraw -value NewRibbons -text "New Ribbons" -indicatoron 0
	radiobutton $w.lf_mod.draw.cartoon -variable ::mollaunch::modifydraw -value Cartoon -text Cartoon -indicatoron 0
	radiobutton $w.lf_mod.draw.newcartoon -variable ::mollaunch::modifydraw -value NewCartoon -text "New Cartoon" -indicatoron 0
	radiobutton $w.lf_mod.draw.licorice -variable ::mollaunch::modifydraw -value Licorice -text Licorice -indicatoron 0
	radiobutton $w.lf_mod.draw.surf -variable ::mollaunch::modifydraw -value Surf -text Surf -indicatoron 0
	radiobutton $w.lf_mod.draw.quicksurf -variable ::mollaunch::modifydraw -value QuickSurf -text "Quick Surf" -indicatoron 0
	radiobutton $w.lf_mod.draw.cpk -variable ::mollaunch::modifydraw -value CPK -text CPK -indicatoron 0
	radiobutton $w.lf_mod.draw.paperchain -variable ::mollaunch::modifydraw -value PaperChain -text "Paper Chain" -indicatoron 0
	radiobutton $w.lf_mod.draw.beads -variable ::mollaunch::modifydraw -value Beads -text Beads -indicatoron 0
	radiobutton $w.lf_mod.color.default -text Default -variable ::mollaunch::modifycolor -value default -indicatoron 0
	radiobutton $w.lf_mod.color.red -text Red -variable ::mollaunch::modifycolor -value 1 -bg red -indicatoron 0
	radiobutton $w.lf_mod.color.green -text Green -variable ::mollaunch::modifycolor -value 7 -bg green -indicatoron 0
	radiobutton $w.lf_mod.color.blue -text Blue -variable ::mollaunch::modifycolor -value 0 -bg blue -indicatoron 0
	radiobutton $w.lf_mod.color.yellow -text Yellow -variable ::mollaunch::modifycolor -value 4 -bg yellow -indicatoron 0
	radiobutton $w.lf_mod.color.orange -text Orange -variable ::mollaunch::modifycolor -value 3 -bg orange -indicatoron 0
	radiobutton $w.lf_mod.material.opaque -text Opaque -variable ::mollaunch::modifymaterial -value Opaque -indicatoron 0
	radiobutton $w.lf_mod.material.glossy -text Glossy -variable ::mollaunch::modifymaterial -value Glossy -indicatoron 0
	radiobutton $w.lf_mod.material.diffuse -text Diffuse -variable ::mollaunch::modifymaterial -value Diffuse -indicatoron 0
	radiobutton $w.lf_mod.material.transparent -text Transparent -variable ::mollaunch::modifymaterial -value Transparent -indicatoron 0
	radiobutton $w.lf_mod.background.white -text White -variable ::mollaunch::modifybg -value 8 -indicatoron 0 -command "color Display Background 8"
	radiobutton $w.lf_mod.background.black -text Black -variable ::mollaunch::modifybg -value 16 -indicatoron 0 -command "color Display Background 16"
	radiobutton $w.lf_mod.background.gray -text Gray -variable ::mollaunch::modifybg -value 2 -indicatoron 0 -command "color Display Background 2"

## Buttons section of GUI

	labelframe $w.buttons -text "Add Molecule" -pady 2 -font {-weight bold}
	radiobutton $w.buttons.selectexample -variable additiontype -value example -text "Add Molecule from Examples"
	radiobutton $w.buttons.selectpdb -variable additiontype -value pdb -text "Add Molecule from PDB"
	button $w.buttons.add -text ADD -padx 5 -pady 5 -command "::mollaunch::results" -background green 
	button $w.buttons.modify -text Modify -command "::mollaunch::spinboxmodify" -background yellow
	button $w.buttons.delete -text Delete -command "::mollaunch::spinboxdelete" -background red
	spinbox $w.buttons.spin -values [list] -width 2
	bind $w <Enter> {::mollaunch::spinboxrefresh}

## Visualize different GUI sections

	grid $w.examples -padx 2 -ipady 2 -sticky nsew -row 1 -column 1 -rowspan 2
	grid $w.examples.type -in $w.examples -row 1 -column 1 -padx 2 -ipadx 2
	grid $w.examples.typelist -in $w.examples -row 2 -column 1 -padx 2 -sticky ew
	grid $w.examples.molecule -in $w.examples -row 1 -column 2 -padx 2
	grid $w.examples.moleculelist -in $w.examples -row 2 -column 2 -padx 2 -sticky ew
	grid $w.examples.pathlabel -in $w.examples -row 3 -column 1 -columnspan 2 -sticky w
	grid $w.examples.path -in $w.examples -row 4 -column 1 -columnspan 2 -sticky w


	grid $w.info -row 4 -column 2 -sticky nsew
	grid $w.info.frame -in $w.info -row 1 -column 1
	grid $w.info.frame.info -in $w.info.frame -row 1 -column 1
	grid $w.info.copy -in $w.info -row 2 -column 1
	grid propagate $w.info.frame 0


	grid $w.pdb -padx 2 -ipady 2 -sticky nsew -row 3 -column 1 -rowspan 2
	grid $w.pdb.id -in $w.pdb -row 1 -column 1 -sticky e
	grid $w.pdb.idsearch -in $w.pdb -row 1 -column 2 -sticky w
	grid $w.pdb.selectID -in $w.pdb -row 1 -column 4 -sticky w
	grid $w.pdb.name -in $w.pdb -row 2 -column 1 -sticky e
	grid $w.pdb.namesearch -in $w.pdb -row 2 -column 2 -sticky w
	grid $w.pdb.namebutton -in $w.pdb -row 2 -column 3 -sticky w
	grid $w.pdb.selectname -in $w.pdb -row 2 -column 4 -sticky w
	grid $w.pdb.namesearchlabel -in $w.pdb -row 3 -column 1 -sticky e
	grid $w.pdb.namesearchterm -in $w.pdb -row 3 -column 2 -columnspan 3 -sticky w
	grid $w.pdb.framed -in $w.pdb -row 4 -column 1 -columnspan 5
	grid $w.pdb.framed.nameresults -in $w.pdb.framed -row 1 -column 1 -sticky w
	grid $w.pdb.framed.nameresultsscroll -in $w.pdb.framed -row 1 -column 1 -sticky nse
	grid $w.pdb.framed.horizontalscroll -in $w.pdb.framed -row 2 -column 1 -sticky new
	grid $w.pdb.framed.nameselect -in $w.pdb.framed -row 3 -column 1 -sticky w
	grid propagate $w.pdb.framed 0


	grid $w.lf_mod -sticky ew -padx 2 -ipadx 2 -ipady 2 -row 1 -column 2
	grid $w.lf_mod.draw -in $w.lf_mod -row 1 -column 1 -sticky ns
	grid $w.lf_mod.color -in $w.lf_mod -row 1 -column 2 -sticky ew
	grid $w.lf_mod.material -in $w.lf_mod -row 2 -column 1 -columnspan 2
	grid $w.lf_mod.background -in $w.lf_mod -row 3 -column 1 -columnspan 2
	grid $w.lf_mod.draw.lines -in $w.lf_mod.draw -column 1 -row 1 -sticky ew
	grid $w.lf_mod.draw.vwd -in $w.lf_mod.draw -column 1 -row 2 -sticky ew
	grid $w.lf_mod.draw.licorice -in $w.lf_mod.draw -column 1 -row 3 -sticky ew
	grid $w.lf_mod.draw.ribbon -in $w.lf_mod.draw -column 1 -row 4 -sticky ew
	grid $w.lf_mod.draw.newribbon -in $w.lf_mod.draw -column 1 -row 5 -sticky ew
	grid $w.lf_mod.draw.paperchain -in $w.lf_mod.draw -column 1 -row 6 -sticky ew
	grid $w.lf_mod.draw.surf -in $w.lf_mod.draw -column 2 -row 1 -sticky ew
	grid $w.lf_mod.draw.quicksurf -in $w.lf_mod.draw -column 2 -row 2 -sticky ew
	grid $w.lf_mod.draw.cartoon -in $w.lf_mod.draw -column 2 -row 3 -sticky ew
	grid $w.lf_mod.draw.newcartoon -in $w.lf_mod.draw -column 2 -row 4 -sticky ew
	grid $w.lf_mod.draw.cpk -in $w.lf_mod.draw -column 2 -row 5 -sticky ew
	grid $w.lf_mod.draw.beads -in $w.lf_mod.draw -column 2 -row 6 -sticky ew
	grid $w.lf_mod.color.default -in $w.lf_mod.color -column 1 -row 1 -sticky ew
	grid $w.lf_mod.color.red -in $w.lf_mod.color -column 1 -row 2 -sticky ew
	grid $w.lf_mod.color.green -in $w.lf_mod.color -column 1 -row 3 -sticky ew
	grid $w.lf_mod.color.blue -in $w.lf_mod.color -column 1 -row 4 -sticky ew
	grid $w.lf_mod.color.yellow -in $w.lf_mod.color -column 1 -row 5 -sticky ew
	grid $w.lf_mod.color.orange -in $w.lf_mod.color -column 1 -row 6 -sticky ew
	grid $w.lf_mod.material.opaque -in $w.lf_mod.material -column 1 -row 1
	grid $w.lf_mod.material.glossy -in $w.lf_mod.material -column 2 -row 1
	grid $w.lf_mod.material.diffuse -in $w.lf_mod.material -column 3 -row 1
	grid $w.lf_mod.material.transparent -in $w.lf_mod.material -column 4 -row 1
	grid $w.lf_mod.background.white -in $w.lf_mod.background -column 1 -row 1
	grid $w.lf_mod.background.black -in $w.lf_mod.background -column 2 -row 1
	grid $w.lf_mod.background.gray -in $w.lf_mod.background -column 3 -row 1

	grid $w.buttons -row 2 -column 2 -rowspan 2
	grid $w.buttons.selectexample -in $w.buttons -row 1 -column 1 -sticky w -columnspan 3
	grid $w.buttons.selectpdb -in $w.buttons -row 2 -column 1 -sticky w -columnspan 3
	grid $w.buttons.add -in $w.buttons -row 3 -column 1 -rowspan 2
	grid $w.buttons.delete -in $w.buttons -row 3 -column 2 -sticky e
	grid $w.buttons.modify -in $w.buttons -row 4 -column 2 -sticky e
	grid $w.buttons.spin -in $w.buttons -row 3 -column 3 -rowspan 2

## Select default options for radiobuttons

	$w.pdb.selectname select
	$w.buttons.selectexample select
	$w.lf_mod.draw.lines select
	$w.lf_mod.color.default select
	$w.lf_mod.material.opaque select
	$w.lf_mod.background.black select
}

################################################################################
#                                GUI PROCS                                     #
################################################################################

## Examples Add Procedures

# ::mollaunch::addtypes
#	Adds example directories to listbox.

proc ::mollaunch::addtypes {} {
	variable dirvalues
	variable dirlength

	set dirvalues [glob -directory $::mollaunch::dir -type d *]
	set dirlength [string length $::mollaunch::dir]

	foreach value $dirvalues {
		$::mollaunch::w.examples.typelist insert end [string range $value $dirlength end]
	}
}

# ::mollaunch::addmolecules
# 	Adds files from selected type directory to listbox.

proc ::mollaunch::addmolecules {} {
	global dir
	global examplemoleculetype
	variable dirvalues
	variable dirlength

	set dirvalues [glob -directory "$::mollaunch::examplemoleculetype/" -nocomplain -type d *]
	set dirlength [string length "$::mollaunch::examplemoleculetype/"]
	
	foreach value $dirvalues {
		$::mollaunch::w.examples.moleculelist insert end [string range $value $dirlength end]
	}
}

## Examples Set Procedures

# ::mollaunch::settype
# 	Sets the chosen type as a namespace variable, deletes the listed
# 	files in the molecule listbox, and launches ::mollaunch::addmolecules.

proc ::mollaunch::settype {typeselection} {
	global dir
	global w

	set ::mollaunch::examplemoleculetype [lindex [glob -directory $::mollaunch::dir -nocomplain -type d *] $typeselection]
	
	$::mollaunch::w.examples.moleculelist delete 0 end
	::mollaunch::addmolecules
}

# ::mollaunch::setmolecule
# 	Sets the chosen molecule as a namespace variable and configures label
# 	in GUI to match variable.

proc ::mollaunch::setmolecule {moleculeselection} {
	global examplemoleculename
	global ::mollaunch::examplemoleculetype
	global dir

	if {$::mollaunch::examplemoleculetype != {}} {
		set ::mollaunch::examplemoleculename [lindex [glob -directory $::mollaunch::examplemoleculetype -nocomplain *] $moleculeselection]
		$::mollaunch::w.examples.path configure -text "[string range $::mollaunch::examplemoleculename [string length $examplemoleculetype/] end]"
	}
}

## PDB Procedures

# ::mollaunch::search
# 	Searches through pdb list to find search matches and configures label
# 	in GUI to match searched term.

proc ::mollaunch::search {} {
	global pdbarr
	global pdbmoleculeentry
	global w

	$::mollaunch::w.pdb.namesearchterm configure -text "$::mollaunch::pdbmoleculeentry"

	$::mollaunch::w.pdb.framed.nameresults delete 0 end
	set ::mollaunch::pdblist [list]

	foreach value $::mollaunch::pdbarr {
		if {[regexp [string toupper $::mollaunch::pdbmoleculeentry] [string toupper $value]] == {1}} {
			$::mollaunch::w.pdb.framed.nameresults insert end [string map {\t "        "} $value]
			lappend ::mollaunch::pdblist $value
		}
	}
}

# ::mollaunch::getpdb
# 	Checks to make sure molecule ID is 4 characters long and loads pdb
# 	into VMD.

proc ::mollaunch::getpdb {molID} {
	if {[string length $molID] == {4}} {
		mol pdbload $molID
	}
}

# ::mollaunch::setsearchresult
# 	Sets selected search result to namespace variable and configures
# 	label in GUI to display selected result.

proc ::mollaunch::setsearchresult {} {
	set ::mollaunch::pdbmoleculeresult [lindex $::mollaunch::pdblist [$::mollaunch::w.pdb.framed.nameresults curselection]]
	$::mollaunch::w.pdb.framed.nameselect configure -text "Selected result:  $::mollaunch::pdbmoleculeresult"
	
}

## Spinbox Procedures

# ::mollaunch::spinboxrefresh
# 	Refreshes the spinbox

proc ::mollaunch::spinboxrefresh {} {
	global spinboxlist

	set ::mollaunch::spinboxlist [molinfo list]
	$::mollaunch::w.buttons.spin configure -values $::mollaunch::spinboxlist
}

proc ::mollaunch::spinboxmodify {} {
	global spinboxlist
	global modifydraw
	global modifycolor
	global modifymaterial

	if {$::mollaunch::modifycolor == {default}} {
		mol modcolor 0 [$::mollaunch::w.buttons.spin get] name
	} else {
		mol modcolor 0 [$::mollaunch::w.buttons.spin get] colorid $::mollaunch::modifycolor
	}
	mol modstyle 0 [$::mollaunch::w.buttons.spin get] $::mollaunch::modifydraw
	mol modmaterial 0 [$::mollaunch::w.buttons.spin get] $::mollaunch::modifymaterial
	color Display Background $::mollaunch::modifybg
}

# ::mollaunch::spinboxdelete
#	Deletes chosen molecule.

proc ::mollaunch::spinboxdelete {} {
	global spinboxlist

	mol delete [$::mollaunch::w.buttons.spin get]
}

# Result Procedures

# ::mollaunch::results
# 	Checks which kind of molecule to add (example, pdb by ID, or 
# 	pdb by name), adds molecule, and runs ::mollaunch::modifymolecule on
# 	molecule.

proc ::mollaunch::results {} {
	global examplemoleculename
	global pdbmoleculeresult
	global additiontype
	global additiontypepdb
	global result
	global w

	if {$additiontype == {pdb}} {
		if {$additiontypepdb == {ID}} {
			if {$::mollaunch::pdbmoleculeid != "ID #"} {
				::mollaunch::getpdb $::mollaunch::pdbmoleculeid
				::mollaunch::pdbinfo [string toupper $::mollaunch::pdbmoleculeid]
				::mollaunch::modifymolecule
			}
		} else {
			if {$::mollaunch::pdbmoleculeresult != ""} {
				::mollaunch::getpdb [string range $::mollaunch::pdbmoleculeresult 0 3]
				::mollaunch::pdbinfo [string range $::mollaunch::pdbmoleculeresult 0 3]
				::mollaunch::modifymolecule
			}
		}
	} else {
		if {$::mollaunch::examplemoleculename != ""} {
			::mollaunch::examplesadd
			set file [open [lindex [glob -directory $::mollaunch::examplemoleculename info.txt] 0] r]
			set ::mollaunch::moleculeinfo [read $file]
			close $file
			$::mollaunch::w.info.frame.info configure -text $::mollaunch::moleculeinfo
		}
	}
}

# ::mollaunch::clipboardcopy
# 	Copy's molecule info to clipboard.

proc ::mollaunch::clipboardcopy {} {
	clipboard clear
	clipboard append $::mollaunch::moleculeinfo
}

# ::mollaunch::pdbinfo
# 	Displays information about molecule when pdb is added.

proc ::mollaunch::pdbinfo {molID} {
	foreach value $::mollaunch::entrieslist {
		if {[string range $value 0 3] == $molID} {
			set valuelist [split $value "\t"]
			set ::mollaunch::moleculeinfo "[lindex $valuelist 0]\t[lindex $valuelist 2]\n[lindex $valuelist 3]\n[lindex $valuelist 5]\n[lindex $valuelist 6] A\t[lindex $valuelist 7]"
			$::mollaunch::w.info.frame.info configure -text $::mollaunch::moleculeinfo
		}
	}
}

# ::mollaunch::examplesadd
# 	Adds commands to VMD based on command.txt to add and modify molecules
# 	in directory.

proc ::mollaunch::examplesadd {} {
	set file [open [lindex [glob -directory $::mollaunch::examplemoleculename command.txt] 0] r]
	set data [read $file]
	close $file
	set datalist [split $data "\n"]
	foreach value $datalist {
		if {[string range $value 0 4] == {MOLNW}} {
			mol new "$::mollaunch::examplemoleculename/[string range $value 6 end]"
		} elseif {[string range $value 0 4] == {MODFY}} {
			::mollaunch::modifymolecule
		}
	}
}

# ::mollaunch::modifymolecule
# 	Modifies recently loaded molecule's color and rendering style in VMD.

proc ::mollaunch::modifymolecule {} {
	global modifydraw
	global modifycolor
	global modifymaterial

	if {$::mollaunch::modifycolor != {default}} {
		mol modcolor 0 top colorid $::mollaunch::modifycolor
	}
	mol modstyle 0 top $::mollaunch::modifydraw
	mol modmaterial 0 top $::mollaunch::modifymaterial
}

## Formatting Procedure

# ::mollaunch::createpdbarr
# 	Creates list from pdb archive file in order to find molecule ID by
# 	molecule or article name.

proc ::mollaunch::createpdbarr {} {
	global pdbarr
	global w
	global pdbarr
	variable file
	variable data

	set file [open "[pwd]/plugins/noarch/tcl/mollaunch1.0/PDB Dictionary/pdbdictionary.tsv" r]
	set data [read $file]
	close $file
	set ::mollaunch::pdbarr [split $data "\n"]
	set file [open "[pwd]/plugins/noarch/tcl/mollaunch1.0/PDB Dictionary/entries.txt"]
	set data [read $file]
	close $file
	set ::mollaunch::entrieslist [split $data "\n"]
}

# mollaunch_tk
# 	Necessary to load mollaunch via VMD startup.

proc mollaunch_tk {} {
	::mollaunch::mollaunch
	return $::mollaunch::w
}