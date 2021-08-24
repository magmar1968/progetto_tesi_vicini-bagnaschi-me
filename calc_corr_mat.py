#!/usr/lib/ python3


# /home/lorenzomagnoni/local/lib/ 


import sys, os, math
from optparse import OptionParser
import argparse
#import pandas as pd
import numpy as np
from matplotlib import pyplot as plt

def list_mean(mylist):
    _sum = 0
    _n = len(mylist)
    for num in mylist:
        _sum += float(num)
    return float(_sum)/_n

def calc_correlation(list_1, list_2):
    if len(list_1) != len(list_2):
        print( "ERROR: in __FUNC__ lists size must be equal")
        return 
    else:
        _size = len(list_1)
    _mean_1 = list_mean(list_1)
    _mean_2 = list_mean(list_2)

    _res = 0

    for i in range(0, _size):
        _res = float(_res + (list_1[i] - _mean_1)*(list_2[i] - _mean_2))
    return _res/_size

    






def main():

    # parser of command line inputs:
    parser = OptionParser()
    
    parser.add_option("-i","--index",
                      dest = "index",
                      help="\nspecify the data index (default 1)", metavar="INDEX")
    parser.add_option("-p", "--path",
                      dest="path",
                      help="\nspecify the file path location", metavar="PATH")
    
    parser.add_option("-y","--pythia",
                      action="store_true",dest="pythia",default=False,
                      help="select files correct with pythia")
               
    (options, args) = parser.parse_args()

    if options.index is not None:
        index = int(options.index) 
    else:
        index = 1

    if options.path is not None:
        path = str(options.path)
    else :
        path = "./comb_file/"
    
    if options.pythia == True:
        namefile = "lheoutput_py8_histos-comb-W"
    else:
        namefile = "pwgLHEF_analisysis-comb-W"

    ##################################################

    inputfiles=[]
    if len(args) < 2:
        print( "-----------------------------------------------------------")
        print( "please insert the starting and finishing index of comb file")
        print( "USE: python calc_cor_mat.py [-OPTIONS] S_INDEX E_INDEX     ")
        print( "ATTENTION: remeber that *-W1.top is not a weight           ")
        print( "-----------------------------------------------------------")
        return
    else:
        s_index = int(args[0]) 
        e_index = int(args[1])
   
    for i in range(s_index,e_index+1):
        inputfiles.append(namefile+str(i)+ ".top")
    n_file = len(inputfiles)
    print( "----------------------------------")
    print( "Input files are: %s" % inputfiles  )
    print( "N. Input files are: %d" % n_file   )
    print( "----------------------------------")
    
    ifstreams = []
    for filename in inputfiles:
        ifstreams.append(open(os.path.realpath(path + filename), 'r'))

    read = False
    n_line = 400
    line_counter = 0
    bin_mean = []
    values = np.empty((n_line, n_file),order = 'F')
    errors = np.empty((n_file, n_line),order = 'F')
    corr_mat = np.empty((n_line, n_line),order = 'F')


    readall = False
    while not readall:

        parline=[]
        
        for fi in ifstreams: #gen line array
            parline.append(fi.readline())
        #study array
        if parline[0].startswith('#'):
            if int( parline[0].split()[3]) == index:
                read = True
                name = parline[0].split()[1]
                continue
            else:
                read = False
                continue
        
        if parline[0].startswith('\n'): ## blank lines
             continue

        if len(parline[0])==0: ##end of file
            readall=True
            break

        if len(parline[0].split())==4 and read == True:
            parline[0] = parline[0].replace('D','e').replace('E','e')
            a = float( parline[0].split()[0]) ; b = float(parline[0].split()[1])
            bin_mean.append(float((a + b )/2 ))
            for j in range(0,len(parline)):
                parline[j] = parline[j].replace('-.','-0.')
                parline[j] = parline[j].replace('D','e').replace('E','e')
                values[line_counter][j] = (float(parline[j].split()[2]))  
            line_counter += 1
    n_bin = len(bin_mean)
    values.resize((n_bin, n_file))
    for fi in ifstreams:
        fi.close()
    
    print( "values lenght: %d" %len(values[0]))
    print( "bin lenght:    %d" %len(bin_mean))

    # generate a square matrix n_bin x n_bin. Evry cell cointain the 
    #correlation value of two different bin ( iterate over weights )
    for i in range(0,n_bin):
        for j in range(0,n_bin):
            corr_mat[i][j] = calc_correlation( values[i], values[j])


    #===========PLOT===============#
    plt.imshow(corr_mat, cmap='hot', interpolation='nearest')
    plt.show()





if __name__ == "__main__":
    main()
