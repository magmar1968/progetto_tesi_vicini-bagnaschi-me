#include<stdlib.h>
#include<fstream>
#include<time.h>


int main(int argc, char ** argv)
{
	int N_seeds = 100;
	std::ofstream outf;
	if (argc > 1){
		N_seeds = atoi(argv[1]);
	}
	outf.open("pwgseeds.dat", std::ofstream::out);
	srand(time(NULL));
	int seed_cont = 0;
	while(seed_cont < N_seeds and outf.good())
	{
		outf << rand() << std::endl;
		seed_cont++;
	}

	outf.close();
	return 0;
}
		

