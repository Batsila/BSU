using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Drawing;

namespace MySnake
{
    class Snake
    {
        private List<SnakePart> parts = new List<SnakePart>();
        private int dx = 0;
        private int dy = -1;
        private int flag = 0;
        public Snake(int x, int y)
        {
            parts.Add(new SnakePart(x, y, Color.Red));
            parts.Add(new SnakePart(x, y - dy, Color.Black));
        }

        public SnakePart GetHead()
        {
            return parts[0];
        }
        public List<SnakePart> GetParts()
        {
            return parts;
        }
        public void ChangeDirection(int dx, int dy)
        {
            if (this.dx != dx && this.dy != dy)
            {
                this.dx = dx;
                this.dy = dy;
            }
        }
        public bool Move()
        {
            parts[0].ChangeColor(Color.Red);
            if (flag == 0)
                parts.RemoveAt(parts.Count - 1);
            Point head = parts[0].GetPoint();
            parts.Insert(0, new SnakePart(head.X + dx, head.Y + dy, Color.Black));
            head = parts[0].GetPoint();
            flag = 0;
            for (int i = 1; i < parts.Count; ++i)
            {
                Point point = parts[i].GetPoint();
                if (point.X == head.X && point.Y == head.Y)
                    return false;
            }
            return true;
        }
        public void Increase()
        {
            flag = 1;
        }
    }
}