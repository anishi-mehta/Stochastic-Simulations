#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<time.h>
#include<limits.h>
#include<string.h>



#define min(a,b) (((a)>(b))?b:a)
#define max(a,b) (((a)<(b))?b:a)

/* This allows generationg of uniform random variables */
#define U ((long double)rand()/RAND_MAX)


int dot(int *a, int *b, int n);
void print_matrix(int **matrix, int rows, int cols);
void print_vector(int *vector, int n);
double score(int beta, int *x, int *g, int n);
int *propose(int w_max, int *x, int *w, int n,int *x_proposal);
int *mcmc(int iterations, int w_max, int *w, int *g, int n, int beta_start, int beta_increment);
int knapsack_dp(int w_max, int *w, int *g, int n);
  
int main(){
  srand(time(NULL));
  
  int i,n=rand()%100+1;
  int mcmc_runs=1000;
  int iterations=pow(10,2);
  int *w=(int*)malloc(n*sizeof(int));
  int *g=(int*)malloc(n*sizeof(int));
  int w_max;
  int *x=(int*)malloc(n*sizeof(int));
  int *final_x=(int*)malloc(n*sizeof(int));
  int best_haul=-99, haul=0;
  
  double beta_start=0.0005, beta_increment=0.0005;
  

  w_max=(n*n)/10+rand()%(n/2);
  /* scanf("%d", &w_max); */
  for(i=0;i<n;i++){
    w[i]=rand()%(n*5)+1;
    /* scanf("%d ", &w[i]); */
  }

  for(i=0;i<n;i++){
    g[i]=rand()%(n*10)+rand()%n+1;
    /* scanf("%d ", &g[i]); */
  }

  printf("n: %d\nw_max: %d\n", n, w_max);
  printf("W:\n");
  print_vector(w,n);
  printf("G:\n");
  print_vector(g,n);
  printf("\n");
  /* for(i=0;i<n;i++){ */
  /*   printf("w: %d g: %d\n", w[i], g[i]); */
  /* } */
    
  /* goto deterministic; */
  
  for(i=0;i<mcmc_runs;i++){
    x=mcmc(iterations, w_max, w, g, n, beta_start, beta_increment);
    /* print_vector(x,n); */
    haul=dot(x,g,n);
    if(haul>best_haul){
      //final_x=x;
        memcpy(final_x,(const void*)x,sizeof(int)*n);      
      best_haul=haul;
    }
  }

  printf("The final state is:\n");
  print_vector(final_x,n);
  printf("The haul is worth: %d\n\n", best_haul);
 
  int best_haul_det = knapsack_dp(w_max, w, g, n);
  printf("Deterministic: %d\n", best_haul_det);

  printf("Error: %d %\n",(best_haul_det - best_haul)*100/best_haul_det);
  free(g);
  free(w);
  free(x);
  free(final_x);  
  return 0;
}


void print_matrix(int **matrix, int rows, int cols){
  int i,j;
  
  printf("__________________\n");
  for(i=0;i<rows;i++){
    for(j=0;j<cols;j++){
      printf("%d ", matrix[i][j]);
    }
    printf("\n");
  }
  printf("__________________\n");
  return;
}

void print_vector(int *vector, int n){
  int i;

  printf("[");
  for(i=0;i<n;i++)
    printf("%d ", vector[i]);
  printf("]\n");

  return;
}

int dot(int *a, int *b, int n){
  int i;
  int ans=0;
  
  for(i=0;i<n;i++)
    ans+=a[i]*b[i];

  return ans;
}

double score(int beta, int *x, int *g, int n){
  return beta*dot(x,g,n);
}

int *propose(int w_max, int *x, int *w, int n,int *x_proposal){
  int i;
  int random_index=rand()%n;
  /* printf("i:%d\n", random_index); */
  int* proposal=(int*)malloc(n*sizeof(int));

  for(i=0;i<n;i++)      //Can be optimized
    if(i==random_index)
      proposal[i]=!x[i];
    else
      proposal[i]=x[i];

  /* print_vector(proposal,n); */
  if(dot(w,proposal,n)<w_max){
    /* printf("I'm done here.\n"); */
    
    memcpy(x_proposal,(const void*)proposal,sizeof(int)*n);      
    free(proposal);
    return x_proposal;
  }
  else
  {
    free(proposal);
    return propose(w_max,x,w,n,x_proposal);
  }
}

int *mcmc(int iterations, int w_max, int *w, int *g, int n, int beta_start, int beta_increment){
  int i;
  int beta=beta_start;
  int *x_current=(int*)malloc(n*sizeof(int));
  int *x_proposed=(int*)malloc(n*sizeof(int));
  int *x_proposal=(int*)malloc(n*sizeof(int));
  int *x_best=(int*)malloc(n*sizeof(int));
  double best_score=0;
  double current_score=0, proposed_score=0, accept_probability;

  for(i=0;i<n;i++)
      x_current[i]=0;
  for(i=0;i<iterations;i++){
    x_proposed=propose(w_max, x_current, w, n,x_proposal);

    current_score=score(beta,x_current,g,n);
    proposed_score=score(beta,x_proposed,g,n);
    accept_probability=min(1,exp(proposed_score-current_score));

    if(proposed_score>=best_score){
        memcpy(x_best,(const void*)x_proposed,sizeof(int)*n);      
        //memcpy(x_current,(const void*)x_proposed,sizeof(int)*n);      
      //x_best=x_proposed;
      //x_current=x_proposed;
    }

    if(U<=accept_probability){
      //x_current=x_proposed;
        memcpy(x_current,(const void*)x_proposed,sizeof(int)*n);      
    }

    if(i%(iterations/100)==0)
      beta+=beta_increment;
  }

  free(x_current);
  free(x_proposed);
  
  return x_best;
}


int knapsack_dp(int w_max, int *w, int *g, int n){
  /* printf("Hey\n"); */
  int i, j;
  int **knap=(int**)malloc((n+1)*sizeof(int*));
  for(i=0;i<n+1;i++)
    knap[i]=(int*)malloc((w_max+1)*sizeof(int));

  /* print_vector(w, n); */
  /* print_vector(g, n); */
  /* printf("Yeah?\n"); */

  for(j=0;j<=w_max;j++)
    knap[0][j]=0;

  // Build table K[][] in bottom up manner
  for (i =1; i <= n; i++){
    for (j = 0; j <= w_max; j++){
      /* printf("In the bellows: %d %d\n", i, j); */
      if(w[i-1]>j){
	knap[i][j] = knap[i-1][j];
      }
      else{
	knap[i][j] = max(g[i-1] + knap[i-1][j-w[i-1]],  knap[i-1][j]);
      }
    }
  }

  /* printf("Out of my misery\n"); */

  /* print_matrix(knap, n+1, w_max+1); */
  return knap[n][w_max];
}

