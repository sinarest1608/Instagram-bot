#include <stdio.h>
#include <stdlib.h>

struct node{
  int data;
  int prio;
  struct node *ptr;
}*start=NULL, *t, *last;

void create(int n){
  int i;
  printf("Enter data...\n");
  for(i=0; i<n; i++){
    t = (struct node *)malloc( sizeof(struct node) );
    scanf("%d %d", &(t->data), &(t->prio));
    t->ptr = NULL;

    if( start==NULL){ start=t; }
    else{ last->ptr = t; }
    last = t;
  }
  printf("Creating...\n");
  printf("DONE!!\n");
}

void insert(int ele, int prio){
  t = (struct node *)malloc(sizeof(struct node));
  if(t==NULL){
    printf("OVERFLOW!!");
  }
  else if(start==NULL||start->prio>prio){
    t->data = ele;
    t->prio = prio;
    t->ptr = start;
    start = t;
  }
  else
{
    struct node *t1;
    struct node *t2;
    t1 = t2 = start;
    for(; t2->prio<=prio &&t2!=NULL; t2=t2->ptr){
      t1 = t2;
    }
    t->ptr = t1->ptr;
    t1->ptr = t;
    t->data = ele;
    t->prio = prio;
  }
}

void delete(){
  struct node *t1;
  if(start == NULL){
    printf("UNDERFLOW!!");
  }
  else if(start->ptr==NULL){
    t1 = start;
    start = NULL;
    free(t1);
  }
  else{
    t1 = start;
    start = (start->ptr)->ptr;
    free(t1);
  }
}

void display(){

  for(t=start; t!=NULL; t=t->ptr){
    printf("->%d ", t->data);
  }
}

void main(){
  int choice;
  do
  {
    printf("1. Creation\n");
    printf("2. Insertion\n");
    printf("3. Deletion\n");
    printf("4. Display\n");
    printf("5. Exit\n");

    printf("Enter your choice: ");
    scanf("%d", &choice);
    switch(choice)
    {
      case 1:{
        create(5); break;
      }
      case 2:
          {
        int e,  p;
        printf("ele: ");
        scanf("%d", &e);
        printf("prio: ");
        scanf("%d", &p);
        insert(e, p);
        break;
      }
      case 3:{
        delete(); break;
      }
      case 4:{
        display(); break;
      }
      case 5:{printf("Exiting...\n");
            exit(0);
              }
      default:{printf("ERROR!\n");}
    }
  }while(choice>0 && choice<5);
}
