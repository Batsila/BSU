#include <vector>
#include <fstream>
#include <iostream>
#include <algorithm>
#include <math.h>
#include <time.h>
#include <iomanip>
using namespace std;

const int SIZE = 10;
const float EPS = 0.0001;
const float KMAX = 1000;
float **a, s[SIZE], x[SIZE], *b;
int m = 1;
int n = SIZE;

float delta(float *prev, float *x){
	float res = fabs(x[0] - prev[0]);
	for (int i = 1; i < n; ++i){
		res = max(res, (float)fabs(x[0] - prev[0]));
	}
	return res;
}
// Задание 1 : Метод Якоби
void jacoby(float **a, float * f){
	int iter = 0;
	float *x = new float[SIZE];
	float *prev = new float[SIZE];
	for (int i = 0; i < n; ++i){
		x[i] = f[i] / a[i][i];
	}
    // Выполнять, пока количество итераций не превысит заданное Kmax
	while (iter < KMAX){
		for (int i = 0; i < n; ++i){
			prev[i] = x[i];
			x[i] = 0;
		}
		for (int i = 0; i < n; ++i){
			for (int j = 0; j < n; ++j){
				if (i != j){
					x[i] -= a[i][j] * prev[j];
				}
			}
			x[i] += f[i];
			x[i] /= a[i][i];
		}
        // Проверка на досрочный выход из цикла
		if (delta(prev, x) < EPS){
            break;
        }
        // Переходим к следующей итерации
		++iter;
	}
    // Вывод итоговой информации
    cout << endl << "The Jacobi Method:" << endl;
	cout << "Iterations count: " << iter + 1 << endl;
    cout << "Precision: " << delta(prev, x) << endl;
	cout << "Vector x: ";
	for (int i = 0; i < n; ++i){
		cout << fixed << setprecision(4) << x[i] << " ";
	}
	cout << endl;
}
// Задание 2 : Метод Релаксации
void relaxation(float **a, float * f, float w){
	int iter = 0;
	float *x = new float[SIZE];
	float *prev = new float[SIZE];
	for (int i = 0; i < n; ++i){
		x[i] = f[i] / a[i][i];
	}
    // Выполнять, пока количество итераций не превысит заданное Kmax
	while (iter < KMAX){
		for (int i = 0; i < n; ++i){
			prev[i] = x[i];
			x[i] = 0;
		}
		for (int i = 0; i < n; ++i){
			for (int j = 0; j < i; ++j){
				x[i] -= a[i][j] * x[j];
			}
			for (int j = i + 1; j < n; ++j){
				x[i] -= a[i][j] * prev[j];
			}
			x[i] += f[i];
			x[i] *= w;
			x[i] /= a[i][i];
			x[i] += (1 - w) * prev[i];
		}
        // Проверка на досрочный выход из цикла
		if (delta(prev, x) < EPS){
            break;
        }
        // Переходим к следующей итерации
		iter++;
	}
    // Вывод итоговой информации
    cout << endl << "Relaxation method:" << endl;
	cout << "Iterations count: " << iter + 1 << endl;
	cout << "w = " << w << endl;
    cout << "Precision: " << delta(prev, x) << endl;
	cout << "Vector x: ";
	for (int i = 0; i < n; i++){
		cout << fixed << setprecision(4) << x[i] << " ";
	}
	cout << endl;
}
int main()
{
	srand(time(0));
	a = new float*[SIZE];
	b = new float[SIZE];
    const float w1 = 0.5;
    const float w2 = 1;
    const float w3 = 1.5;
	// Генерация матрицы A
	for (int i = 0; i < n; ++i){
		a[i] = new float[SIZE];
	}
	for (int i = 0; i < n; ++i){
		for (int j = i + 1; j < n; ++j)
            // Если элемент не на главной диагонали,
            // то генерируем числа от -4 до 0
			if (i != j){
				a[i][j] = rand() % 5 - 4;
				a[j][i] = a[i][j];
			}
	}
	for (int i = 0; i < n; ++i){
		s[i] = 0;
		for (int j = 0; j < n; ++j){
			if (i != j){
				s[i] += a[i][j];
			}
			a[i][i] = -s[i];
		}
	}
	a[0][0] += 1;
	// Вычисления x и b
	for (int i = 0; i < n; ++i){
		b[i] = 0;
		x[i] = m + i;
	}
	for (int i = 0; i < n; ++i){
		for (int j = 0; j < n; ++j){
			b[i] += a[i][j] * x[j];
		}
	}
	cout << "Matrix A expended:" << endl;
	for (int i = 0; i < n; ++i){
		for (int j = 0; j < n; ++j){
            cout << setw(5) << setprecision(5) << a[i][j] << " ";
        }
		cout << "|" << setw(5) << b[i] << endl;
	}
    // Вывод вектора X
	cout << endl << "Vector X initial: ";
	for (int i = 0; i < n; ++i){
        cout << x[i] << " ";
    }
	cout << endl;
	jacoby(a, b);
    // Вызов метода релаксации для трех различных w
	relaxation(a, b, w1);
    relaxation(a, b, w2);
    relaxation(a, b, w3);
	return 0;
}

