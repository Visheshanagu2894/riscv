
int main ()
{
     int arr[5];
     arr[0] = 3;
     arr[1] = 5;
     arr[2] = 1;
     arr[3] = 2;
     arr[4] = 4;
 
     int tmp;
 
     for(int i = 0; i < 4; i++){
         for(int j = 0; j < 4 - i; j++){
             if(arr[j] > arr[j + 1]){
                 tmp = arr[j];
                 arr[j] = arr[j + 1];
                 arr[j + 1] = tmp;
             }
         }
     }
     return arr[0];
}