
#include <stdio.h>     /* для printf */
#include <stdlib.h>    /* для exit */
#include <getopt.h>



int
sub_getopt (int argc, char **argv) {
    int c;
    int digit_optind = 0;

    while (1) {
        int this_option_optind = optind ? optind : 1;
        int option_index = 0;
        static struct option long_options[] = {
            {"run", 1, 0, 'r'},
            {"frames", 1, 0, 'f'},
			{"gtu1us", 1, 0, 'g'},
            {"testmode", 1, 0, 't'},
            {"status", 0, 0, 's'},
            {"write", 1, 0, 0},
	        {"read", 1, 0, 0},
	        {"value", 1, 0, '?'},

            {0, 0, 0, 0}
        };

        c = getopt_long (argc, argv, "r:f:g:t:s:",
                 long_options, &option_index);
        if (c == -1)
            break;

        switch (c) {
        case 0:
            printf ("параметр %s", long_options[option_index].name);
            if (optarg)
                printf (" с аргументом %s", optarg);
            printf ("\n");
            break;

//        case '0':
//        case '1':
//        case '2':
//            if (digit_optind != 0 && digit_optind != this_option_optind)
//              printf ("цифры используются в двух разных элементах argv.\n");
//            digit_optind = this_option_optind;
//            printf ("параметр  %c\n", c);
//            break;

        case 'r':
            printf ("Parameter run (r) `%s'\n", optarg);
            break;

        case 'f':
            printf ("Parameter frames (f): `%s'\n", optarg);
            break;

        case 'g':
            printf ("Parameter gtu1us (g) `%s'\n", optarg);
            break;

        case 't':
            printf ("Parameter testmode (t): `%s'\n", optarg);
            break;

        case 's':
             printf ("Parameter status (s): `%s'\n", optarg);
             break;

        case '?':
            break;

        default:
            //printf ("?? getopt возвратило код символа 0%o ??\n", c);
        	printf ("?? getopt returned the char: 0%o ??\n", c);
        }
    }

    if (optind < argc) {
        //printf ("элементы ARGV, не параметры: ");
    	printf ("No such params: ");
        while (optind < argc)
            printf ("%s ", argv[optind++]);
        printf ("\n");
    }

    exit (0);
}

int main(int argc, char **argv)
{
	sub_getopt(argc, argv);
}

