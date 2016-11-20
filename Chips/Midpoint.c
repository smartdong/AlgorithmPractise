#include <stdio.h>
#include <stdlib.h>

typedef struct listNode {
	int data;
	struct listNode *next;
} ListNode;

ListNode *newNode() {
	ListNode *node = (ListNode *)malloc(sizeof(ListNode));
	node->next = NULL;
	return node;
}

void addNode(ListNode *head, int data) {
	while (head->next) {
		head = head->next;
	}
	
	ListNode *node = newNode();
	node->data = data;
	head->next = node;
}

void printList(ListNode *head) {
	head = head->next;
	while (head) {
		printf("%d ",head->data);
		head = head->next;
	}
}

//给定一个链表，编写一个函数以返回该链表的中间点
ListNode *midpoint(ListNode *head) {
	if (head->next == NULL) {
		return NULL;
	}
	
	ListNode *runner = head->next;
	ListNode *chaser = head->next;
	
	while (runner->next && runner->next->next) {
		chaser = chaser->next;
		runner = runner->next->next;
	}
	
	return chaser;
}

int main(int argc, char *argv[]) {
	
	int a[] = {8,2,5,4,1,3,6,7,9};
	
	ListNode *list = newNode();
	
	for (int i = 0;i < 9;i++) {
		addNode(list, a[i]);
	}
	
	printf("list : ");
	printList(list);
	
	ListNode *mpoint = midpoint(list);
	printf("\nmidpoint : %d",mpoint->data);
}
