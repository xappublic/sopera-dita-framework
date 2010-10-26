package org.sopera.dita.framework;

import java.awt.Cursor;

import javax.swing.*;

public class MainWindow {

	private JFrame jFrame;
	
	public MainWindow() {
		jFrame = new JFrame("SOPERA DITA Framework");
		jFrame.setSize(800, 600);
		jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		jFrame.setResizable(false);
		jFrame.setContentPane(new FrameworkContentPane());
		jFrame.setCursor(new Cursor(Cursor.HAND_CURSOR));
		jFrame.setVisible(true);
	}

	public static void main(String[] args) {
		SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				new MainWindow();
			}
		});
	}
}
