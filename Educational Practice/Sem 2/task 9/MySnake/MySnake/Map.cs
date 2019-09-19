using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace MySnake
{
    class Map
    {
        private List<Cherry> cherrys = new List<Cherry>();
        private int Width;
        private int Height;
        private int CherrysNumber = 1;
        Random random = new Random();

        public Map(int width, int height)
        {
            this.Height = height;
            this.Width = width;
            for (int i = 0; i < CherrysNumber; ++i)
            {
                cherrys.Add(new Cherry(random.Next(0, width - 1), random.Next(0, height - 1), 1));
            }
        }
        public void RegenerateCherrys(int pos)
        {
            cherrys[pos].SetPoint(random.Next(0, Width - 1), random.Next(0, Height - 1));
        }
        public List<Cherry> GetCherrys()
        {
            return cherrys;
        }
    }
}