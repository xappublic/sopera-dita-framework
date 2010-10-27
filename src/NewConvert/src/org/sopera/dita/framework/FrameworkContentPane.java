package org.sopera.dita.framework;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.TextArea;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;

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
	private JButton deleteMapButton;
	private JButton clearMapsButton;
	// mapButtonsPanel end
	// mapPanel end
	// logPanel begin
	private JPanel logPanel;
	private TextArea logTextArea;
	private JPanel logButtonPanel;
	private JProgressBar logProgressBar;
	private JButton logSaveButton;
	// logPanel end
	// validationLogPanel begin
	private JPanel validationLogPanel;
	private TextArea validationLogTextArea;
	private JPanel validationLogButtonPanel;
	private JProgressBar validationLogProgressBar;
	private JButton validationLogSaveButton;
	// validationLogPanel end
	// shortLogPanel begin
	private JPanel shortLogPanel;
	private TextArea shortLogTextArea;
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
	private JButton validationButton;
	private JButton startButton;
	// buttonPanel end
	// centralPanel end.

	// statusBarPanel begin
	private JPanel statusBarPanel;
	private JLabel statusBarLabel;

	// statusBarPanel end.

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

		deleteMapButton = new JButton("Delete ditamap");
		deleteMapButton.setBorder(componentBorder);
		deleteMapButton.setMinimumSize(new Dimension(100, 26));
		deleteMapButton.setPreferredSize(new Dimension(100, 26));
		deleteMapButton.setMaximumSize(new Dimension(100, 26));

		clearMapsButton = new JButton("Clear all maps");
		clearMapsButton.setBorder(componentBorder);
		clearMapsButton.setMinimumSize(new Dimension(100, 26));
		clearMapsButton.setPreferredSize(new Dimension(100, 26));
		clearMapsButton.setMaximumSize(new Dimension(100, 26));

		mapButtonsPanel.add(addMapButton);
		mapButtonsPanel.add(deleteMapButton);
		mapButtonsPanel.add(clearMapsButton);

		mapPanel.add(mapScrollPane);
		mapPanel.add(mapButtonsPanel);

		logPanel = new JPanel();

		logTextArea = new TextArea();
		logTextArea.setMinimumSize(new Dimension(590, 380));
		logTextArea.setPreferredSize(new Dimension(590, 380));
		logTextArea.setMaximumSize(new Dimension(590, 380));

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

		logSaveButton = new JButton("Save");

		logButtonPanel.add(logProgressBar);
		logButtonPanel.add(logSaveButton);

		logPanel.add(logTextArea);
		logPanel.add(logButtonPanel);

		validationLogPanel = new JPanel();

		validationLogTextArea = new TextArea();
		validationLogTextArea.setMinimumSize(new Dimension(590, 380));
		validationLogTextArea.setPreferredSize(new Dimension(590, 380));
		validationLogTextArea.setMaximumSize(new Dimension(590, 380));

		validationLogButtonPanel = new JPanel();
		validationLogButtonPanel.setBorder(componentBorder);
		validationLogButtonPanel.setMinimumSize(new Dimension(590, 40));
		validationLogButtonPanel.setPreferredSize(new Dimension(590, 40));
		validationLogButtonPanel.setMaximumSize(new Dimension(590, 40));

		validationLogProgressBar = new JProgressBar();
		validationLogProgressBar.setBorder(componentBorder);
		validationLogProgressBar.setMinimumSize(new Dimension(500, 25));
		validationLogProgressBar.setPreferredSize(new Dimension(500, 25));
		validationLogProgressBar.setMaximumSize(new Dimension(500, 25));

		validationLogSaveButton = new JButton("Save");

		validationLogButtonPanel.add(validationLogProgressBar);
		validationLogButtonPanel.add(validationLogSaveButton);

		validationLogPanel.add(validationLogTextArea);
		validationLogPanel.add(validationLogButtonPanel);

		shortLogPanel = new JPanel();

		shortLogTextArea = new TextArea();
		shortLogTextArea.setMinimumSize(new Dimension(590, 380));
		shortLogTextArea.setPreferredSize(new Dimension(590, 380));
		shortLogTextArea.setMaximumSize(new Dimension(590, 380));

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

		shortLogSaveButton = new JButton("Save");

		shortLogButtonPanel.add(shortLogProgressBar);
		shortLogButtonPanel.add(shortLogSaveButton);

		shortLogPanel.add(shortLogTextArea);
		shortLogPanel.add(shortLogButtonPanel);

		infoTabs.addTab("Maps", null, mapPanel, "List of ditamaps");
		infoTabs.addTab("Log", null, logPanel,
				"Information about transformation process");
		infoTabs.addTab("Validation", null, validationLogPanel,
				"Information about validation process");
		infoTabs.addTab("Short log", null, shortLogPanel,
				"Log with main information about convertation process");
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

		htmlCheckBox = new JCheckBox("Create HTML");

		eclipseHelpCheckBox = new JCheckBox("Create EclipseHelp");

		documentTypesPanel.add(pdfCheckBox);
		documentTypesPanel.add(htmlCheckBox);
		documentTypesPanel.add(eclipseHelpCheckBox);

		processButtonsPanel = new JPanel();
		processButtonsPanel.setLayout(new FlowLayout());
		processButtonsPanel.setBorder(componentBorder);
		processButtonsPanel.setMinimumSize(new Dimension(188, 42));
		processButtonsPanel.setPreferredSize(new Dimension(188, 42));
		processButtonsPanel.setMaximumSize(new Dimension(188, 42));

		validationButton = new JButton("Validate");

		startButton = new JButton("Start");

		processButtonsPanel.add(validationButton);
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
	}

	@Override
	public void mouseClicked(MouseEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void mouseEntered(MouseEvent e) {
		// TODO
	}

	@Override
	public void mouseExited(MouseEvent e) {
		statusBarLabel.setText("\u00A9 SOPERA GmbH, 2010");
	}

	@Override
	public void mousePressed(MouseEvent e) {
		// TODO Auto-generated method stub
	}

	@Override
	public void mouseReleased(MouseEvent e) {
		// TODO Auto-generated method stub
	}

	@Override
	public void run() {
		// TODO Auto-generated method stub
	}

	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
	}
}
