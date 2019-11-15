using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Windows.Forms;

namespace Lab1
{
    public partial class MainForm : Form
    {
        public List<Rule> Rules { get; private set; }

        public List<Property> KnownValues { get; private set; }

        public bool BeginState { get; private set; }

        public string ValueToSearch { get; private set; }

        public MainForm()
        {
            ValueToSearch = "Language";

            BeginState = true;

            Rules = new List<Rule>();

            KnownValues = new List<Property>();

            InitializeComponent();

            InitRules();

            FillCombo();
        }

        private void Button1_Click(object sender, EventArgs e)
        {
            if (BeginState)
            {
                BeginState = false;

                string desired = ValueToSearch; ;

                string result = CheckDesired(desired);

                textBox2.Text = result;
            }

            using (StreamWriter streamWriter = new StreamWriter($@"{DateTime.Now.ToString("HHmmss")}.txt", false, System.Text.Encoding.Default))
            {
                KnownValues.ForEach(ob => streamWriter.WriteLine($"{ob.Name}={ob.Value}"));
            }

            KnownValues.Clear();

            BeginState = true;
        }

        private string CheckDesired(string desired)
        {
            if (KnownValues.Where(ob => ob.Name == desired).FirstOrDefault() != null)
            {
                return KnownValues.Where(ob => ob.Name == desired).FirstOrDefault().Value;
            }

            bool hasResult = false;
            string resultValue = "";

            for (int i = 0; i < Rules.Count; i++)
            {
                if (Rules[i].Result.Name == desired)
                {
                    bool correct = true;
                    for (int j = 0; j < Rules[i].Conditions.Count; j++)
                    {
                        if (correct)
                        {
                            string tempValue = CheckDesired(Rules[i].Conditions[j].Name);
                            if (tempValue != Rules[i].Conditions[j].Value)
                            {
                                correct = false;
                            }
                        }
                    }
                    if (correct == true)
                    {
                        hasResult = true;
                        resultValue = Rules[i].Result.Value;
                    }
                }
            }

            if (hasResult)
            {
                KnownValues.Add(new Property() { Name = desired, Value = resultValue });
                return resultValue;
            }

            label1.Text = "Enter " + desired + " Value";
            HashSet<string> set = CollectValues(desired);

            using (ChooseForm popup = new ChooseForm("Enter " + desired + " Value", set))
            {
                popup.ShowDialog();
                resultValue = popup.Result;
            }
            
            KnownValues.Add(new Property() { Name = desired, Value = resultValue });
            return resultValue;
        }

        private HashSet<string> CollectValues(string desiredProperty)
        {
            HashSet<string> result = new HashSet<string>();
            Rules.ForEach(el => el.Conditions.ForEach(ob => { if (ob.Name == desiredProperty) { result.Add(ob.Value); } }));
            Rules.ForEach(el => { if (el.Result.Name == desiredProperty) { result.Add(el.Result.Value); } });
            return result;
        }

        private void InitRules()
        {
            Rules.Add(new Rule()
            {
                Result = new Property() { Name = "Language", Value = "Lisp" },
                Conditions = new List<Property>()
                {
                    new Property() { Name = "Type", Value = "Functional" },
                    new Property() { Name = "Procedural", Value = "No" },
                    new Property() { Name = "Garbage-collector", Value = "No" }
                }
            });
            Rules.Add(new Rule()
            {
                Result = new Property() { Name = "Language", Value = "Assembler" },
                Conditions = new List<Property>()
                {
                    new Property() { Name = "Type", Value = "Operator" },
                    new Property() { Name = "Procedural", Value = "Yes" },
                    new Property() { Name = "Machine", Value = "Machine-dependent" },
                    new Property() { Name = "Garbage-collector", Value = "No" }
                }
            });
            Rules.Add(new Rule()
            {
                Result = new Property() { Name = "Language", Value = "Fort" },
                Conditions = new List<Property>()
                {
                    new Property() { Name = "Type", Value = "Operator" },
                    new Property() { Name = "Procedural", Value = "No" },
                    new Property() { Name = "Garbage-collector", Value = "No" }
                }
            });
            Rules.Add(new Rule()
            {
                Result = new Property() { Name = "Language", Value = "GPSS" },
                Conditions = new List<Property>()
                {
                    new Property() { Name = "Type", Value = "Operator" },
                    new Property() { Name = "Procedural", Value = "Yes" },
                    new Property() { Name = "Orientation", Value = "Problem-oriented" },
                    new Property() { Name = "Machine", Value = "Machine-independent" },
                    new Property() { Name = "Garbage-collector", Value = "No" }
                }
            });
            Rules.Add(new Rule()
            {
                Result = new Property() { Name = "Language", Value = "C#" },
                Conditions = new List<Property>()
                {
                    new Property() { Name = "Type", Value = "Operator" },
                    new Property() { Name = "Procedural", Value = "Yes" },
                    new Property() { Name = "Orientation", Value = "Object-oriented" },
                    new Property() { Name = "Garbage-collector", Value = "Yes" },
                    new Property() { Name = "Machine", Value = "Machine-independent" }
                }
            });
            Rules.Add(new Rule()
            {
                Result = new Property() { Name = "Language", Value = "C++" },
                Conditions = new List<Property>()
                {
                    new Property() { Name = "Type", Value = "Operator" },
                    new Property() { Name = "Procedural", Value = "Yes" },
                    new Property() { Name = "Orientation", Value = "Object-oriented" },
                    new Property() { Name = "Garbage-collector", Value = "No" },
                    new Property() { Name = "Machine", Value = "Machine-independent" }
                }
            });
            Rules.Add(new Rule()
            {
                Result = new Property() { Name = "Language", Value = "C" },
                Conditions = new List<Property>()
                {
                    new Property() { Name = "Type", Value = "Operator" },
                    new Property() { Name = "Procedural", Value = "Yes" },
                    new Property() { Name = "Orientation", Value = "Machine-oriented" },
                    new Property() { Name = "Machine", Value = "Machine-independent" },
                    new Property() { Name = "Garbage-collector", Value = "No" }
                }
            });
            Rules.Add(new Rule()
            {
                Result = new Property() { Name = "Orientation", Value = "Object-oriented" },
                Conditions = new List<Property>()
                {
                    new Property() { Name = "Garbage-collector", Value = "Yes" }
                }
            });
            Rules.Add(new Rule()
            {
                Result = new Property() { Name = "Type", Value = "Operator" },
                Conditions = new List<Property>()
                {
                    new Property() { Name = "Procedural", Value = "Yes" }
                }
            });
            Rules.Add(new Rule()
            {
                Result = new Property() { Name = "Procedural", Value = "Yes" },
                Conditions = new List<Property>()
                {
                    new Property() { Name = "Orientation", Value = "Machine-oriented" }
                }
            });
            Rules.Add(new Rule()
            {
                Result = new Property() { Name = "Machine", Value = "Machine-independent" },
                Conditions = new List<Property>()
                {
                    new Property() { Name = "Orientation", Value = "Object-oriented" }
                }
            });
        }

        private void FillCombo()
        {
            HashSet<string> result = new HashSet<string>();
            Rules.ForEach(el => el.Conditions.ForEach(ob => { result.Add(ob.Name); }));
            Rules.ForEach(el => result.Add(el.Result.Name));
            for (int i = 0; i < result.Count; i++)
            {
                comboBox1.Items.Add(result.ElementAt(i));
            }
        }

        private void ComboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            ValueToSearch = comboBox1.SelectedItem.ToString();
        }
    }
}
