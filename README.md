<h1>MolLaunch ReadMe</h1>


<h2>About MolLaunch</h2>
MolLaunch is a plugin for VMD (Visual Molecular Dynamics, http://www.ks.uiuc.edu/Research/vmd/), a molecular
visualization program for displaying, animating, and analyzing large biomolecular systems using 3-D graphics
and built-in scripting. MolLaunch simplifies VMD's GUI and text line as an extension to VMD, and allows for the
manipulation of molecule representation, addition of molecules from an existing list of molecules in MolLaunch's directories
or from the Protein Data Bank (http://www.rcsb.org/pdb/home/home.do), which is the single worldwide repository of information about
the 3D structures of large biological molecules, including proteins and nucleic acids. MolLaunch is available on all systems that
support VMD.


<h2>Download Instructions</h2>
The VMD extension MolLaunch can be downloaded here by either using the git command in the command line:

`git clone http://github.com/brit228/MolLaunch`

Or by using the download zip feature in GitHub and unzipping in your preferred place.


<h2>Installation Instructions</h2>
After downloading MolLaunch, please follow the following instructions to install MolLaunch into VMD:

1. Find the directory for VMD and go to it in either the command line or a file manager program.
2. Replace the existing `vmd.rc` file in the VMD directory with the `vmd.rc` file from the MolLaunch GitHub.
An alternative to this is to add the line `vmd_install_extension mollaunch mollaunch_tk "MolLaunch"` to the
end of the file on its own line.
3. Open the following path: `/plugins/noarch/tcl/` and drag and drop or move the mollaunch1.0 directory from the GitHub directory
into the `/plugins/noarch/tcl/` directory.

Installation of MolLaunch is now complete!

<h2>Using MolLaunch</h2>
MolLaunch can be opened by now going into VMD and either typing into the console `mollaunch`, or by using the Extensions dropdown
in the VMD Main Window and selecting MolLaunch.

Examples of different molecules can be found in the top left of the MolLaunch window, and can be loaded into VMD by first selecting the
category of molecule, then selecting the molecule itself, selecting "Add Molecule from Examples" from the right side of the window and
clicking "ADD".

Molecules can also be imported from the Protein Data Bank, by typing in the PDB ID in the Molecule ID box, selecting "Add by
Molecule ID", selecting "Add Molecule from PDB", and clicking "ADD". Molecules can also be searched through the Protein Data Bank
by typing in a search term in the "Search by name" box, selecting the desired description of the molecule, selecting "Add by Molecule
Name", selecting "Add Molecule from PDB", and clicking "ADD".

When clicking "ADD", the molecule will appear in VMD using the representation options selected in the top right side of the screen.
These can be changed by clicking on them, with the changeable options being the "Drawing Method", "Color", and "Material". The 
"Background" will change each time a new background is selected.

The molecules imported to VMD can also be modified or deleted from MolLaunch. To modify a molecule select the representation options 
wanted in the top right of the screen, select the molecule number from the right side of the screen next to "Modify" and "Delete", and 
click "Modify". The molecule number is the "ID" shown for the molecule in the VMD Main Window. To delete a molecule, select the molecule
number and click "Delete".

Info about Protein Data Bank molecules will appear in the bottom right side of the screen. This information can be copied to the
clipboard to be pasted anywhere by pressing the "Copy to Clipboard" button.
