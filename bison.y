%{

    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    //flag if there is progress attribute
    int progressBarCheck;

    //flag if there is checkedButton attribute
    int checkedButtonCheck;

    //flag counts buttons 
    int buttonsCount = 0;
    int buttonsCheck;
    char* buttonsCheckString;
    int progressCheck;
    char* progressCheckString;
    int maxCheck = -1;
    char* maxCheckString;

    //up to 50 ids
    char idStringTable[50][20]; 
    int tableCounter = 0;
    char* idString;

    //up to 50 button ids
    char buttonidStringTable[50][20];
    char* checkedButton;

    extern FILE *yyin;
    extern int yylex(); 
    extern void yyerror(const char* err);

    int StrToInt(char* Tempstring);
    int hasDuplicateStrings(char strings[][20], int size);
    int matchesButtonId(char strings[][20],char* tempid, int size);

%}  

%define parse.error verbose

%union {
    char* strval;
}

%token                      T_TAG_START_RELATIVE         "Start of RelativeLayout Element"
%token                      T_TAG_START_LINEAR           "Start of LinearLayout Element"
%token                      T_TAG_START_TEXT             "Start of TextView Element"
%token                      T_TAG_START_IMAGE            "Start of ImageView Element"
%token                      T_TAG_START_BUTTON           "Start of Button Element"
%token                      T_TAG_START_RADIOG           "Start of RadioGroup Element"
%token                      T_TAG_START_RADIOB           "Start of RadioButton Element"
%token                      T_TAG_START_PROGRESS         "Start of ProgressBar Element"
%token                      T_TAG_CLOSE_RELATIVE         "End of RelativeLayout Element"
%token                      T_TAG_CLOSE_LINEAR           "End of LinearLayout Element"
%token                      T_TAG_CLOSE_RADIOG           "End of RadioGroup Element"
%token                      T_ATTRIBUTE_WIDTH            "Width Attribute"
%token                      T_ATTRIBUTE_HEIGHT           "Height Attribute"
%token                      T_ATTRIBUTE_ID               "ID Attribute"
%token                      T_ATTRIBUTE_ORIENTATION      "Orientation Attribute"
%token                      T_ATTRIBUTE_TEXT             "Text Attribute"
%token                      T_ATTRIBUTE_TEXTCOLOR        "TextColor Attribute"
%token                      T_ATTRIBUTE_SRC              "SRC Attribute"
%token                      T_ATTRIBUTE_PADDING          "Padding Attribute"
%token                      T_ATTRIBUTE_CHECKEDBUTTON    "CheckedButton Attribute"
%token                      T_ATTRIBUTE_MAX              "Max Attribute"
%token                      T_ATTRIBUTE_PROGRESS         "Progress Attribute"
%token                      T_ATTRIBUTE_BUTTONS_NUM      "Number of buttons"
%token      <strval>        T_ALPHANUM                   "Alphanum"
%token                      T_WH_VALUE                   "wrap_content or match_parent"
%token      <strval>        T_NUM                        "Num"
%token                      T_SELF_CLOSING               "Self Closing Tag"
%token                      T_TAG_END                    "End Tag"

%%

xml :                               RelativeLayout 
                                    {
                                         if(hasDuplicateStrings(idStringTable, tableCounter) == 1){
                                            yyerror("Duplicate Ids found!");
                                        }      
                                    }
                                    | LinearLayout
                                    {                                  
                                        if(hasDuplicateStrings(idStringTable, tableCounter) == 1){
                                            yyerror("Duplicate Ids found!");
                                        }                                        
                                    }
RelativeLayout :                    T_TAG_START_RELATIVE widgth-height id T_TAG_END elements T_TAG_CLOSE_RELATIVE 
                                    | T_TAG_START_RELATIVE widgth-height id T_TAG_END T_TAG_CLOSE_RELATIVE                               
                                    | T_TAG_START_RELATIVE widgth-height id T_SELF_CLOSING 
LinearLayout :                      T_TAG_START_LINEAR widgth-height id orientation T_TAG_END elements T_TAG_CLOSE_LINEAR                                 
elements :                          element elements 
                                    | element
element :                           LinearLayout 
                                    | RelativeLayout 
                                    | TextView 
                                    | ImageView 
                                    | Button 
                                    | RadioGroup 
                                    | ProgressBar 

/* Elements */ 

TextView :                          T_TAG_START_TEXT widgth-height id text textcolor T_SELF_CLOSING                             
ImageView :                         T_TAG_START_IMAGE widgth-height id src padding T_SELF_CLOSING                                
Button :                            T_TAG_START_BUTTON widgth-height id text padding T_SELF_CLOSING
RadioGroup :                        T_TAG_START_RADIOG widgth-height id  buttons-num checked-button T_TAG_END RadioButtonS T_TAG_CLOSE_RADIOG 
                                    {
                                        //Check if there is checkedButtonAttribute      
                                        if(checkedButtonCheck == 1){

                                            if(matchesButtonId(buttonidStringTable, checkedButton, buttonsCount) != 1){
                                                yyerror("android:checkedButton must match one of RadioButton ids!");
                                            }
                                        }

                                        if(buttonsCount != buttonsCheck){
                                            yyerror("android:buttonsNum must be equal to RadioButton Elements!");
                                        }

                                        //Reset buttonsCount
                                        buttonsCount = 0;                                    
                                    }                                                                      
RadioButtonS :                      RadioButton RadioButtonS 
                                    | RadioButton
RadioButton :                       T_TAG_START_RADIOB widgth-height id text T_SELF_CLOSING
                                    {                                
                                        strcpy(buttonidStringTable[buttonsCount], idString);
                                        buttonsCount = buttonsCount + 1;
                                    }
ProgressBar :                       T_TAG_START_PROGRESS widgth-height id max progress T_SELF_CLOSING 
                                    {   
                                        //Check if there is progress attribute
                                        if(progressBarCheck == 1){  

                                            if(progressCheck < 0 || progressCheck > maxCheck){
                                                yyerror("android:progress must be between 0 and value of android:max\n or android:max attribute is missing!");
                                            }
                                        }
                                    }

/*Attributes*/

widgth-height :                     T_ATTRIBUTE_WIDTH wh-value T_ATTRIBUTE_HEIGHT wh-value
id :                                T_ATTRIBUTE_ID T_ALPHANUM 
                                    {
                                        //Add ids tp idStringTable array
                                        idString = $2;
                                        strcpy(idStringTable[tableCounter], idString);
                                        tableCounter = tableCounter + 1;
                                    }
                                    | %empty
orientation :                       T_ATTRIBUTE_ORIENTATION T_ALPHANUM 
                                    | T_ATTRIBUTE_ORIENTATION T_WH_VALUE 
                                    | %empty
text :                              T_ATTRIBUTE_TEXT T_ALPHANUM 
                                    | T_ATTRIBUTE_TEXT T_WH_VALUE
textcolor :                         T_ATTRIBUTE_TEXTCOLOR T_ALPHANUM 
                                    | T_ATTRIBUTE_TEXTCOLOR T_WH_VALUE
                                    | %empty
src :                               T_ATTRIBUTE_SRC T_ALPHANUM
                                    | T_ATTRIBUTE_SRC T_WH_VALUE
padding :                           T_ATTRIBUTE_PADDING T_NUM  
                                    | %empty
checked-button :                    T_ATTRIBUTE_CHECKEDBUTTON T_ALPHANUM 
                                    {
                                        checkedButtonCheck = 1;
                                        checkedButton = $2;
                                    }
                                    | %empty
max :                               T_ATTRIBUTE_MAX T_NUM
                                    {
                                        maxCheckString = $2;
                                        maxCheck = StrToInt(maxCheckString);
                                    }
                                    | %empty
progress :                          T_ATTRIBUTE_PROGRESS T_NUM 
                                    {
                                        progressBarCheck = 1;
                                       
                                        progressCheckString = $2;
                                        progressCheck = StrToInt(progressCheckString);
                                    }
                                    | %empty
buttons-num :                       T_ATTRIBUTE_BUTTONS_NUM T_NUM
                                    {
                                        buttonsCheckString = $2;
                                        buttonsCheck = StrToInt(buttonsCheckString);                                        
                                    }

wh-value :                          T_WH_VALUE | T_NUM                                                                               

%%

int main(int argc, char *argv[]){
    int token;

    /* Read file */
    if (argc > 1){
        yyin = fopen(argv[1], "r");
        if (yyin == NULL){
            perror ("Error opening file");
            return -1;
        }
    }

    yyparse();

    fclose(yyin);
    return 0;
} 

// Function turns value into int without ""

int StrToInt(char* Tempstring){
    char *trimmedString = Tempstring + 1;
    char *closingQuote = strchr(trimmedString, '\"');
    int Tempint = atoi(trimmedString);
    if (closingQuote != NULL) {
        *closingQuote = '\0';
    }
    return Tempint;
}

// Function checks if array of strings has duplicates
int hasDuplicateStrings(char strings[][20], int size){
    for (int j = 0; j < size - 1; j++) {
        for (int k = j + 1; k < size; k++) {
            if (strcmp(strings[j], strings[k]) == 0) {
                return 1; // Duplicate found
            }
        }
    }
}

int matchesButtonId(char strings[][20],char* tempid, int size){
    for (int j = 0; j < size; j++) {
        if (strcmp(strings[j], tempid) == 0) {
            return 1; // Match found
        }
    }
}
