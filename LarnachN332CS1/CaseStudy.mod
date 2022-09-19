/*********************************************
 * OPL 20.1.0.0 Model
 * Author: natha
 * Creation Date: 5 May 2021 at 2:51:26 pm
 *********************************************/
 /***************************
 ***** PARAMETERS, SETS *****
 ***************************/

 //******** SETS **********//

// Set of school
{int} Schools = asSet(1..10);
//
 // Set of Floors
{int} Floors = asSet(1..33);

 //*** VECTOR PARAMETERS **//

//Capacity of floor f
int C_f[Floors] = ...;
//Initial space allocations for HDR
int X_0 [Floors] [Schools] = ...; 
// Initial space allocations for AS
int Y_0 [Floors] [Schools] = ...;
//Initial number of HDR spaces
int N_x [Schools] = ...;
//Initial number of AS spaces
int N_y[Schools] = ...;
 

/***************************
 **** DECISION VARIABLES ****
 ***************************/
 
//binary variables indicating the presence of a school s, in floor f.
dvar boolean A [Floors] [Schools];
dvar boolean B [Floors] [Schools];
//RV of the number of relocations of HDR and AS spaces.
dvar int+ X [Floors] [Schools];
dvar int+ Y [Floors] [Schools];
///the optimised faculty layout of the HDR and AS spaces.
dvar int+ X_FL [Floors] [Schools];
dvar int+ Y_FL [Floors] [Schools];




/***************************
 **** OBJECTIVE FUNCTION ****
 ***************************/

// Minimize Relocations
 
 minimize 
 
 sum(f in Floors, s in Schools) X[f][s] + 2* 
 	sum(f in Floors, s in Schools) Y[f][s];

/***************************
 ******** CONSTRAINTS *******
 ***************************/
subject to
{ 
//Building Proximity
//school must be in maximum 2 buildings
//for each school, check if the 2 allocated buidlings match a combination
//  in the proximty table
//


//FloorCapacity: Each floor has limited space, sum over schools and use <= C_f
forall( f in Floors )
sum(s in Schools) (X_FL[f][s] + 2*Y_FL[f][s])
  <= C_f[f];
//NO. of Space: There needs to the same number of initial HDR and AS spaces
HDRspace:
forall (s in Schools)
sum (f in Floors)
X_FL[f][s] == N_x[s];

ASspace:
forall (s in Schools)
sum (f in Floors)
Y_FL[f][s] == N_y[s];

//Objective function: Manipulate the variables s.t. the OF becomes a MINIMIZATION
forall(f in Floors, s in Schools)
X[f][s] >= X_FL[f][s] - X_0[f][s];

forall(f in Floors, s in Schools)
Y[f][s] >= Y_FL[f][s] - Y_0[f][s];
  
//One School per Floor: A school should be contained in a single floor
forall(f in Floors, s in Schools)  
 sum(s in Schools)A[f][s] + sum(s in Schools)B[f][s]  <= 1;
 
//Isolation: Using Big M method, there needs to be at least 4 spaces
// of a faction of a school allocated to a floor
forall(f in Floors, s in Schools )X_FL[f][s] <= 100000*A[f][s];
forall(f in Floors, s in Schools ) 4-X_FL[f][s] <= 100000*(1-A[f][s]);
 
forall(f in Floors, s in Schools ) Y_FL [f][s] <= 100000*B[f][s];
forall(f in Floors, s in Schools)  8-2*Y_FL [f][s] <= 100000*(1-B[f][s]);
 
} 