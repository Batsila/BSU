#include <iostream>
#include <mpi.h>
#include <iomanip>
#include <fstream>
#include <algorithm>

using namespace std;

const int n = 2000;
double matrix[n * n];
double f[n];
double x[n];

int main(int argc, char** argv) 
{
	int control_time, total_time;
	MPI_Status status;
	int rank, rank_size;
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &rank_size);

	// init (main thread)
	if (rank == 0) 
	{
		control_time = clock();
		total_time = clock();

		// init x
		for (int i = 0; i < n; ++i) 
		{
			x[i] = 42;
		}

		// init matrix
		for (int i = 0; i < n; ++i) 
		{
			f[i] = 0;
			for (int j = 0; j < n; ++j) 
			{
				if (i == j)
				{
					matrix[i * n + j] = 100;
				}
				else
				{
					matrix[i * n + j] = (2 * i + j) / 100000.0;
				}
				f[i] += matrix[i * n + j] * x[j];
			}
		}

		cout << "Init time: " << clock() - control_time << " ms" << endl;
		control_time = clock();
	}

	int rows_count = ceil(double(n) / rank_size);
	double* rows = new double[rows_count * (n + 1)];
	double* row = new double[n + 1];

	for (int i = rows_count * rank; i < n; ++i)
	{
		if (rank == 0) 
		{
			for (int j = 0; j < n; ++j)
			{
				row[j] = matrix[i * n + j];
			}
			row[n] = f[i];
		}
		else 
		{
			MPI_Recv(
				row,
				n + 1,
				MPI_DOUBLE,
				rank - 1,
				99,
				MPI_COMM_WORLD,
				&status);
		}

		int cycle_min = min(i - rows_count * rank, rows_count);

		for (int k = 0; k < cycle_min; ++k) 
		{
			double temp = row[rows_count * rank + k];

			for (int j = rows_count * rank + k; j < n + 1; ++j)
			{
				row[j] -= temp * rows[k * (n + 1) + j]
					/ rows[k * (n + 1) + rows_count * rank + k];
			}
		}
		if (i - rows_count * rank < rows_count)
		{
			for (int j = 0; j < n + 1; ++j) 
			{
				rows[(i - rows_count * rank) * (n + 1) + j] = row[j];
			}
		}
		else 
		{
			MPI_Send(row, n + 1, MPI_DOUBLE, rank + 1, 99, MPI_COMM_WORLD);
		}
	}

	MPI_Barrier(MPI_COMM_WORLD);

	if (rank == 0) 
	{
		cout << "Calculation time: " << clock() - control_time << " ms" << endl;
		control_time = clock();

		double* matrix_gauss = new double[n * (n + 1)];

		for (int i = 0; i < rows_count * (n + 1); ++i)
		{
			matrix_gauss[i] = rows[i];
		}

		for (int i = 1; i < rank_size - 1; ++i) 
		{
			MPI_Recv(
				matrix_gauss + rows_count * i * (n + 1),
				rows_count * (n + 1),
				MPI_DOUBLE,
				i,
				100,
				MPI_COMM_WORLD,
				&status);
		}

		if (rank_size != 1) 
		{
			int last_max = n - rows_count * (rank_size - 1);

			MPI_Recv(
				matrix_gauss + rows_count * (rank_size - 1) * (n + 1),
				last_max * (n + 1),
				MPI_DOUBLE,
				rank_size - 1,
				100,
				MPI_COMM_WORLD,
				&status);
		}

		// reverse
		double* result = new double[n];

		for (int i = n - 1; i >= 0; --i) 
		{
			result[i] = matrix_gauss[(i + 1) * (n + 1) - 1];

			for (int j = n - 1; j >= i + 1; --j) 
			{
				result[i] -= matrix_gauss[i * (n + 1) + j] * result[j];
			}
			result[i] /= matrix_gauss[i * (n + 1) + i];
		}

		/*cout << "Result: " << endl;
		for (int i = 0; i < n; ++i) 
		{
			cout << setprecision(4) << fixed << result[i] << " ";
		}
		cout << endl;*/

		cout << "Reverse time: " << clock() - control_time << " ms" << endl;
		cout << "Total time: " << clock() - total_time << " ms" << endl;
	}
	else 
	{
		if (rank != rank_size - 1) 
		{
			MPI_Send(
				rows, 
				rows_count * (n + 1),
				MPI_DOUBLE,
				0,
				100,
				MPI_COMM_WORLD);
		}
		else 
		{
			int last_max = n - rows_count * (rank_size - 1);

			MPI_Send(
				rows, 
				last_max * (n + 1),
				MPI_DOUBLE,
				0,
				100,
				MPI_COMM_WORLD);
		}
	}

	MPI_Finalize();
	return 0;
}