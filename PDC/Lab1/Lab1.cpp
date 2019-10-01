#include <omp.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <math.h>
#include <ctime>
#include <fstream>
#include <iostream>

int BLOCK_SIZE[11] = { 2, 5, 10, 20, 25, 50, 100, 125, 250, 500, 750 };

double** create_matrix(int size, bool empty = false)
{
	double** matrix = new double*[size];

	for (int i = 0; i < size; ++i)
	{
		matrix[i] = new double[size];
		for (int j = 0; j < size; ++j)
		{
			if (empty)
				matrix[i][j] = 0;
			else
				matrix[i][j] = rand() & 201 - 101;
		}
	}

	return matrix;
}

void delete_matrix(double** matrix, int size)
{
	for (int i = 0; i < size; ++i)
	{
		delete[] matrix[i];
	}

	delete[] matrix;
}

int linear_multiplication(double** matrix1, double** matrix2, int matrix_size, int parallel_num)
{
	double** res = create_matrix(matrix_size, true);

	int start_time = clock();

#pragma omp parallel for if (parallel_num == 1)
	for (int i = 0; i < matrix_size; ++i)
	{
#pragma omp parallel for if (parallel_num == 2)
		for (int j = 0; j < matrix_size; ++j)
		{
			for (int k = 0; k < matrix_size; ++k)
			{
				res[i][j] += matrix1[i][k] * matrix2[k][j];
			}
		}
	}

	int finish_time = clock();

	delete_matrix(res, matrix_size);

	return finish_time - start_time;
}

int block_multiplication(double** matrix1, double** matrix2, int matrix_size, int block_size, int parallel_num)
{
	if (matrix_size % block_size != 0)
	{
		throw "Block size is not divisible.";
	}

	double** res = create_matrix(matrix_size, true);

	int start_time = clock();

#pragma omp parallel for if (parallel_num == 1)
	for (int i = 0; i < matrix_size; i += block_size)
	{
#pragma omp parallel for if (parallel_num == 2)
		for (int j = 0; j < matrix_size; j += block_size)
		{
			for (int x = 0; x < block_size; ++x)
			{
				for (int y = 0; y < block_size; ++y)
				{
					for (int k = 0; k < matrix_size; ++k)
					{
						res[i + x][j + y] += matrix1[i + x][k] * matrix2[k][j + y];
					}
				}
			}
		}
	}

	int finish_time = clock();

	delete_matrix(res, matrix_size);

	return finish_time - start_time;
}

void test(int matrix_size, std::string file_name)
{
	std::ofstream stream;
	stream.open(file_name);

	stream << "block_size,sequential,first_parallel,second_parallel\n";

	double** matrix1 = create_matrix(matrix_size);
	double** matrix2 = create_matrix(matrix_size);

	int sequential_time =
		linear_multiplication(matrix1, matrix2, matrix_size, 0);
	int first_parallel_time =
		linear_multiplication(matrix1, matrix2, matrix_size, 1);
	int second_parallel_time =
		linear_multiplication(matrix1, matrix2, matrix_size, 2);

	stream << "1," << sequential_time << ","
		<< first_parallel_time << "," << second_parallel_time << std::endl;

	std::cout << "Block size 1 - Done" << std::endl;

	for (int i = 0; i < 11; ++i)
	{
		sequential_time =
			block_multiplication(matrix1, matrix2, matrix_size, BLOCK_SIZE[i], 0);
		first_parallel_time =
			block_multiplication(matrix1, matrix2, matrix_size, BLOCK_SIZE[i], 1);
		second_parallel_time =
			block_multiplication(matrix1, matrix2, matrix_size, BLOCK_SIZE[i], 2);

		stream << BLOCK_SIZE[i] << "," << sequential_time << ","
			<< first_parallel_time << "," << second_parallel_time << std::endl;

		std::cout << "Block size " << BLOCK_SIZE[i] << " - Done" << std::endl;
	}

	stream.close();

	delete_matrix(matrix1, matrix_size);
	delete_matrix(matrix2, matrix_size);
}

int main()
{
	omp_set_dynamic(0);
	omp_set_num_threads(8);

	test(1500, "test_1500.csv");

	system("pause");
	return 0;
}