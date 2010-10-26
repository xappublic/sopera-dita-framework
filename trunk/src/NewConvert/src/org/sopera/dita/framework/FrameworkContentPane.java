package org.sopera.dita.framework;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;

import javax.swing.*;
import javax.swing.border.Border;

public class FrameworkContentPane extends JPanel implements MouseListener {

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
	private JPanel logPanel;
	private JPanel validationLogPanel;
	private JPanel shortLogPanel;
	// infoPanel end
	// buttonPanel begin
	private JPanel buttonPanel;
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

		Icon soperaLogo = new ImageIcon("resources/sopera.png");
		projectNameLabel = new JLabel(
				"<html><font size='20' color='#84b818'>SOPERA DITA Framework",
				soperaLogo, SwingConstants.LEFT);
		projectNameLabel.setToolTipText("SOPERA DITA Framework");
		projectNameLabel.addMouseListener(this);

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
		mapPanel.addMouseListener(this);
		mapPanel.setLayout(new BoxLayout(mapPanel, BoxLayout.Y_AXIS));

		mapScrollPane = new JScrollPane();

		ListModel lm = new DefaultListModel();
		mapList = new JList(lm);
		mapList.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		mapList.setToolTipText("List of ditamaps");
		mapList.addMouseListener(this);

		mapScrollPane.add(mapList);

		mapButtonsPanel = new JPanel();
		mapButtonsPanel.setBorder(componentBorder);
		mapButtonsPanel.setMinimumSize(new Dimension(598, 40));
		mapButtonsPanel.setPreferredSize(new Dimension(598, 40));
		mapButtonsPanel.setMaximumSize(new Dimension(598, 40));

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
		logPanel.addMouseListener(this);

		validationLogPanel = new JPanel();
		validationLogPanel.addMouseListener(this);

		shortLogPanel = new JPanel();
		shortLogPanel.addMouseListener(this);

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
		if (e.getSource().equals(projectNameLabel)) {
			statusBarLabel.setText("SOPERA DITA Framework");
		} else if (e.getSource().equals(mapList)) {
			statusBarLabel.setText("List of ditamaps");
		} else if (e.getSource().equals(logPanel)) {
			statusBarLabel.setText("Information about transformation process");
		} else if (e.getSource().equals(validationLogPanel)) {
			statusBarLabel.setText("Information about validation process");
		} else if (e.getSource().equals(shortLogPanel)) {
			statusBarLabel
					.setText("Log with main information about convertation process");
		}// else if (me.getSource().equals(logText)) {
		// statusBar.setText("Information about convertation process");
		// } else if (me.getSource().equals(progressBar)) {
		// statusBar.setText("Progress bar");
		// } else if (me.getSource().equals(cbHtml)) {
		// statusBar.setText("Select to generate HTML output");
		// } else if (me.getSource().equals(cbPdf)) {
		// statusBar.setText("Select to generate PDF output");
		// } else if (me.getSource().equals(cbEclipse)) {
		// statusBar.setText("Select to generate Eclipse Help output");
		// } else if (me.getSource().equals(startButton)) {
		// statusBar.setText("Press to start generation process");
		// }
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
}
