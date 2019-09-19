using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Drawing;

namespace MySnake
{
    class Game
    {
        private Map map;
        private Snake snake;
        private int Score;
        private int Width;
        private int Height;
        public Game(int width, int height)
        {
            this.Width = width;
            this.Height = height;
            map = new Map(width, height);
            snake = new Snake(width / 2, height / 2);
            Score = 0;
        }

        public Snake GetSnake()
        {
            return snake;
        }
        public int GetScore()
        {
            return Score;
        }
        public Map GetMap()
        {
            return map;
        }
        public bool MoveSnake()
        {
            bool crashed = !snake.Move();
            Point head = snake.GetHead().GetPoint();
            if (head.X < 0 || head.X >= Width || head.Y < 0 || head.Y > Height || crashed)
                return false;
            List<Cherry> cherrys = map.GetCherrys();
            int i = 0;
            foreach (Cherry cherry in cherrys)
            {
                Point point = cherry.GetPoint();
                if (point.X == head.X && point.Y == head.Y)
                {
                    snake.Increase();
                    ++Score;
                    map.RegenerateCherrys(i);
                    break;
                }
                ++i;
            }
            return true;
        }
    }
}