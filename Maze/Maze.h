#include <stdio.h>
#include <string.h>
#include "utils.h"
#define clear() printf("\033[H\033[J")
#define gotoxy(x,y) printf("\033[%d;%dH", (y), (x))
#define printTitle printfile("Title.txt")
char border = '#',player = '@',input = 0,mode = 1;
int option = 1,arr[50][85],v = 0,h = 0,x,y,goal_x,goal_y,toggle = 0,mark = 0;

void printfile(char str[]);
void getinput();
void title_screen();
void customize();
void print_map();
void insertMap(char str[]);
void play();
void move();
void The_Maze();
void choose_mode();
void move_up();
void move_down();
void move_left();
void move_right();
void cheat();

//-------------------------------------------

void title_screen()
{
    clear();
    printTitle;
    if (option == 1)
    {
        printf("  -> 1.Play\n     2.Customize\n     3.Exit\nPress arrow key to select.\nPress Space to confirm.");
    }
    else if (option == 2)
    {
        printf("     1.Play\n  -> 2.Customize\n     3.Exit\nPress arrow key to select.\nPress Space to confirm.");
    }
    else if (option == 3)
    {
        printf("     1.Play\n     2.Customize\n  -> 3.Exit\nPress arrow key to select.\nPress Space to confirm.");
    }
    getinput(); 
    if (input == 1)
    {
        if (option  > 1) option--;
        title_screen();
    }
    else if (input == 2)
    {
        if (option < 3) option++;
        title_screen();
    }
    else if (input == ' ' && option == 1)
    {
        play(); 
    }
    else if (input == ' ' && option == 2)
    {
        option = 1;
        customize();
    }
    else if (input == ' ' && option == 3) {}
    else title_screen();
}

void customize()
{
    clear();
    printTitle;
    if (option == 1)
    {
        printf("  -> 1.Border: %c\n     2.Player: %c\n     3.Return\nPress arrow key to select.\nPress Space to confirm.",border,player);
    }
    else if (option == 2)
    {
        printf("     1.Border: %c\n ->  2.Player: %c\n     3.Return\nPress arrow key to select.\nPress Space to confirm.",border,player);
    }
    else if (option == 3)
    {
        printf("     1.Border: %c\n     2.Player: %c\n ->  3.Return\nPress arrow key to select.\nPress Space to confirm.",border,player);
    }
    getinput(); 
    if (input == 1)
    {
        if (option  > 1) option--;
        customize();
    }
    else if (input == 2)
    {
        if (option < 3) option++;
        customize();
    }
    else if (input == ' ' && option == 1)
    {
        clear();
        printTitle;
        printf("  -> 1.New border: \n     2.Player: %c\n     3.Return\nPress arrow key to select.\nPress Space to confirm.",player);
        getinput();
        border = input;
        customize();
    }
    else if (input == ' ' && option == 2)
    {
        clear();
        printTitle;
        printf("     1.Border: %c\n ->  2.New player: \n     3.Return\nPress arrow key to select.\nPress Space to confirm.",border);
        getinput();
        player = input;
        customize();
    }
    else if (input == ' ' && option == 3)
    {
        option = 1;
        title_screen();
    }
    else  customize();

}

void play()
{
    clear();
    printTitle;
    if (option == 1)
    {
        printf("  -> 1.Escape The Maze\n     2.Mode\n     3.Return\nPress arrow key to select.\nPress Space to confirm.");
    }
    else if (option == 2)
    {
        printf("     1.Escape The Maze\n  -> 2.Mode\n     3.Return\nPress arrow key to select.\nPress Space to confirm.");
    }
    else if (option == 3)
    {
        printf("     1.Escape The Maze\n     2.Mode\n  -> 3.Return\nPress arrow key to select.\nPress Space to confirm.");
    }
    getinput(); 
    if (input == 1)
    {
        if (option  > 1) option--;
        play();
    }
    else if (input == 2)
    {
        if (option < 3) option++;
        play();
    }
    else if (input == ' ' && option == 1)
    {
        The_Maze();        
    }
    else if (input == ' ' && option == 2)
    {
        option = 1;
        choose_mode();
    }
    else if (input == ' ' && option == 3)
    {
        option = 1;
        title_screen();
    }
    else play();
}

void choose_mode()
{
    clear();
    printTitle;
    char temp[7];
    if (mode == 1) strcpy(temp,"Easy");
    else if (mode == 2) strcpy(temp,"Normal");
    else strcpy(temp,"Hard");
    if (option == 1)
    {
        printf("Current mode: %s \n  -> 1.Easy\n     2.Normal\n     3.Hard\n     4.Return\nPress arrow key to select.\nPress Space to confirm.",temp);
    }
    else if (option == 2)
    {
        printf("Current mode: %s \n     1.Easy\n  -> 2.Normal\n     3.Hard\n     4.Return\nPress arrow key to select.\nPress Space to confirm.",temp);
    }
    else if (option == 3)
    {
        printf("Current mode: %s \n     1.Easy\n     2.Normal\n  -> 3.Hard\n     4.Return\nPress arrow key to select.\nPress Space to confirm.",temp);
    }
    else if (option == 4)
    {
        printf("Current mode: %s \n     1.Easy\n     2.Normal\n     3.Hard\n  -> 4.Return\nPress arrow key to select.\nPress Space to confirm.",temp);
    }
    getinput(); 
    if (input == 1)
    {
        if (option  > 1) option--;
        choose_mode();
    }
    else if (input == 2)
    {
        if (option < 4) option++;
        choose_mode();
    }
    else if (input == ' ' && option == 1)
    {
        mode = 1;
        choose_mode();
    }
    else if (input == ' ' && option == 2)
    {
        mode = 2;
        choose_mode();
    }
    else if (input == ' ' && option == 3)
    {
        mode = 3;
        choose_mode();
    }
    else if (input == ' ' && option == 4)
    {
        option = 1;
        play();
    }
    else choose_mode();
}

void The_Maze()
{
    clear();
    printTitle;
    if (mode == 1) insertMap("map_1.txt");
    else if (mode == 2) insertMap("map_2.txt");
    else insertMap("map_3.txt");
    while (input != '~' && !(x == goal_x && y == goal_y))
    {
        move();
    }
    clear();
    printfile("congrat.txt");
    getinput();
    title_screen();
}

void printfile(char str[])
{
    FILE *f;
    f = fopen(str,"r");
    char ch;
    while ((ch = fgetc(f)) != EOF)
    {
       printf("%c",ch); 
    }
    fclose(f);
}

void getinput()
{
    input = getch();
    if (input == 27)
    {
        getch();
        input = getch() - 64;   
    }
}

void insertMap(char str[])
{
    FILE *f = fopen(str,"r");
    char ch;
    int temp;
    while ((ch = fgetc(f)) != EOF)
    {
        if (ch == '\n')
        {
            temp = h;
            h = 0;
            v++;
        }
        else if (ch == '0') arr[v][h] = 0;
        else if (ch == '1') arr[v][h] = 1;
        else if (ch == '2') arr[v][h] = 2;
        else if (ch == '3') 
        {
            arr[v][h] = 3;
            goal_x = v;
            goal_y = h;
        }
        h++;
    }
    h = temp;
    fclose(f);
}

void print_map()
{
    clear();
    printTitle;
    printf("  ");
    for (int i = 0;i <= v;i++)
    {
        for (int j = 0;j <= h;j++)
        {
            if (arr[i][j] == 1) printf("%c ",border);
            else if (arr[i][j] == 2)
            {
                printf("%c ",player);
                x = i;
                y = j;
            }
            else if (arr[i][j] == 4) printf("%c ",'x');
            else printf("  ");
        }
        printf("\n");
    }
    printf("Press arrow keys to move\n");
    printf("Press M to mark\n");
    printf("Press ~ to quit");
}

void move_up()
{
    if (arr[x - 1][y] != 1)
    {
        arr[x - 1][y] = 2;
        arr[x][y] = mark;
        x--;
    }
}

void move_down()
{
    if (arr[x + 1][y] != 1)
    {
        arr[x + 1][y] = 2;
        arr[x][y] = mark;
        x++;
    }
}

void move_left()
{
    if (arr[x][y + 1] != 1)
    {
        arr[x][y + 1] = 2;
        arr[x][y] = mark;
        y++;
    }
}

void move_right()
{
    if (arr[x][y - 1] != 1)
    {
        arr[x][y - 1] = 2;
        arr[x][y] = mark;
        y--;
    }
}

void move()
{
    clear();
    printTitle;
    print_map();
    getinput();
    if (input == 'M') toggle = (toggle + 1)%2;
    if (toggle) mark = 4;
    else mark = 0;
    if (input == 1 && arr[x - 1][y] != 1)
    {
        move_up();
    }
    else if (input == 2)
    {
        move_down();
    }
    else if (input == 3)
    {
        move_left();
    }
    else if (input == 4)
    {
        move_right(); 
    }
    else if (input == '1') cheat();
}
