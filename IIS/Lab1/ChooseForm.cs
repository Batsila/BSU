using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace Lab1
{
    public partial class ChooseForm : Form
    {
        public string Result { get; private set; }

        public ChooseForm(string text, HashSet<string> possibleValues)
        {
            Result = string.Empty;
            InitializeComponent();
            label1.Text = text;
            for(int i = 0; i < possibleValues.Count; i++)
            {
                comboBox1.Items.Add(possibleValues.ElementAt(i));
            }
        }

        private void ComboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            Result = comboBox1.SelectedItem.ToString();
        }

        private void Button1_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
