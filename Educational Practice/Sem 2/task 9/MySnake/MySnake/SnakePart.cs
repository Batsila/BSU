using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Drawing;

namespace MySnake
{
    public class SnakePart
    {
        private Point point;
        private Color color;
        public SnakePart(int x, int y, Color color)
        {
            point = new Point(x, y);
            this.color = color;
        }
        public Point GetPoint()
        {
            return point;
        }
        public Color GetColor()
        {
            return color;
        }
        public void ChangeColor(Color color)
        {
            this.color = color;
        }
    }
}