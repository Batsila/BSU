#include <iostream>
#include <iomanip>
#include <algorithm>
#include <time.h>

using namespace std;

const int ITER = 52;

void func11(float** matr,float** u, float* l1, float* l2, float* vector1,float* vector2,float* m1,float* m2,float* lambda22,float** sobvector2,float** vector22,float* normi,int n){
	float** v = new float*[ITER];
	for (int i = 0; i < ITER; ++i) {
		v[i] = new float[n];
	}
	u[0][0]=1;
	for (int i = 1; i < n; ++i) {
		u[0][i] = 0;
	}
	//нахождение u и v
	for (int i = 1; i < ITER; ++i) {
		for (int j = 0; j < n; ++j) {
			float sum = 0;
			for (int k = 0; k < n; ++k) {
				sum += matr[j][k] * u[i-1][k];
			}
			v[i][j] = sum;
		}
		float Max = 0;
		for (int j = 0; j < n; ++j) {
			Max = max(Max, v[i][j]);
		}
		for (int j = 0; j < n; ++j) {
			u[i][j] = v[i][j] / Max;
		}
	}
	//нахождение собственных значений первым способом, вектора «погрешности»
	for (int i = 0; i < 5; ++i) {
		int sign = 1;
		if (u[46 + i][0] < 0)
			sign = -1;
		l1[i] = v[47 + i][0] * sign;
		if(i == 4)
			for (int j = 0; j < n; ++j)
				vector1[j] = v[47 + i][j] - l1[i] * u[46 + i][j];
	}
	//нахождение собственных значений вторым способом, вектора «погрешности»
	for (int i = 0; i < 5; ++i) {
		l2[i] = 0;
		float sum=0;
		for (int j = 0; j < 5; ++j)
			l2[i]+= v[47 + i][j] * u[46 + i][j];
		for (int j = 0; j < 5; ++j)
			sum += u[46 + i][j] * u[46 + i][j];
		l2[i] /= sum;
		if (i == 4)
			for (int j = 0; j < n; ++j)
				vector2[j] = v[47 + i][j] - l2[i] * u[46 + i][j];
	}
	*m1 = 0;
	*m2 = 0;
	for (int i = 0; i < n; ++i)
		*m1 = max(*m1, vector1[i]);
	for (int i = 0; i < n; ++i)
		*m2 = max(*m2, vector2[i]);
    //вычисление вторых собственных значений, соответсвующих векторов и тд.
	for (int i = 0; i < 3; ++i) {
		int m=50;
		if (i == 0)
			m = 30;
		int indx = 0;
		float Max = 0;
		float l = l1[4];
		if (i == 2)
			l = l2[4];
		for (int j = 0; j < n; ++j) {
			Max = max(v[m][j] - l * u[m - 1][j], Max);
			if (Max == v[m][j] - l * u[m - 1][j])
				indx = j;
		}
		Max = 0;
		for (int j = 0; j < n; ++j)
			Max = max(Max, v[m][j]);
		lambda22[i] = (v[m + 1][indx] * Max - l * v[m][indx]) / (v[m][indx] - l * u[m - 1][indx]);
		for (int j = 0; j < n; ++j)
			sobvector2[i][j] = v[51][j] - l*u[50][j];

		for (int j = 0; j < n; ++j) {
			float sum = 0;
			for (int k = 0; k < n; ++k) {
				sum += matr[j][k] * sobvector2[i][k];
			}
			vector22[i][j] = sum;
		}
		for (int j = 0; j < n; ++j)
			vector22[i][j] -= lambda22[i] * sobvector2[i][j];
		normi[i] = 0;
		for (int j = 0; j < n; ++j)
			normi[i] = max(vector22[i][j], normi[i]);
	}
}

int main(){
	int n = 10;
	float** matr = new float*[n];
	for (int i = 0; i < n; ++i)
		matr[i] = new float[n];
    srand(time(0));
	for (int i = 0; i < n; ++i)
		for (int j = 0; j < n; ++j)
			if (i < j)
				matr[i][j] = -(rand() % 5);//выбор элементов, не лежащих на главной диагонали
	for (int i = 0; i < n; ++i)
		for (int j = 0; j < n; ++j)
			if (i > j)
				matr[i][j] = matr[j][i];//выбор элементов, не лежащих на главной диагонали
	for (int i = 0; i < n; ++i) {
		float sum = 0;
		for (int j = 0; j < n; ++j)
			if (j != i)
				sum += matr[i][j];
		if (i != 0)
			matr[i][i] = -sum;//выбор элементов, лежащих на главной диагонали
	}
	float sum = 0;
	for (int i = 1; i < n; ++i)
		sum += matr[0][i];
	matr[0][0] = -sum + 1;
	float* lambda1 = new float[5];
	float* lambda2 = new float[5];
	float* lambda22 = new float[3];
	float* vector1 = new float[n];
	float* vector2 = new float[n];
	float** sobvector2 = new float*[3];
	for (int i = 0; i < 3; ++i)
		sobvector2[i] = new float[n];
	float max1 = 0;
	float max2 = 0;
	float** vector22 = new float*[3];
	for (int i = 0; i < 3; ++i)
		vector22[i] = new float[n];
	float* normi = new float[3];
	float** u = new float*[ITER];
	for (int i = 0; i < ITER; ++i)
		u[i] = new float[n];
	func11(matr,u, lambda1, lambda2,vector1,vector2, &max1,&max2,lambda22,sobvector2,vector22,normi, n);

	//Вывод данных
	setlocale(LC_ALL, ".1251");
	cout << "Матрица:" << endl;
	for (int i = 0; i < n; ++i) {
		for (int j = 0; j < n; ++j)
			cout << setprecision(4) << setw(8) << matr[i][j];
		cout << endl;
	}
	cout << endl;
	cout << "Векторы u:" << endl;
	for (int i = 46; i < 51; ++i) {
		for (int j = 0; j < n; ++j)
			cout << setprecision(4) << setw(8) << u[i][j];
		cout << endl;
	}
	cout << endl;
	cout << "Наибольшие по модулю собственные значения в первом случае:" << endl;
	for (int i = 0; i < 5; ++i) {
		cout << setprecision(4) << setw(8) << lambda1[i];
	}
	cout << endl;
	cout << "Наибольшие по модулю собственные значения во втором случае:" << endl;
	for (int i = 0; i < 5; ++i) {
		cout << setprecision(4) << setw(8) << lambda2[i];
	}
	cout << endl;
	cout << "Вектор «погрешности»  в первом случае:" << endl;
	for (int i = 0; i < n; ++i) {
		cout << setprecision(4) << setw(8) << vector1[i];
	}
	cout << endl;
	cout << "Вектор «погрешности»  во втором случае:" << endl;
	for (int i = 0; i < n; ++i) {
		cout << setprecision(4) << setw(8) << vector2[i];
	}
	cout << endl;
	cout << "Кубическая норма вектора «погрешности»  в первом случае: ";
	cout << max1 << endl;
	cout << "Кубическая норма вектора «погрешности»  во втором случае: ";
	cout << max2 << endl;

	cout << "1) m=30, l1 берется при k=50 по формуле для не обязательно симметричной матрицы:" << endl;
	cout << "l2: " << lambda22[0] << endl;
	cout << "Собственный вектор u:" << endl;
	for (int i = 0; i < n; ++i)
		cout << sobvector2[0][i] << ' ';
	cout << endl;
	cout << "Вектор Au–l2u:" << endl;
	for (int i = 0; i < n; ++i)
		cout << vector22[0][i] << ' ';
	cout << endl;
	cout << "Кубическая норма Au–l2u: " << normi[0] << endl;

	cout << "2) m=50, l1 берется при k=50 по формуле для не обязательно симметричной матрицы:" << endl;
	cout << "l2: " << lambda22[1] << endl;
	cout << "Собственный вектор u:" << endl;
	for (int i = 0; i < n; ++i)
		cout << sobvector2[1][i] << ' ';
	cout << endl;
	cout << "Вектор Au–l2u:" << endl;
	for (int i = 0; i < n; ++i)
		cout << vector22[1][i] << ' ';
	cout << endl;
	cout << "Кубическая норма Au–l2u: " << normi[1] << endl;

	cout << "3) m=50, l1 берется при k=50 по формуле для симметричной матрицы:" << endl;
	cout << "l2: " << lambda22[2] << endl;
	cout << "Собственный вектор u:" << endl;
	for (int i = 0; i < n; ++i)
		cout << sobvector2[2][i]<<' ';
	cout << endl;
	cout << "Вектор Au–l2u:" << endl;
	for (int i = 0; i < n; ++i)
		cout << vector22[2][i] << ' ';
	cout << endl;
	cout << "Кубическая норма Au–l2u: " << normi[2] << endl;
	return 0;
}
