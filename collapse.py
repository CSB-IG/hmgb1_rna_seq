import numpy
import pprint

f = open("../ine_no0.txt")
lineas = f.readlines()
f.close()

ens = {}
for l in lineas[1:]:
    (ID, c1, c2, c3, h1, h2, h3) = l.split()
    eid = ID.split('.')[0]
    ens[eid] = [int(n) for n in[c1, c2, c3, h1, h2, h3]]

f = open("../FullBiomart.txt")
lineas = f.readlines()
f.close()


gs = {}

for l in lineas[1:]:
    ensembl_gene_id, chromosome_name, gene_start, gene_end, gc_content, gene_type, associated_gene_name, length = l.split()
    try:
        if associated_gene_name in gs:
            gs[associated_gene_name].append(ens[ensembl_gene_id])
        else:
            gs[associated_gene_name] = [ens[ensembl_gene_id],]
    except KeyError:
        pass



print "GS C1 C2 C3 H1 H2 H3"
for g in gs:

    l = []
    a = numpy.array(gs[g])
    for i in a.transpose():
        l.append(numpy.median(i))
    print g," ".join(["%i" % j for j in l])


        

