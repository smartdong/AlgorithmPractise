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

//给定一个链表和一个值`x`，编写一个函数，对该链表重新排序，以便所有小于`x`的节点都出现在大于或等于`x`的节点的前面
void reorderList(ListNode *head, int x) {
	
	ListNode *originHead = head;
	
	ListNode *lessList = newNode();
	ListNode *lessNode = lessList;
	ListNode *moreList = newNode();
	ListNode *moreNode = moreList;
	
	ListNode *next = head->next;
	while (next) {
		if (next->data < x) {
			lessNode->next = next;
			lessNode = next;
		} else {
			moreNode->next = next;
			moreNode = next;
		}
		next = next->next;
	}
	
	lessNode->next = moreList->next;
	originHead->next = lessList->next;
	
//	delete lessList;
//	delete moreList;
}

int main(int argc, char *argv[]) {
	
	int a[] = {8,2,5,4,1,3,6,7};
	
	ListNode *list = newNode();
	
	for (int i = 0;i < 8;i++) {
		addNode(list, a[i]);
	}
	
	printf("Before : ");
	printList(list);
	
	reorderList(list,5);
	
	printf("\nAfter  : ");
	printList(list);
}
