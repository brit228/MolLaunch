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
in the VMD Main Window.
