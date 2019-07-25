options ls=70;

data fev;
infile 'C:\Users\feizou\Desktop\Teaching\Bios663-2019\lectureNotes\FEV2.dat' Firstobs=2;
input center $ fev;
run;

proc print;

data fev2;
set fev;
if center="hopkins" then h_ind=1; else h_ind=0;
if center="ranchola" then r_ind=1; else r_ind=0;
if center="stlouis" then s_ind=1; else s_ind=0;
run;

proc glm data=fev2;
model fev=h_ind r_ind s_ind/noint;
contrast 'Usual Overall Test' h_ind 1 r_ind -1 s_ind  0,
                              h_ind 1 r_ind 0  s_ind -1;
run;

proc glm data=fev2;
class center;
model fev=center/noint;
lsmeans center/ pdiff adjust=scheffe;
run;

proc glm data=fev2;
class center;
model fev=center/noint;
means center/hovtest=bf welch;
run;

proc glm data=fev2;
class center;
model fev=center/noint;
means center/hovtest=obrien welch;
run;
