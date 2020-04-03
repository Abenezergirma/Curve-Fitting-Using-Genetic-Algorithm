%%%%% Abenezer Taye %%%%%%%%%%%%%%
%%%%% Curve fitting with tournament selection %%%%%
%%%%% North Carolina A&T State University %%%%%%
%%%%% Date: April 2, 2020 %%%%%%%%%%%%%%


clear all;
clc;

x=[0:1:100]';
y=4*exp(-x) +6*x.^3 + 2*x;

y = awgn(y,0.01); % 0.01 is the SNR 

Error =zeros(1,20);
% A simple GA with a small population
nvar = 3;
Popsize = ones(1,nvar)*20; % Population size

SL = ones(1,nvar)*10;   % String Length


Pc = ones(1,nvar)*0.6; % Probability of cross-over

Pm = ones(1,nvar)*0.01; % Probability of mutation

GenNo = ones(1,nvar)*10000; % Number of Generations

MAs = ones(1,nvar)*10; % Moving Average steps

torn_size = ones(1,nvar)*5; % Set the torn size as odd number

%%
% For roulette wheel selection
X1 = zeros(Popsize(1,1),GenNo(1,1));
X2 = zeros(Popsize(1,2),GenNo(1,2));
X3 = zeros(Popsize(1,3),GenNo(1,3));

fitness = zeros(Popsize(1,1),GenNo(1,1));

pop1 = Pop_InISimple(Popsize(1,1), SL(1,1));
pop2 = Pop_InISimple(Popsize(1,2), SL(1,2));
pop3 = Pop_InISimple(Popsize(1,3), SL(1,3));

%%

for i =1:GenNo(1,1)
    
    X1(:,i) = ConvertBin2Dec(pop1,Popsize(1,1),SL(1,1));
    X2(:,i) = ConvertBin2Dec(pop2,Popsize(1,2),SL(1,2));
    X3(:,i) = ConvertBin2Dec(pop2,Popsize(1,3),SL(1,3));
    
    Ymin = ones(1,nvar)* -10;
    Ymax =ones(1,nvar)* 10;
    
    NewX1 = Mapping(X1(:,i),Ymin(1,1),Ymax(1,1),SL(1,1));
    NewX2 = Mapping(X2(:,i),Ymin(1,2),Ymax(1,2),SL(1,2));
    NewX3 = Mapping(X3(:,i),Ymin(1,3),Ymax(1,3),SL(1,3));
    


    y_actual = y;

    y_calc=NewX1'.*exp(-x) + NewX2'.*x.^3 + NewX3'.*x;
    err = y_actual - y_calc;
    Error = sum(sqrt(err.^2));
    

    fitness(:,i) = 1./Error;
    
    Parents1 = tournament_selection(pop1,fitness(:,i),Popsize(1,1),torn_size(1,1)); 
    Parents2 = tournament_selection(pop2,fitness(:,i),Popsize(1,2),torn_size(1,2));
    Parents3 = tournament_selection(pop3,fitness(:,i),Popsize(1,3),torn_size(1,3)); 
    
    [popCross1] = simple_crossover(Parents1,SL(1,1),Popsize(1,1),Pc(1,1));
    [popCross2] = simple_crossover(Parents2,SL(1,2),Popsize(1,2),Pc(1,2));
    [popCross3] = simple_crossover(Parents2,SL(1,3),Popsize(1,3),Pc(1,3));
    
    [mutant1] = mutation(popCross1,Popsize(1,1),SL(1,1),Pm(1,1));
    [mutant2] = mutation(popCross2,Popsize(1,2),SL(1,2),Pm(1,2));
    [mutant3] = mutation(popCross3,Popsize(1,3),SL(1,3),Pm(1,3));
    
    pop1 = mutant1;
    pop2 = mutant2;
    pop3 = mutant3;
    

end

fitness_torn = fitness; 
%Mapping back to the given ranges
Ymin = ones(1,3)* -10;
Ymax =ones(1,3)* 10;
Mapped_X1 = Mapping(X1(:,end),Ymin(1,1),Ymax(1,1),SL(1,1));
Mapped_X2 = Mapping(X2(:,end),Ymin(1,2),Ymax(1,2),SL(1,2));
Mapped_X3 = Mapping(X3(:,end),Ymin(1,3),Ymax(1,3),SL(1,3));

final_X1 = mean(Mapped_X1);
final_X2 = mean(Mapped_X2);
final_X3 = mean(Mapped_X3);
%%
x=[0:1:100]';
y1=4*exp(-x) +6*x.^3 + 2*x;
y2=final_X1*exp(-x) +final_X2*x.^3 + final_X3*x;

%y2 = 3.3294*exp(-x) + 6.0001*x.^3 + 6.0001;
%y2 = 3.7439*exp(-x) + 5.4917*x.^3 + 5.4917*x;
%y2 = 3.6500*exp(-x) + 5.9599*x.^3 + 5.9599*x;

plot(x,y1,'LineWidth',1.2)
hold on 
plot(x,y2,'LineWidth',1.2)
legend('Y Original','Y GA')
title('GA Implementation of Curve fitting (trail 10)')

