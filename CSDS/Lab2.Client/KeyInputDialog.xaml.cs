using System;
using System.Collections.Generic;
using System.Text;
using System.Windows;

namespace Lab2.Client
{
    public partial class KeyInputDialog : Window
    {
        public KeyInputDialog()
        {
            InitializeComponent();
        }

        public string Key
        {
            get { return KeyTextBox.Text; }
            set { KeyTextBox.Text = value; }
        }

        private void KeyTextBox_TextChanged(object sender, EventArgs e)
        {
            if (Key.Length == 8)
                DialogResult = true;
        }
    }
}
