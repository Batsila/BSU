#include <vector>
#include <iostream>
#include <algorithm>
#include <iomanip>
#include <cmath>
#include <time.h>

using namespace std;

const int SIZE = 5;
float **a, s[SIZE], x[SIZE], *b, _x[SIZE], err;
int m = 1, n = SIZE;
float k = 0, error = 0;

void gauss(float **a, float *b) {
	cout << "Gaus method: \n";
	for (int i = 0; i < n - 1; ++i) {
		for (int j = i + 1; j < n; ++j) {
			float coeff = a[j][i] / a[i][i];
			for (int z = i; z < n; ++z) {
				a[j][z] -= coeff * a[i][z];
			}
			b[j] -= coeff * b[i];
		}
	}
	cout << "After the 1st step: " << endl;
	for (int i = 0; i < n; ++i) {
		cout << fixed << setprecision(4);
		for (int j = 0; j < n; ++j) cout << setw(10) << a[i][j];
		cout << setw(10) << b[i] << endl;
	}
	cout << endl;

	for (int i = n - 1; i >= 1; --i) {
		for (int j = i - 1; j >= 0; --j) {
			float coeff = a[j][i] / a[i][i];
			a[j][i] = 0;
			b[j] -= coeff * b[i];
		}
	}
	float q = 0, w = 0;
	for (int i = 0; i < n; ++i) {
		_x[i] = b[i] / a[i][i];
		q += pow(_x[i] - x[i], 2);
		w += x[i] * x[i];
		cout << fixed << setprecision(10);
		cout << i << "x = " << setw(14) << x[i] << "   " << i << "_x = " << _x[i] << endl;
	}
	q = sqrt(q);
	w = sqrt(w);
	error = q / w * 100;
	cout << endl << "Error: " << fixed << setprecision(10) << error << "%" << endl;
}

void gauss_with_choice(float **a, float * b) {
	cout << "\nGaus method with choice: \n";
	for (int i = 0; i < n - 1; ++i) {
		float mx = a[i][i];
		int pos = i;
		for (int j = i + 1; j < n; ++j) {
			if (fabs(a[j][i]) > fabs(mx)) {
				mx = a[j][i];
				pos = j;
			}
		}
		for (int z = 0; z < n; ++z) {
			swap(a[i][z], a[pos][z]);
		}
		swap(b[i], b[pos]);
		for (int j = i + 1; j < n; ++j) {
			float coeff = a[j][i] / a[i][i];
			for (int z = i; z < n; ++z) {
				a[j][z] -= coeff * a[i][z];
			}
			b[j] -= coeff * b[i];
		}
	}
	cout << "After the 1st step: " << endl;
	for (int i = 0; i < n; ++i) {
		cout << fixed << setprecision(4);
		for (int j = 0; j < n; j++) cout << setw(10) << a[i][j];
		cout << setw(10) << b[i] << endl;
	}
	cout << endl;
	for (int i = n - 1; i >= 1; --i) {
		for (int j = i - 1; j >= 0; --j) {
			float coeff = a[j][i] / a[i][i];
			a[j][i] = 0;
			b[j] -= coeff * b[i];
		}
	}
	float q = 0, w = 0;
	for (int i = 0; i < n; ++i) {
		_x[i] = b[i] / a[i][i];
		q += pow(_x[i] - x[i], 2);
		w += x[i] * x[i];
		cout << fixed << setprecision(10);
		cout << i << "x = " << setw(14) << x[i] << "   " << i << "_x = " << _x[i] << endl;
	}
	q = sqrt(q);
	w = sqrt(w);
	error = q / w * 100;
	cout << endl << "Error: " << fixed << setprecision(10) << error << "%" << endl;
}

int main() {
	system("color F");
	srand(time(0));
	a = new float*[SIZE];
	b = new float[SIZE];
	for (int i = 0; i < n; ++i) {
		a[i] = new float[SIZE];
		s[i] = 0;
		for (int j = 0; j < n; ++j) {
			if (i != j) {
				a[i][j] = rand() % 200 - 100;
				s[i] += a[i][j];
			}
		}
		a[i][i] = -s[i];
	}
	a[0][0] += pow(10, -k);
	for (int i = 0; i < n; ++i) {
		b[i] = 0;
		x[i] = m + i;
	}
	for (int i = 0; i < n; ++i){
		for (int j = 0; j < n; ++j){
			b[i] += a[i][j] * x[j];
		}
	}

	float** a1 = new float*[SIZE];
	float* b1 = new float[SIZE];
	float** a2 = new float*[SIZE];
	float* b2 = new float[SIZE];
	cout << "Matrix Aw: " << endl;
	for (int i = 0; i < n; ++i) {
		a1[i] = new float[SIZE];
		a2[i] = new float[SIZE];
		for (int j = 0; j < n; ++j) {
			cout << setw(5) << a[i][j];
			a1[i][j] = a2[i][j] = a[i][j];
		}
		cout << setw(6) << b[i] << endl;
		b1[i] = b2[i] = b[i];
	}
	cout << endl;
	gauss(a1, b1);
	gauss_with_choice(a2, b2);
	cout << endl;
	system("pause");
	return 0;
}
