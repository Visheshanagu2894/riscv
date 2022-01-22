
#include <corelib.h>
#include <stdio.h>

int binarySearch(int arr[], int l, int r, int x) 
{ 
    if (r >= l) { 
        int mid = l + (r - l) / 2; 
  
        // If the element is present at the middle 
        // itself 
        if (arr[mid] == x) 
            return mid; 
  
        // If element is smaller than mid, then 
        // it can only be present in left subarray 
        if (arr[mid] > x) 
            return binarySearch(arr, l, mid - 1, x); 
  
        // Else the element can only be present 
        // in right subarray 
        return binarySearch(arr, mid + 1, r, x); 
    } 
  
    // We reach here when element is not 
    // present in array 
    return -1; 
} 
  
int main() 
{ 
    int arr[] = { 2, 3, 4, 10, 40,1,5,9,-1131,-31241,-4141,14115,-1511,14151,-255,5536,53 }; 


    int tmp;
    int n = sizeof(arr) / sizeof(arr[0]); 

     for(int i = 0; i < n-1; i++){
         for(int j = 0; j < n-1 - i; j++){
             if(arr[j] > arr[j + 1]){
                 tmp = arr[j];
                 arr[j] = arr[j + 1];
                 arr[j + 1] = tmp;
             }
         }
     }
   int x = -255; 
   int result = binarySearch(arr, 0, n - 1, x); 
    
    return result; 
}