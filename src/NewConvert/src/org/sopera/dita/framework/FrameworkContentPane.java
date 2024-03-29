package org.sopera.dita.framework;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;

import javax.swing.*;
import javax.swing.border.Border;

public class FrameworkContentPane extends JPanel implements ActionListener,
		MouseListener, Runnable {

	private static final long serialVersionUID = 4883379598706809735L;

	private Border componentBorder = BorderFactory.createLineBorder(new Color(
			132, 184, 24), 1);

	// projectNamePanel begin
	private JPanel projectNamePanel;
	private JLabel projectNameLabel;
	// projectNamePanel end.
	
	// centralPanel begin
	private JPanel centralPanel;
	// infoPanel begin
	private JPanel infoPanel;
	private JTabbedPane infoTabs;
	// mapPanel begin
	private JPanel mapPanel;
	private JScrollPane mapScrollPane;
	private JList mapList;
	// mapButtonsPanel begin
	private JPanel mapButtonsPanel;
	private JButton addMapButton;
	private JButton findMapButton;
	private JButton deleteMapButton;
	private JButton clearMapsButton;
	// mapButtonsPanel end
	// mapPanel end
	// logPanel begin
	private JPanel logPanel;
	private JScrollPane logScrollPane;
	private JTextArea logTextArea;
	private JPanel logButtonPanel;
	private JProgressBar logProgressBar;
	private JButton logSaveButton;
	// logPanel end
	// updateSourceLogPanel begin
	private JPanel updateSourceLogPanel;
	private JScrollPane updateSourceLogScrollPane;
	private static JTextArea updateSourceLogTextArea;
	private JPanel updateSourceLogButtonPanel;
	private JProgressBar updateSourceLogProgressBar;
	private JButton updateSourceLogSaveButton;
	// updateSourceLogPanel end
	// shortLogPanel begin
	private JPanel shortLogPanel;
	private JScrollPane shortLogScrollPane;
	private JTextArea shortLogTextArea;
	private JPanel shortLogButtonPanel;
	private JProgressBar shortLogProgressBar;
	private JButton shortLogSaveButton;
	// shortLogPanel end
	// infoPanel end
	// buttonPanel begin
	private JPanel buttonPanel;
	private JPanel documentTypesPanel;
	private JCheckBox pdfCheckBox;
	private JCheckBox htmlCheckBox;
	private JCheckBox eclipseHelpCheckBox;
	private JPanel processButtonsPanel;
	private JButton startButton;
	// buttonPanel end
	// centralPanel end.

	// statusBarPanel begin
	private JPanel statusBarPanel;
	private JLabel statusBarLabel;
	// statusBarPanel end.

	String cmdFile = "";
	
	String outFolder = "in\\";

	class DitaFileFilter extends javax.swing.filechooser.FileFilter {
		private final String[] okFileExtensions;
		private final String description;

		public DitaFileFilter(String ext, String descr) {
			okFileExtensions = new String[] { ext };
			description = descr;
		}

		public DitaFileFilter(String[] ext, String descr) {
			okFileExtensions = ext;
			description = descr;
		}

		public boolean accept(File file) {
			if (file.isDirectory())
				return true;
			for (String extension : okFileExtensions)
				if (file.getName().toLowerCase().endsWith(extension))
					return true;
			return false;
		}

		@Override
		public String getDescription() {
			return description;
		}
	}

	public FrameworkContentPane() {
		
		setBorder(componentBorder);
		setOpaque(true);
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));

		projectNamePanel = new JPanel();
		projectNamePanel.setBorder(componentBorder);
		projectNamePanel.setMinimumSize(new Dimension(800, 80));
		projectNamePanel.setMaximumSize(new Dimension(800, 80));
		projectNamePanel.setPreferredSize(new Dimension(800, 80));
		projectNamePanel.setLayout(new BoxLayout(projectNamePanel,
				BoxLayout.X_AXIS));
		projectNamePanel.setBackground(new Color(255, 255, 255));

		Icon soperaLogo = new ImageIcon("resources/sopera.png");
		projectNameLabel = new JLabel(
				"<html><font size='20' color='#84b818'>&nbsp;&nbsp;&nbsp;SOPERA DITA Framework",
				soperaLogo, SwingConstants.LEFT);
		projectNameLabel.setToolTipText("SOPERA DITA Framework");

		projectNamePanel.add(projectNameLabel);

		centralPanel = new JPanel();
		centralPanel.setBorder(componentBorder);
		centralPanel.setLayout(new BoxLayout(centralPanel, BoxLayout.X_AXIS));
		centralPanel.setMinimumSize(new Dimension(800, 466));
		centralPanel.setPreferredSize(new Dimension(800, 466));
		centralPanel.setMaximumSize(new Dimension(800, 466));

		infoPanel = new JPanel();
		infoPanel.setBorder(componentBorder);
		infoPanel.setMinimumSize(new Dimension(600, 466));
		infoPanel.setPreferredSize(new Dimension(600, 466));
		infoPanel.setMaximumSize(new Dimension(600, 466));

		infoTabs = new JTabbedPane();
		infoTabs.setMinimumSize(new Dimension(598, 458));
		infoTabs.setPreferredSize(new Dimension(598, 458));
		infoTabs.setMaximumSize(new Dimension(598, 458));

		mapPanel = new JPanel();
		mapPanel.setLayout(new BoxLayout(mapPanel, BoxLayout.Y_AXIS));

		DefaultListModel lm = new DefaultListModel();
		mapList = new JList(lm);
		mapList.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		mapList.setToolTipText("List of ditamaps");

		mapScrollPane = new JScrollPane(mapList);

		mapButtonsPanel = new JPanel();
		mapButtonsPanel.setBorder(componentBorder);
		mapButtonsPanel.setMinimumSize(new Dimension(592, 40));
		mapButtonsPanel.setPreferredSize(new Dimension(592, 40));
		mapButtonsPanel.setMaximumSize(new Dimension(592, 40));

		addMapButton = new JButton("Add ditamap");
		addMapButton.setBorder(componentBorder);
		addMapButton.setMinimumSize(new Dimension(100, 26));
		addMapButton.setPreferredSize(new Dimension(100, 26));
		addMapButton.setMaximumSize(new Dimension(100, 26));
		addMapButton.addActionListener(this);
		
		findMapButton = new JButton("Find ditamaps");
		findMapButton.setBorder(componentBorder);
		findMapButton.setMinimumSize(new Dimension(100, 26));
		findMapButton.setPreferredSize(new Dimension(100, 26));
		findMapButton.setMaximumSize(new Dimension(100, 26));
		findMapButton.addActionListener(this);

		deleteMapButton = new JButton("Delete ditamap");
		deleteMapButton.setBorder(componentBorder);
		deleteMapButton.setMinimumSize(new Dimension(100, 26));
		deleteMapButton.setPreferredSize(new Dimension(100, 26));
		deleteMapButton.setMaximumSize(new Dimension(100, 26));
		deleteMapButton.addActionListener(this);

		clearMapsButton = new JButton("Clear all maps");
		clearMapsButton.setBorder(componentBorder);
		clearMapsButton.setMinimumSize(new Dimension(100, 26));
		clearMapsButton.setPreferredSize(new Dimension(100, 26));
		clearMapsButton.setMaximumSize(new Dimension(100, 26));
		clearMapsButton.addActionListener(this);

		mapButtonsPanel.add(addMapButton);
		mapButtonsPanel.add(findMapButton);
		mapButtonsPanel.add(deleteMapButton);
		mapButtonsPanel.add(clearMapsButton);

		mapPanel.add(mapScrollPane);
		mapPanel.add(mapButtonsPanel);

		logPanel = new JPanel();
		
		logTextArea = new JTextArea();
		logTextArea.setLineWrap(true);
		logTextArea.setWrapStyleWord(true);
		logTextArea.setEditable(false);

		logScrollPane = new JScrollPane(logTextArea);
		logScrollPane.setMinimumSize(new Dimension(590, 380));
		logScrollPane.setPreferredSize(new Dimension(590, 380));
		logScrollPane.setMaximumSize(new Dimension(590, 380));
		
		logButtonPanel = new JPanel();
		logButtonPanel.setBorder(componentBorder);
		logButtonPanel.setMinimumSize(new Dimension(590, 40));
		logButtonPanel.setPreferredSize(new Dimension(590, 40));
		logButtonPanel.setMaximumSize(new Dimension(590, 40));

		logProgressBar = new JProgressBar();
		logProgressBar.setBorder(componentBorder);
		logProgressBar.setMinimumSize(new Dimension(500, 25));
		logProgressBar.setPreferredSize(new Dimension(500, 25));
		logProgressBar.setMaximumSize(new Dimension(500, 25));
		logProgressBar.setStringPainted(true);
		logProgressBar.setMaximum(100);
		logProgressBar.setValue(0);
				
		logSaveButton = new JButton("Save");
		logSaveButton.addActionListener(this);

		logButtonPanel.add(logProgressBar);
		logButtonPanel.add(logSaveButton);

		logPanel.add(logScrollPane);
		logPanel.add(logButtonPanel);

		updateSourceLogPanel = new JPanel();

		updateSourceLogTextArea = new JTextArea();
		updateSourceLogTextArea.setLineWrap(true);
		updateSourceLogTextArea.setWrapStyleWord(true);
		updateSourceLogTextArea.setEditable(false);
		
		updateSourceLogScrollPane = new JScrollPane(updateSourceLogTextArea);
		updateSourceLogScrollPane.setMinimumSize(new Dimension(590, 380));
		updateSourceLogScrollPane.setPreferredSize(new Dimension(590, 380));
		updateSourceLogScrollPane.setMaximumSize(new Dimension(590, 380));

		updateSourceLogButtonPanel = new JPanel();
		updateSourceLogButtonPanel.setBorder(componentBorder);
		updateSourceLogButtonPanel.setMinimumSize(new Dimension(590, 40));
		updateSourceLogButtonPanel.setPreferredSize(new Dimension(590, 40));
		updateSourceLogButtonPanel.setMaximumSize(new Dimension(590, 40));

		updateSourceLogProgressBar = new JProgressBar();
		updateSourceLogProgressBar.setBorder(componentBorder);
		updateSourceLogProgressBar.setMinimumSize(new Dimension(400, 25));
		updateSourceLogProgressBar.setPreferredSize(new Dimension(400, 25));
		updateSourceLogProgressBar.setMaximumSize(new Dimension(400, 25));
		updateSourceLogProgressBar.setStringPainted(true);

		updateSourceLogSaveButton = new JButton("Start conversion");
		updateSourceLogSaveButton.addActionListener(this);
		
		updateSourceLogButtonPanel.add(updateSourceLogProgressBar);
		updateSourceLogButtonPanel.add(updateSourceLogSaveButton);

		updateSourceLogPanel.add(updateSourceLogScrollPane);
		updateSourceLogPanel.add(updateSourceLogButtonPanel);

		shortLogPanel = new JPanel();

		shortLogTextArea = new JTextArea();
		shortLogTextArea.setLineWrap(true);
		shortLogTextArea.setWrapStyleWord(true);
		shortLogTextArea.setEditable(false);
		
		shortLogScrollPane = new JScrollPane(shortLogTextArea);
		shortLogScrollPane.setMinimumSize(new Dimension(590, 380));
		shortLogScrollPane.setPreferredSize(new Dimension(590, 380));
		shortLogScrollPane.setMaximumSize(new Dimension(590, 380));
		
		shortLogButtonPanel = new JPanel();
		shortLogButtonPanel.setBorder(componentBorder);
		shortLogButtonPanel.setMinimumSize(new Dimension(590, 40));
		shortLogButtonPanel.setPreferredSize(new Dimension(590, 40));
		shortLogButtonPanel.setMaximumSize(new Dimension(590, 40));

		shortLogProgressBar = new JProgressBar();
		shortLogProgressBar.setBorder(componentBorder);
		shortLogProgressBar.setMinimumSize(new Dimension(500, 25));
		shortLogProgressBar.setPreferredSize(new Dimension(500, 25));
		shortLogProgressBar.setMaximumSize(new Dimension(500, 25));
		shortLogProgressBar.setStringPainted(true);
		
		shortLogSaveButton = new JButton("Save");
		shortLogSaveButton.addActionListener(this);

		shortLogButtonPanel.add(shortLogProgressBar);
		shortLogButtonPanel.add(shortLogSaveButton);

		shortLogPanel.add(shortLogScrollPane);
		shortLogPanel.add(shortLogButtonPanel);

		infoTabs.addTab("Maps", null, mapPanel, "List of ditamaps");
		infoTabs.addTab("Log", null, logPanel,
				"Information about transformation process");
		infoTabs.addTab("Short log", null, shortLogPanel,
		"Log with main information about convertation process");
		infoTabs.addTab("Update source", null, updateSourceLogPanel,
		"Update old dita sources (DITA 132) to DITA 1.5.1");
		for (int i = 0; i < 4; i++) {
			infoTabs.setForegroundAt(i, new Color(132, 184, 24));
			infoTabs.setBackgroundAt(i, new Color(255, 255, 255));
		}

		infoPanel.add(infoTabs);

		buttonPanel = new JPanel();
		buttonPanel.setBorder(componentBorder);
		SpringLayout layout = new SpringLayout();
		buttonPanel.setLayout(layout);
		buttonPanel.setMinimumSize(new Dimension(190, 464));
		buttonPanel.setPreferredSize(new Dimension(190, 464));
		buttonPanel.setMaximumSize(new Dimension(190, 464));

		documentTypesPanel = new JPanel();
		documentTypesPanel.setLayout(new BoxLayout(documentTypesPanel,
				BoxLayout.Y_AXIS));
		documentTypesPanel.setBorder(componentBorder);
		documentTypesPanel.setMinimumSize(new Dimension(188, 420));
		documentTypesPanel.setPreferredSize(new Dimension(188, 420));
		documentTypesPanel.setMaximumSize(new Dimension(188, 420));
		
		pdfCheckBox = new JCheckBox("Create PDF");
		pdfCheckBox.setSelected(true);

		htmlCheckBox = new JCheckBox("Create HTML");
		htmlCheckBox.setSelected(true);

		eclipseHelpCheckBox = new JCheckBox("Create EclipseHelp");
		eclipseHelpCheckBox.setSelected(true);


		documentTypesPanel.add(pdfCheckBox);
		documentTypesPanel.add(htmlCheckBox);
		documentTypesPanel.add(eclipseHelpCheckBox);

		processButtonsPanel = new JPanel();
		processButtonsPanel.setLayout(new FlowLayout());
		processButtonsPanel.setBorder(componentBorder);
		processButtonsPanel.setMinimumSize(new Dimension(188, 42));
		processButtonsPanel.setPreferredSize(new Dimension(188, 42));
		processButtonsPanel.setMaximumSize(new Dimension(188, 42));
		
		startButton = new JButton("Start");
		startButton.addActionListener(this);

		processButtonsPanel.add(startButton);

		layout.putConstraint(SpringLayout.WEST, documentTypesPanel, 0,
				SpringLayout.WEST, buttonPanel);
		layout.putConstraint(SpringLayout.WEST, processButtonsPanel, 0,
				SpringLayout.WEST, buttonPanel);
		layout.putConstraint(SpringLayout.SOUTH, processButtonsPanel, 0,
				SpringLayout.SOUTH, buttonPanel);
		buttonPanel.add(documentTypesPanel);
		buttonPanel.add(processButtonsPanel);

		centralPanel.add(infoPanel);
		centralPanel.add(buttonPanel);

		statusBarPanel = new JPanel();
		statusBarPanel.setBorder(componentBorder);
		statusBarPanel.setToolTipText("Status bar");
		statusBarPanel.setMinimumSize(new Dimension(800, 20));
		statusBarPanel.setMaximumSize(new Dimension(800, 20));
		statusBarPanel.setPreferredSize(new Dimension(800, 20));
		statusBarPanel
				.setLayout(new BoxLayout(statusBarPanel, BoxLayout.X_AXIS));

		statusBarLabel = new JLabel("\u00A9 Sopera GmbH, 2010");

		statusBarPanel.add(statusBarLabel);

		add(projectNamePanel);
		add(centralPanel);
		add(statusBarPanel);

		if (System.getProperties().getProperty("os.name").indexOf("indows") > 0) {
			System.out.println(System.getProperties().getProperty("os.name"));
			cmdFile = "forjavaapp.bat";
		} else {
			cmdFile = "sh forjavaapp.sh";
		}
	}

	public void mouseClicked(MouseEvent e) {

	}

	public void mouseEntered(MouseEvent e) {

	}

	public void mouseExited(MouseEvent e) {
		statusBarLabel.setText("\u00A9 SOPERA GmbH, 2010");
	}

	public void mousePressed(MouseEvent e) {

	}

	public void mouseReleased(MouseEvent e) {
	
	}

	public void run() {
		startButton.setEnabled(false);
		pdfCheckBox.setEnabled(false);
		htmlCheckBox.setEnabled(false);
		eclipseHelpCheckBox.setEnabled(false);
		addMapButton.setEnabled(false);
		findMapButton.setEnabled(false);
		deleteMapButton.setEnabled(false);
		clearMapsButton.setEnabled(false);
		
		logTextArea.setText("");
		shortLogTextArea.setText("");
		infoTabs.getModel().setSelectedIndex(2);		
		DefaultListModel dlm = (DefaultListModel) mapList.getModel();
		logProgressBar.setMaximum(100 * dlm.getSize());
		shortLogProgressBar.setMaximum(100 * dlm.getSize());
		for (int i = 0; i < dlm.getSize(); i++) {
			String cmd = cmdFile;
			Process proc = null;
			cmd += " " + String.valueOf(dlm.getElementAt(i)) + " ";
			if ((pdfCheckBox.isSelected() == true) && (htmlCheckBox.isSelected() == false) && (eclipseHelpCheckBox.isSelected() == false)) cmd += "1";
			if ((pdfCheckBox.isSelected() == false) && (htmlCheckBox.isSelected() == true) && (eclipseHelpCheckBox.isSelected() == false)) cmd += "2";
			if ((pdfCheckBox.isSelected() == false) && (htmlCheckBox.isSelected() == false) && (eclipseHelpCheckBox.isSelected() == true)) cmd += "3";
			if ((pdfCheckBox.isSelected() == true) && (htmlCheckBox.isSelected() == true) && (eclipseHelpCheckBox.isSelected() == false)) cmd += "4";
			if ((pdfCheckBox.isSelected() == false) && (htmlCheckBox.isSelected() == true) && (eclipseHelpCheckBox.isSelected() == true)) cmd += "5";
			if ((pdfCheckBox.isSelected() == true) && (htmlCheckBox.isSelected() == false) && (eclipseHelpCheckBox.isSelected() == true)) cmd += "6";
			if ((pdfCheckBox.isSelected() == true) && (htmlCheckBox.isSelected() == true) && (eclipseHelpCheckBox.isSelected() == true)) cmd += "7";
			if ((pdfCheckBox.isSelected() == false) && (htmlCheckBox.isSelected() == false) && (eclipseHelpCheckBox.isSelected() == false)) return;
			System.out.println("cmd command = \"" + cmd + "\"");
			try {
				proc = Runtime.getRuntime().exec(cmd, null, new File("."));
			} catch (IOException e) {
				System.out.println("File \"forjavaapp\" not found");
				return;
			}

			InputStreamDataListener isdl = new InputStreamDataListener(proc,
					logTextArea, logProgressBar, i, shortLogTextArea, shortLogProgressBar, mapList.getModel().getSize());
			Thread isdlThread = new Thread(isdl);
			try {
				isdlThread.start();
			} catch (Exception e) {
				System.err.println("Cant start thread");
			}
			InputStreamErrorListener isel = new InputStreamErrorListener(proc,
					logTextArea, shortLogTextArea, isdlThread);
			new Thread(isel).start();
			try {
				proc.waitFor();
			} catch (InterruptedException e) {
			}
		}
		startButton.setEnabled(true);
		pdfCheckBox.setEnabled(true);
		htmlCheckBox.setEnabled(true);
		eclipseHelpCheckBox.setEnabled(true);
		addMapButton.setEnabled(true);
		findMapButton.setEnabled(true);
		deleteMapButton.setEnabled(true);
		clearMapsButton.setEnabled(true);
	}

	public void actionPerformed(ActionEvent arg0) {
		
		if (arg0.getSource().equals(updateSourceLogSaveButton)) {
			JFileChooser chooser = new JFileChooser();
			chooser.setCurrentDirectory(new File("."));
			chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
			chooser.setMultiSelectionEnabled(true);
			chooser.setFileFilter(new DitaFileFilter("ditamap", "Folder with old sources"));
			int returnVal = chooser.showOpenDialog(this);
			if (returnVal == JFileChooser.APPROVE_OPTION) {
				UpdateSourceThrd us = new UpdateSourceThrd(updateSourceLogTextArea, chooser);
				new Thread(us).start();
			}
		}
		if (arg0.getSource().equals(addMapButton)) {
			JFileChooser chooser = new JFileChooser();
			chooser.setCurrentDirectory(new File("."));
			chooser.setMultiSelectionEnabled(true);
			chooser.setApproveButtonText("Add");
			chooser.setFileFilter(new DitaFileFilter("ditamap", "DITA Map file"));
			int returnVal = chooser.showOpenDialog(this);
			if (returnVal == JFileChooser.APPROVE_OPTION) {
				DefaultListModel dlm = (DefaultListModel) mapList.getModel();
				for (int i = 0; i < chooser.getSelectedFiles().length; i++) {
					// Start transformation for each ditamap file
					dlm.addElement(chooser.getSelectedFiles()[i].getAbsolutePath());	
				}				
			}
		}
		if (arg0.getSource().equals(deleteMapButton)) {
			if (mapList.getSelectedIndex() != -1) {
				DefaultListModel dlm = (DefaultListModel) mapList.getModel();
				dlm.remove(mapList.getSelectedIndex());
			}
		}
		if (arg0.getSource().equals(clearMapsButton)) {
			DefaultListModel dlm = (DefaultListModel) mapList.getModel();
			dlm.clear();
		}
		if (arg0.getSource().equals(startButton)) {
			try {
				new Thread(this).start();
			} catch (Exception e) {
			}			
		}
		if (arg0.getSource().equals(logSaveButton)) {
			JFileChooser chooser = new JFileChooser();
			chooser.setCurrentDirectory(new File("."));
			chooser.setApproveButtonText("Save");
			chooser.setFileFilter(new DitaFileFilter("txt", "Text file"));
			int returnVal = chooser.showOpenDialog(this);
			if (returnVal == JFileChooser.APPROVE_OPTION) {
				if (chooser.getSelectedFile().getAbsolutePath().toLowerCase()
						.endsWith(".txt")) {
					SaveFileAsString(chooser.getSelectedFile()
							.getAbsolutePath(), "UTF8", logTextArea.getText());
				} else {
					SaveFileAsString(chooser.getSelectedFile()
							.getAbsolutePath() + ".txt", "UTF8",
							logTextArea.getText());
				}
			}
		}
		if (arg0.getSource().equals(shortLogSaveButton)) {
			JFileChooser chooser = new JFileChooser();
			chooser.setCurrentDirectory(new File("."));
			chooser.setApproveButtonText("Save");
			chooser.setFileFilter(new DitaFileFilter("txt", "Text file"));
			int returnVal = chooser.showOpenDialog(this);
			if (returnVal == JFileChooser.APPROVE_OPTION) {
				if (chooser.getSelectedFile().getAbsolutePath().toLowerCase()
						.endsWith(".txt")) {
					SaveFileAsString(chooser.getSelectedFile()
							.getAbsolutePath(), "UTF8", shortLogTextArea.getText());
				} else {
					SaveFileAsString(chooser.getSelectedFile()
							.getAbsolutePath() + ".txt", "UTF8",
							shortLogTextArea.getText());
				}
			}
		}
		if (arg0.getSource().equals(findMapButton)) {
			try {
				FindDitaMaps(new File(outFolder));
			}
			catch (Exception e) {
				System.out.println("Not found 'in' directory with .ditamap files");
			}
		}
		// XXX
	}

	private void FindDitaMaps(File files) {
		File[] fList;
		fList = files.listFiles();
		for(int i = 0; i < fList.length; i++)           
		{
			if(fList[i].isFile()) {
		    	 DefaultListModel dlm = (DefaultListModel) mapList.getModel();
				 if(fList[i].getAbsolutePath().endsWith(".ditamap")) dlm.addElement(fList[i].getAbsolutePath());		    	 
		    }
			else {
				FindDitaMaps(fList[i]);
			}
		}
	}
	
	private void SaveFileAsString(String file, String encoding, String string) {
		OutputStream outputStream = null;
		try {
			outputStream = new FileOutputStream(file);
			Writer writer = new OutputStreamWriter(outputStream, encoding);
			writer.write(string);
			writer.close();
		} catch (Exception ex) {
		} finally {
			if (outputStream != null)
				try {
					outputStream.close();
				} catch (IOException ex) {
				}
		}
	}
}
