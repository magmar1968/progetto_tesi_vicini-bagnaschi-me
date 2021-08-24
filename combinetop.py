#! /usr/bin/env python


import sys, os, math
from optparse import OptionParser
from os.path import basename, splitext


def quadsum(mylist):
    result=0
    for i in range(0,len(mylist)):
        result=result+mylist[i]*mylist[i]
    
    return math.sqrt(result)

def scient(number):
    a = '%.8e' % number
    return a


if __name__=='__main__':
    
    # parser of command line inputs:
    parser = OptionParser()
    
    parser.add_option("-o", "--output", dest="outfilename",
                      help="name of output file", metavar="OUTFILE")
    parser.add_option("-v", "--verbosity", dest="verbosity",
                      help="sets verbosity of output", metavar="VERBOS")
    
    # verbosity ...
    (options, args) = parser.parse_args()
    
    if options.verbosity is not None:
        verb = int(options.verbosity)
    else:
        verb = 0

    #####################################################

    print "----------------------------------"
    print "Input files are: %s" % args
    print "N. Input files are: %d" % len(args)
    print "----------------------------------"

    outputfile = open(options.outfilename, 'w')

    inputfiles=[]

    for filename in args:
        inputfiles.append(open(os.path.realpath(filename), 'r'))

    readall=False

    while not readall:

        parline=[]

        for i,file in enumerate(inputfiles):
            parline.append(file.readline())

        if len(parline[0])==0:
            readall=True
            break

        if parline[0].startswith('#'):
            outputfile.write(parline[0].strip()+'\n')
	    continue

        if parline[0].startswith('\n'):
            outputfile.write('\n')
	    continue

        if len(parline[0].split())==4:
        
            x_l=[]
            x_h=[]
            val=[]
            err=[]
        
            for i in range(0,len(parline)):
                parline[i] = parline[i].replace('D','e').replace('E','e')  
                x_l.append(float(parline[i].split()[0]))
                x_h.append(float(parline[i].split()[1]))
                val.append(float(parline[i].split()[2]))
                err.append(float(parline[i].split()[3]))


            if len(set(x_l))>1:
                print 'Histogram binning is not the same'
            if len(set(x_h))>1:
                print 'Histogram binning is not the same'
       
            totval=sum(val)/len(parline)
            toterr=quadsum(err)/len(parline)

            #print x_l[0], x_h[0], totval, toterr
            #print parline[0], parline[1]
#            outputfile.write(scient(x_l[0]).ljust(5) +'\t'+scient(x_h[0]).ljust(5) +'\t#'+
#                             scient(totval).ljust(10)+'\t'+scient(toterr).ljust(10)+'\n')
            outputfile.write(scient(x_l[0]).ljust(5) +' '+scient(x_h[0]).ljust(5) +' '+
                             scient(totval).ljust(10)+' '+scient(toterr).ljust(10)+'\n')
    for files in inputfiles:
        files.close()

    outputfile.close()
