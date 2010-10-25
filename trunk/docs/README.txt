This readme files describes the folders in this framework and contains instructions on  using it.



Requirements:
1. Java 1.6.x.
2. Ant 1.7.x.

Structure of the project:

SopDitaDocumentation	- main project folder.
|
--- DITA-OT1.5.1 		- folder with DITA-OT.
|
--- in		 			- folder with source dita files, images and ditamap.
|
--- lib					- folder with libs for java GUI application.
|
--- out		 			- folder with ready documentation.
|
--- temp	 			- temporary folder.
|
--- build.properties	- file with main project properties.
|
--- build.xml			- main ant script, which starts transformation process.
|
--- Convert.jar			- GUI application.
|
--- forjavaapp.bat		- batch file for java application.
|
--- forjavaapp.sh		- file for java application.
|
--- README.txt			- this file, short description of the project.



Installing of DITA-OT (SOPERA version):
1. Checkout project form svn: http://sopera-examples.googlecode.com/svn/dita/sandbox/SopDitaDocumentation.



Upgrade the version of DITA-OT if you have an older version present:
1. Unzip folder with DITA-OT to a project project folder.
2. Set DITA-OT version in the build.properties (dita.version variable).




Generate PDF output using the GUI:
1. Start convert.jar
2. In the new window that appears, click "Add ditamap file" and browse to your ditamap file.
3. Click "Start process".
4. If your files are valid and the process successful, you should see a "Build Successful" message when the generation process is completed.
5. Go to the "out/ditamapFilename/pdf" folder and locate your PDF file.

Alternatively, you can also do the following:
1. Open the file build.properties and change the dita.version variable to the correct version value; 
2. Set the source.dir variable to the folder with source dita files; 
3. Set the path to the ditamap file with help of map.file variable.
2. Run forjavaapp.bat file to start the PDF generation process.
3. Go to the "out/ditamapFilename/pdf" folder and locate your PDF file.

Known issues
1. If "ant not found" message is shown, you have to run forjavaapp.bat and convert.jar from project folder.
2. Doctype must be written in one line.