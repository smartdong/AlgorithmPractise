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

//找到一个单向链表中，距离最后一个元素为`k`的那个元素。例如给定一个链表`1->2->3->4`，并且`k`等于`2`，那么该函数应该返回`2`
ListNode *findkthToLastNode(ListNode *head, int k) {
	if ((head->next == NULL) || (k < 0)) {
		return NULL;
	}
	
	ListNode *runner = head->next;
	ListNode *chaser = head->next;
	
	for (int i = 0; i < k; i++) {
		if (runner->next) {
			runner = runner->next;
		} else {
			return NULL;
		}
	}
	
	while (runner->next) {
		runner = runner->next;
		chaser = chaser->next;
	}
	
	return chaser;
}

int main(int argc, char *argv[]) {
	
	int a[] = {1,2,3,4,5,6,7,8,9};
	
	ListNode *list = newNode();
	
	for (int i = 0;i < 9;i++) {
		addNode(list, a[i]);
	}
	
	printf("list : ");
	printList(list);
	
	int k = 3;
	ListNode *kthNode = findkthToLastNode(list,k);
	
	if (kthNode) {
		printf("\n%dthNode : %d",k,kthNode->data);
	} else {
		printf("\nSEGMENTATION FAULT");
	}
}
