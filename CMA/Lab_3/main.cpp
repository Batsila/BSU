#include <iostream>
#include <vector>
#include <fstream>
#include <iomanip>
#include <algorithm>
#include <math.h>

using namespace std;

vector< vector<float> > arr;
vector< float > f, y, _y;
int m = 1, n = 9, k = 2;// m - номер в группе, k - номер группы

void do_sweep() {
	//Заполнение a, b, c
	vector<float> a, b, c;
	a.push_back(0);
	c.push_back(arr[0][0]);
	for (int i = 1; i < n + 1; ++i) {
		a.push_back(-arr[i][i - 1]);
		b.push_back(-arr[i - 1][i]);
		c.push_back(arr[i][i]);
	}
	b.push_back(0);
	//Вычисление коэффициентов alpha и beta
	vector<float> alp, bet;
	alp.push_back(b[0] / c[0]);
	bet.push_back(f[0] / c[0]);
	for (int i = 1; i < n; ++i) {
		alp.push_back(b[i] / (c[i] - a[i] * alp[i - 1]));
		bet.push_back((f[i] + a[i] * bet[i - 1]) / (c[i] - a[i] * alp[i - 1]));
	}
	bet.push_back((f[n] + a[n] * bet[n - 1]) / (c[n] - a[n] * alp[n - 1]));
	//Вывод матрицы после прямой прогонки
	cout << "\nМатрица после прямой прогонки:\n";
	for (int i = 0; i < n + 1; i++)
	{
		for (int j = 0; j < n + 1; j++)
		{
			if (i == j) arr[i][j] = 1; else
				if (i + 1 == j) arr[i][j] = -alp[i]; else
					arr[i][j] = 0;
			cout << setw(8) <<  fixed << setprecision(4) << arr[i][j];
		}
		cout << setw(2) << "|" << setw(8) << fixed << setprecision(4) << f[i] << endl;
	}
	//Вычисление вектора приближенного решения
	_y.push_back(bet[n]);
	for (int i = n - 1; i >= 0; --i) {
		_y.push_back(alp[i] * _y[n - i - 1] + bet[i]);
	}
	reverse(_y.begin(), _y.end());
	//Вывод вектора приближенного значения
	cout << "\nВектор приближенного решения:\n";
	for (int i = 0; i < n + 1; ++i) {
		cout << setw(8) << fixed << setprecision(9) << _y[i] << " ";
	}
	float q = 0, w = 0;
    //Подсчет относительной погрешности
	for (int i = 0; i < n; ++i) {
		q += pow(_y[i] - y[i], 2);
		w += y[i] * y[i];
	}
	q = sqrt(q);
	w = sqrt(w);
	double error = q / w * 100;
	cout << endl;
	cout << "Относительная погрешность: " << fixed << setprecision(8) << error << "%" << endl;
}

int main() {
	setlocale(LC_ALL, ".1251");
	for (int i = 0; i < n + 1; ++i) {
        y.push_back(i + 1);
	}
	for (int i = 0; i < n + 1; ++i) {
		arr.push_back({});
		for (int j = 0; j < n + 1; ++j) {
                arr[i].push_back(0);
		}
	}
	//Заполнение матрицы изначальными значениями
	arr[0][0] = m;
	for (int i = 0; i < n; ++i) {
		arr[i + 1][i] = -k;
		arr[i][i + 1] = m + i - 1;
		arr[i + 1][i + 1] = m + k + i;
	}
	//Вычисление f
	for (int i = 0; i < n + 1; ++i) {
		float val = 0;
		for (int j = 0; j < n + 1; ++j) {
           val += arr[i][j] * y[j];
		}
		f.push_back(val);
	}
    cout << "Матрица: \n";
	for (int i = 0; i < n + 1; ++i) {
		for (int j = 0; j < n + 1; j++) {
            cout << setw(4) << arr[i][j];
		}
		cout << setw(2) << "|" << setw(4) << f[i] << endl;
	}
	do_sweep();
    return 0;
}
