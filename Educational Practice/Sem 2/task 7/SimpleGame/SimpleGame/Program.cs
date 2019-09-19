/*Краткое описание модели игры:
1. класс карты
2. класс юнита, основной игровой класс
3. дочерние от юнита классы: персонаж и здание
4. дочерний от персонажа класс: герой
*/
using System;

public enum BuildingType { barracks , tower , guildhall };
public enum Ability { treatment, damaging };

namespace SimpleGame
{
    public struct Position
    {
        public int x;
        public int y;
    }
    public class Map
    {
        protected int width;
        protected int height;
        protected bool[,] free;
        public Map(int width, int height)
        {
            this.width = width;
            this.height = height;
            this.free = new bool[width, height];
            for (int i = 0; i < width; ++i) {
                for (int j = 0; j < height; ++j) {
                    free[i, j] = true;
                }
            }
        }
        public bool check(int x, int y) {
            if (x < width && y < height)
            {
                return free[x, y];
            }
            else
            {
                return false;
            }
        }
        public void set(int x, int y) {
            this.free[x, y] = false;
        }
    }

    public class Unit
    {
        protected int health;
        protected int healthMax;
        protected int armor;
        protected Position position;
        public Unit(int health, int armor, int posX, int posY){
            this.position.x = posX;
            this.position.y = posY;
            this.health = health;
            this.healthMax = health;
            this.armor = armor;
        }
        public void getDamage(int damage) {
            this.health -= damage / armor;
            if (this.health < 0)
            {
                this.health = 0;
            }
        }
        public virtual void recover(int healthPoints) {
            this.health += healthPoints;
            if (this.health > this.healthMax)
            {
                this.health = this.healthMax;
            }
        }
        public Position getPosition() {
            return this.position;
        }
        public void setPosition(int x, int y) {
            this.position.x = x;
            this.position.y = y;
        }
    }
    public class Person : Unit
    {
        protected int speed;
        protected int attackPower;
        protected int attackRange;
        protected bool flyAbility;
        public Person(int health, int armor, int posX, int posY, int speed, int attackPower, int attackRange,
            bool flyAbility) : base(health, armor, posX, posY){
            this.speed = speed;
            this.attackPower = attackPower;
            this.attackRange = attackRange;
            this.flyAbility = flyAbility;
        }
        public bool attack(Unit unit){
            if ((unit.getPosition().x - this.position.x) * (unit.getPosition().x - this.position.x) +
                (unit.getPosition().y - this.position.y) * (unit.getPosition().y - this.position.y) <
                this.attackRange * this.attackRange)
            {
                unit.getDamage(this.attackPower);
                return true;
            }
            else
            {
                return false;
            }
        }
        public bool go(int posX, int posY, Map map) {
            if (this.flyAbility)
            {
                if ((this.getPosition().x - posX) * (this.getPosition().x - posX) + (this.getPosition().y - posY) *
                    (this.getPosition().y - posY) < this.speed && map.check(posX, posY))
                {
                    this.setPosition(posX, posY);
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else {
                if ((this.getPosition().x - posX) * (this.getPosition().x - posX) + (this.getPosition().y - posY) *
                    (this.getPosition().y - posY) < this.speed)
                {
                    this.setPosition(posX, posY);
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }
    }
    public class Building : Unit
    {
        protected BuildingType type;
        public Building(int health, int armor, int posX, int posY, BuildingType type, Map map) 
            : base(health, armor, posX, posY) {
            this.type = type;
            if (map.check(posX, posY))
            {
                map.set(posX, posY);
            }
            else {
                Exception exc = new Exception("Uncorrect place :(");
                throw exc;
            }
        }
    }
    public class Hero : Person
    {
        protected int mana;
        protected int manaMax;
        protected int level;
        protected Ability ability;
        public Hero(int health, int armor, int posX, int posY, int speed, int attackPower, int attackRange, 
            bool flyAbility, int mana, Ability ability, int level) 
            : base(health, armor, posX, posY, speed, attackPower, attackRange, flyAbility)
        {
            this.ability = ability;
            this.manaMax = mana + level;
            this.mana = mana + level;
            this.healthMax = health + level;
            this.health = health + level;
            this.level = level;
        }
        public override void recover(int points) {
            this.mana += points;
            this.health += points;
            if (this.mana > this.manaMax)
            {
                this.mana = this.manaMax;
            }
            if (this.health > this.healthMax)
            {
                this.health = this.healthMax;
            }
        }
        public void levelUp(int level) {
            this.level += level;
            this.healthMax += level;
            this.manaMax += level;
        }
        public bool useAbility(Unit unit) {
            if (this.ability == Ability.damaging)
            {
                if (this.mana >= this.level)
                {
                    this.mana -= this.level;
                    unit.getDamage(this.level);
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else if (this.ability == Ability.treatment)
            {
                if (this.mana >= this.level)
                {
                    this.mana += this.level;
                    unit.recover(this.level);
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else {
                return false;
            }
        }
    }
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("OK");//просто проверить, что компилится
        }
    }
}