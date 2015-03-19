This readme files describes the folders in this framework and contains instructions on  using it.



### Requirements: ###
1. Java 1.6.x.
2. Ant 1.7.x.



### Structure of the project: ###
```
SopDitaDocumentation	- main project folder.
|
--- DITA-OT1.5.1 	- folder with DITA-OT.
|
--- in		 	- folder with source dita files, images and ditamap.
|
--- lib			- folder with libs for java GUI application.
|
--- out		 	- folder with ready documentation.
|
--- temp	 	- temporary folder.
|
--- build.properties	- file with main project properties.
|
--- build.xml		- main ant script, which starts transformation process.
|
--- Convert.jar		- GUI application.
|
--- forjavaapp.bat	- batch file for java application.
|
--- forjavaapp.sh	- file for java application.
|
--- README.txt		- this file, short description of the project.
|
--- start.bat		- file for classpath settings. You need to run this file first to work without GUI.
|
--- transformate.bat	- file to call main ant script (build.xml).
```



---


### Installing of DITA-OT (SOPERA version): ###
Checkout project from svn: <a href='http://sopera-examples.googlecode.com/svn/dita/sandbox/SopDitaDocumentation'>SopDitaDocumentation</a>.



Upgrade the version of DITA-OT if you have an older version present:
1. Unzip folder with DITA-OT to a project project folder.
2. Set DITA-OT version in the build.properties (dita.version variable).


### Using DITA-OT to generate PDF output using the GUI: ###
<ol>
<blockquote><li> Start <tt>convert.jar</tt>. </li>
<li>Click "Add ditamap file" and browse to your ditamap file.</li>
<li> Click "Start process".</li>
<li> When the generation process is completed you should see a "Build Successful" message.</li>
<li> Go to the "out/pdf" folder and locate your PDF file.</li>
</ol></blockquote>

### Alternatively, you can also do the following: ###
<ol>
<blockquote><li>Open the file build.properties and change the dita.version variable to the correct version value.</li>
<li>Set the source.dir variable to the folder with source dita files. </li>
<li>Set the path to the ditamap file with help of map.file variable.</li>
<li>Run forjavaapp.bat file to start the PDF generation process.</li>
<li>Go to the "out/pdf" folder and locate your PDF file.</li>
</ol>