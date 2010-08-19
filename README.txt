This is the sourses for using and testing automated creation of SOPERA documentation.



Requirements:
1. Java 1.6.x.
2. Ant 1.7.x.



Structure of the project:

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
--- README.txt		- this file, short descrition of the project.
|
--- start.bat		- file for classpath settings. You need to run this file first to work without GUI.
|
--- transformate.bat	- file to call main ant script (build.xml).



Installing of DITA-OT (SOPERA version):
1. Checkout project form svn: http://sopera-examples.googlecode.com/svn/dita/sandbox/SopDitaDocumentation.



Upgrade the version of DITA-OT:
1. Unzip folder with DITA-OT to the our project folder.
2. Set DITA-OT version in the build.properties (dita.version variable).




Using of DITA-OT for pdf generation in console:
1. Open file build.properties and change dita.version variable to the correct version value; set source.dir variable to the folder with source dita files; set path to the ditamap file with help of map.file variable.
2. Run start.cmd file to start creation of documents.
3. Open "out/pdf" folder and you can find pdf document there.