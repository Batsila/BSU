using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Timers;

namespace MySnake
{
    public partial class MainForm : Form
    {
        private System.Timers.Timer timer;
        Game game;
        Map map;
        Snake snake;
        int screenWidth, screenHeight;
        float scale;
        int xSize = 40, ySize = 40;
        bool gameOver = false;
        public MainForm()
        {
            InitializeComponent();
        }

        private void StartButton_Click(object sender, EventArgs e)
        {
            gameOver = false;
            StartButton.Visible = false;
            StartButton.Enabled = false;
            Field.Visible = true;
            labelScore.Visible = true;
            game = new Game(xSize, ySize);
            screenWidth = Field.Size.Width;
            screenHeight = Field.Size.Height;
            scale = Math.Min((float)screenHeight / ySize, (float)screenWidth / xSize);
            snake = game.GetSnake();
            map = game.GetMap();
            timer = new System.Timers.Timer(50);
            timer.Elapsed += OnTimedEvent;
            timer.AutoReset = true;
            Field.Invalidate();
            timer.Start();
        }
        private void OnTimedEvent(object sender, ElapsedEventArgs e)
        {
            if (!game.MoveSnake())
                Gameover();
            Field.Invalidate();
        }
        private void Gameover()
        {
            timer.Stop();
            gameOver = true;
        }

        private void MainForm_Load(object sender, EventArgs e)
        {

        }

        private void MainForm_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Left) snake.ChangeDirection(-1, 0);
            else
            if (e.KeyCode == Keys.Right) snake.ChangeDirection(1, 0);
            else
            if (e.KeyCode == Keys.Up) snake.ChangeDirection(0, -1);
            else
            if (e.KeyCode == Keys.Down) snake.ChangeDirection(0, 1);
            else
            {
                if (e.KeyCode == Keys.Space)
                {
                   if (timer.Enabled) timer.Stop(); else timer.Start();
                }
            }
        }
        private void Field_Paint(object sender, PaintEventArgs e)
        {
            if (gameOver)
            {
                StartButton.Visible = true;
                StartButton.Enabled = true;
                Field.Visible = false;
                labelScore.Visible = false;
            }
            Graphics g = e.Graphics;
            SolidBrush sb = new SolidBrush(Color.Black);
            List<SnakePart> parts = snake.GetParts();
            List<Cherry> cherrys = map.GetCherrys();
            foreach (SnakePart part in parts)
            {
                Point point = part.GetPoint();
                sb.Color = part.GetColor();
                g.FillRectangle(sb, new RectangleF(point.X * scale, point.Y * scale, scale, scale));
            }
            labelScore.Text = "Score: " + game.GetScore().ToString();
            foreach (Cherry c in cherrys)
            {
                Point point = c.GetPoint();
                sb.Color = Color.Yellow;
                g.FillEllipse(sb, new RectangleF(point.X * scale, point.Y * scale, scale, scale));
            }
        }
    }
}
