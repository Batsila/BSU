namespace MySnake
{
    partial class MainForm
    {
        /// <summary>
        /// Обязательная переменная конструктора.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Освободить все используемые ресурсы.
        /// </summary>
        /// <param name="disposing">истинно, если управляемый ресурс должен быть удален; иначе ложно.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Код, автоматически созданный конструктором форм Windows

        /// <summary>
        /// Требуемый метод для поддержки конструктора — не изменяйте 
        /// содержимое этого метода с помощью редактора кода.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
            this.Field = new System.Windows.Forms.PictureBox();
            this.StartButton = new System.Windows.Forms.Button();
            this.labelScore = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.Field)).BeginInit();
            this.SuspendLayout();
            // 
            // Field
            // 
            this.Field.BackColor = System.Drawing.SystemColors.GradientInactiveCaption;
            this.Field.Location = new System.Drawing.Point(21, 35);
            this.Field.Name = "Field";
            this.Field.Size = new System.Drawing.Size(360, 366);
            this.Field.TabIndex = 0;
            this.Field.TabStop = false;
            this.Field.Visible = false;
            this.Field.Paint += new System.Windows.Forms.PaintEventHandler(this.Field_Paint);
            // 
            // StartButton
            // 
            this.StartButton.Font = new System.Drawing.Font("Monotype Corsiva", 18F, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.StartButton.Location = new System.Drawing.Point(158, 197);
            this.StartButton.Name = "StartButton";
            this.StartButton.Size = new System.Drawing.Size(83, 37);
            this.StartButton.TabIndex = 1;
            this.StartButton.TabStop = false;
            this.StartButton.Text = "Start";
            this.StartButton.UseVisualStyleBackColor = true;
            this.StartButton.Click += new System.EventHandler(this.StartButton_Click);
            // 
            // labelScore
            // 
            this.labelScore.AutoSize = true;
            this.labelScore.Font = new System.Drawing.Font("Monotype Corsiva", 11.25F, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.labelScore.Location = new System.Drawing.Point(18, 419);
            this.labelScore.Name = "labelScore";
            this.labelScore.Size = new System.Drawing.Size(51, 17);
            this.labelScore.TabIndex = 2;
            this.labelScore.Text = "Score: 0";
            this.labelScore.Visible = false;
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.GradientActiveCaption;
            this.ClientSize = new System.Drawing.Size(406, 445);
            this.Controls.Add(this.labelScore);
            this.Controls.Add(this.StartButton);
            this.Controls.Add(this.Field);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.KeyPreview = true;
            this.MaximumSize = new System.Drawing.Size(422, 484);
            this.MinimumSize = new System.Drawing.Size(422, 484);
            this.Name = "MainForm";
            this.Text = "MySnake";
            this.Load += new System.EventHandler(this.MainForm_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.MainForm_KeyDown);
            ((System.ComponentModel.ISupportInitialize)(this.Field)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.PictureBox Field;
        private System.Windows.Forms.Button StartButton;
        private System.Windows.Forms.Label labelScore;
    }
}

