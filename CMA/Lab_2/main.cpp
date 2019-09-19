#include <iostream>
#include <vector>
#include <iomanip>
#include <stdlib.h>
#include <algorithm>
#include <math.h>
#include <time.h>

using namespace std;

const int SIZE = 10;
float **a, s[SIZE], x[SIZE], *b, _x[SIZE];
int m = 1, n = SIZE;
float k = 0;

void ldlt(float **a, float *b){
    //Сохранение матрицы А
    float **buf = new float*[SIZE];
    for (int i = 0; i < SIZE; ++i){
        buf[i] = new float[SIZE];
        for (int j = 0; j < SIZE; ++j) {
            buf[i][j] = a[i][j];
        }
    }
    //ldlt-разложение
    float *t = new float[SIZE];
    for (int k = 0; k < n - 1; ++k){
        for (int i = k + 1; i < n; ++i){
            t[i] = a[i][k];
            a[i][k] = a[i][k] / a[k][k];
            for (int j = k + 1; j <= i; ++j){
                a[i][j] = a[i][j] - a[i][k] * t[j];
            }
        }
    }
    //Вывод матрицы L
    cout << "\nМатрица L:\n";
    for (int i = 0; i < SIZE; ++i){
        for (int j = 0; j < SIZE; ++j){
            float x = a[i][j];
            if (i == j)
                x = 1;
            else if (i < j)
                cout << setw(8) << fixed << setprecision(2) << x;
        }
        cout << endl;
    }
    //Вывод матрицы D
    cout << "Матрица D:" << endl;
    for (int i = 0; i < SIZE; ++i){
        for (int j = 0; j < SIZE; ++j){
            cout.width(5);
            cout << fixed << setprecision(2) << setw(8) << ((i == j) ? a[i][j] : 0);
        }
        cout << endl;
    }
    //Решение уравнения Ly=b
    float *_y = new float[SIZE];
    for (int i = 0; i < n; ++i){
        float sum = 0;
        for (int j = 0; j < i; ++j){
            sum += a[i][j] * _y[j];
        }
        _y[i] = b[i] - sum;
    }
    //Перемножение D и Lt
    float *d = new float[SIZE];
    for (int i = 0; i < n; ++i){
        d[i] = a[i][i];
        a[i][i] = 1;
    }
    for (int i = 0; i < n; ++i){
        for (int j = i; j < n; ++j){
            a[j][i] = d[i] * a[j][i];
        }
    }
    float *_x = new float[SIZE];
    //Получение x*
    for (int i = n - 1; i >= 0; --i){
        float sum = 0;
        for (int j = i + 1; j < n; ++j){
            sum += a[j][i] * _x[j];
        }
        _x[i] = (_y[i] - sum) / a[i][i];
    }
    for (int i = 0; i < SIZE; ++i){
        for (int j = 0; j < SIZE; ++j){
            a[i][j] = buf[i][j];
        }
    }
    cout << endl << "Вектор X*: \n";
    for (int i = 0; i < n; ++i){
        cout << fixed << setprecision(8) << _x[i] << " ";
    }
    cout << endl;
    float q = 0, w = 0;
    //Подсчет относительной погрешности
    for (int i = 0; i < n; ++i){
        q += pow(_x[i] - x[i], 2);
        w += x[i] * x[i];
    }
    q = sqrt(q);
    w = sqrt(w);
    double error = q / w;
    cout << endl << "Относительная погрешность: " << fixed << setprecision(8) << error << endl;
}

int main(){
    setlocale(LC_ALL,".1251");
    srand(time(0));
    a = new float*[SIZE];
    b = new float[SIZE];
    //Генерация матрицы А
    for (int i = 0; i < n; ++i){
        a[i] = new float[SIZE];
    }
    for (int i = 0; i < n; ++i){
        for (int j = i + 1; j < n; ++j){
            if (i != j){
                a[i][j] = rand() % 5 - 4;
                a[j][i] = a[i][j];
                }
        }
    }
    for (int i = 0; i < n; ++i){
        s[i] = 0;
        for (int j = 0; j < n; ++j){
            if (i != j){
                s[i] += a[i][j];
            }
            a[i][i] = -s[i]; //получение диагональных элементов
        }
    }
    cout << "При k = 0:" << endl;
    k = 0;
    a[0][0] += pow(10, -k);
    //вычисление x и b
    for (int i = 0; i < n; ++i){
        b[i] = 0;
        x[i] = m + i;
    }
    for (int i = 0; i < n; ++i){
        for (int j = 0; j < n; ++j){
            b[i] += a[i][j] * x[j];
        }
    }
    cout << endl << "Матрица A расширенная: \n";
    for (int i = 0; i < n; ++i){
        for (int j = 0; j < n; ++j){
            cout << setw(4) << setprecision(4) << a[i][j] << " ";
        }
        cout << "|" << setw(4) << b[i] << endl;
    }
    cout << endl << "Вектор X: \n";
    for (int i = 0; i < n; ++i){
        cout << setw(4) << x[i];
    }
    cout << endl;
    ldlt(a, b);//Применение ldlt для k=0
    cout << endl;
    cout << "При k = 2:" << endl;
    k = 2;
    a[0][0] += -1 + pow(10, -k);
    //вычисление x и b
    for (int i = 0; i < n; ++i){
        b[i] = 0;
        x[i] = m + i;
    }
    for (int i = 0; i < n; ++i){
        for (int j = 0; j < n; ++j){
            b[i] += a[i][j] * x[j];
        }
    }
    cout << endl << "Матрица A расширенная:" << endl;
    for (int i = 0; i < n; ++i){
        for (int j = 0; j < n; ++j){
            cout << setw(8) <<setprecision(4) << a[i][j];
        }
        cout << "|" << setw(8) << b[i] << endl;
    }
    cout << endl << "Вектор X: \n";
    for (int i = 0; i < n; ++i){
        cout << x[i] << " ";
    }
    cout << endl;
    //Применение ldlt для k=2
    ldlt(a, b);
    return 0;
}
