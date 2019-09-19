using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Drawing;

namespace MySnake
{
    class Cherry
    {
        int health = 1;
        Point point;
        Color color;
        public Cherry(int x, int y, int health)
        {
            point = new Point(x, y);
            this.health = health;
        }
        public Point GetPoint()
        {
            return point;
        }
        public Color GetColor()
        {
            return color;
        }
        public void SetPoint(int x, int y)
        {
            point.X = x;
            point.Y = y;
        }
        public int GetHealth()
        {
            return health;
        }
    }
}