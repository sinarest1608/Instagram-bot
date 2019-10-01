#include <stdio.h>
#include <stdlib.h>
int q[4][4], fr[4][2], size=15;

void insert(int prio, int ele){
  if( (fr[prio][1]+1)%size == (fr[prio][0]) ){
    printf("OVERFLOW!!");
  }
  else if( fr[prio][1]==-1 ){
    fr[prio][0] = fr[prio][1] = 0;
    q[prio][0]  = ele;
  }
  else{
    fr[prio][1] = (fr[prio][1]+1)%size;
    q[prio][ fr[prio][1] ] = ele;
  }
}

void delete(){
  int i;
  for(i=0; i<4; i++){
    if( fr[i][0]!= -1){
      printf("%d\n", q[i][ fr[i][0] ]);
      if( fr[i][0]==fr[i][1] ){
        fr[i][0] = fr[i][1] = -1;
      }
      else{
        fr[i][0] = (fr[i][0]+1)%size;
      }
      break;
    }
  }
  if(i==4){
    printf("UNDERFLOW!!");
  }
}

void display(){
  for (int i=0; i<4; i++) {
    for(int j=0; j<4; j++){
      printf("%d ", q[i][j]);
    }
    printf("\n");
  }
}


void main(){
  int choice;
  do
  {
    printf("1. Insertion\n");
    printf("2. Deletion\n");
    printf("3. Display\n");
    printf("4. Exit\n");

    printf("Enter your choice: ");
    scanf("%d", &choice);
    switch(choice)
    {
      case 1:{
        insert(0, 5);
        insert(1, 1);
        insert(2, 2);
        insert(3, 3);
        insert(4, 4); break;
      }
      case 2:{
        delete(); break;
      }
      case 3:{
        display(); break;
      }
      case 4:{printf("Exiting...\n");
              exit(0);
              }
      default:{printf("ERROR!\n"); }
    }
  }while(choice>0 && choice<5);
}
