%{

    #include <stdio.h>
    #include <stdlib.h>
    #include "syntax.tab.h"

    int error_counter=0;
    int elementCount=0;

    void token_print(int token_id);
    void yyerror(const char* err);

%}

%option noyywrap
%option yylineno

TAG_START_RELATIVE          "<RelativeLayout"
TAG_START_LINEAR            "<LinearLayout"
TAG_START_TEXT              "<TextView"
TAG_START_IMAGE             "<ImageView"
TAG_START_BUTTON            "<Button"
TAG_START_RADIOG            "<RadioGroup"
TAG_START_RADIOB            "<RadioButton"
TAG_START_PROGRESS          "<ProgressBar"
TAG_CLOSE_RELATIVE          "</RelativeLayout>"
TAG_CLOSE_LINEAR            "</LinearLayout>"
TAG_CLOSE_RADIOG            "</RadioGroup>"
ATTRIBUTE_WIDTH             "android:layout_width="
ATTRIBUTE_HEIGHT            "android:layout_height="
ATTRIBUTE_ID                "android:id="
ATTRIBUTE_ORIENTATION       "android:orientation="
ATTRIBUTE_TEXT              "android:text="
ATTRIBUTE_TEXTCOLOR         "android:textColor="
ATTRIBUTE_SRC               "android:src="
ATTRIBUTE_PADDING           "android:padding="
ATTRIBUTE_CHECKEDBUTTON     "android:checkedButton="
ATTRIBUTE_MAX               "android:max="
ATTRIBUTE_PROGRESS          "android:progress="
ATTRIBUTE_BUTTONS_NUM       "android:buttonsNum="
NUM                         "\""[0-9]+["\""]
WH_VALUE_W                  "\"""wrap_content"["\"""] 
WH_VALUE_H                  "\"""match_parent"["\"""]
WH_VALUE                    {WH_VALUE_H}|{WH_VALUE_W}
ALPHANUM                    "\""[^"]+["\""]
SELF_CLOSING                "/>"
TAG_END                     ">"
COMMENT                     "<!--"[^-]+"-->"

%%

{TAG_START_RELATIVE}       { token_print(T_TAG_START_RELATIVE); return T_TAG_START_RELATIVE; }
{TAG_START_LINEAR}         { token_print(T_TAG_START_LINEAR); return T_TAG_START_LINEAR; }
{TAG_START_TEXT}           { token_print(T_TAG_START_TEXT); return T_TAG_START_TEXT; }
{TAG_START_IMAGE}          { token_print(T_TAG_START_IMAGE); return T_TAG_START_IMAGE; }
{TAG_START_BUTTON}         { token_print(T_TAG_START_BUTTON); return T_TAG_START_BUTTON; }
{TAG_START_RADIOG}         { token_print(T_TAG_START_RADIOG); return T_TAG_START_RADIOG; }
{TAG_START_RADIOB}         { token_print(T_TAG_START_RADIOB); return T_TAG_START_RADIOB; }
{TAG_START_PROGRESS}       { token_print(T_TAG_START_PROGRESS); return T_TAG_START_PROGRESS; }
{TAG_CLOSE_RELATIVE}       { token_print(T_TAG_CLOSE_RELATIVE); return T_TAG_CLOSE_RELATIVE; }
{TAG_CLOSE_LINEAR}         { token_print(T_TAG_CLOSE_LINEAR); return T_TAG_CLOSE_LINEAR; }
{TAG_CLOSE_RADIOG}         { token_print(T_TAG_CLOSE_RADIOG); return T_TAG_CLOSE_RADIOG; }
{ATTRIBUTE_WIDTH}          { token_print(T_ATTRIBUTE_WIDTH); return T_ATTRIBUTE_WIDTH; }
{ATTRIBUTE_HEIGHT}         { token_print(T_ATTRIBUTE_HEIGHT); return T_ATTRIBUTE_HEIGHT; }
{ATTRIBUTE_ID}             { token_print(T_ATTRIBUTE_ID); return T_ATTRIBUTE_ID; }
{ATTRIBUTE_ORIENTATION}    { token_print(T_ATTRIBUTE_ORIENTATION); return T_ATTRIBUTE_ORIENTATION; }
{ATTRIBUTE_TEXT}           { token_print(T_ATTRIBUTE_TEXT); return T_ATTRIBUTE_TEXT; }
{ATTRIBUTE_TEXTCOLOR}      { token_print(T_ATTRIBUTE_TEXTCOLOR); return T_ATTRIBUTE_TEXTCOLOR; }
{ATTRIBUTE_SRC}            { token_print(T_ATTRIBUTE_SRC); return T_ATTRIBUTE_SRC; }
{ATTRIBUTE_PADDING}        { token_print(T_ATTRIBUTE_PADDING); return T_ATTRIBUTE_PADDING; }
{ATTRIBUTE_CHECKEDBUTTON}  { token_print(T_ATTRIBUTE_CHECKEDBUTTON); return T_ATTRIBUTE_CHECKEDBUTTON; }
{ATTRIBUTE_MAX}            { token_print(T_ATTRIBUTE_MAX); return T_ATTRIBUTE_MAX; }
{ATTRIBUTE_PROGRESS}       { token_print(T_ATTRIBUTE_PROGRESS); return T_ATTRIBUTE_PROGRESS; }
{ATTRIBUTE_BUTTONS_NUM}    { token_print(T_ATTRIBUTE_BUTTONS_NUM); return T_ATTRIBUTE_BUTTONS_NUM; }
{NUM}                      { token_print(T_NUM); yylval.strval = strdup(yytext); return T_NUM; }
{WH_VALUE}                 { token_print(T_WH_VALUE); return T_WH_VALUE; }
{ALPHANUM}                 { token_print(T_ALPHANUM); yylval.strval = strdup(yytext); return T_ALPHANUM; }
{SELF_CLOSING}             { token_print(T_SELF_CLOSING); return T_SELF_CLOSING; }
{TAG_END}                  { token_print(T_TAG_END); return T_TAG_END; }


{COMMENT}                  {/*ignore*/}
" "                        {/*ignore*/}
[\n]                       {/*ignore*/}
[\t]                       {/*ignore*/}
[\r\n]                     {/*ignore*/}
.                          {printf("Uknown\n"); }
<<EOF>>                    {printf("End Of File!"); return 0; }

%%

/* Print function */
void token_print(int token_id) {
    yytext[strcspn(yytext, "\r")] = 0;
    printf("Found token %s (%d) at line %d\r\n", yytext, token_id, yylineno);
}

/* Error handling */
void yyerror(const char* err) {
    error_counter++;
    printf("[Error - Line %d] %s\r\n", yylineno, err);

    if(error_counter == 1) {
        printf("Errors Found!\n");
        exit(EXIT_FAILURE);
    }

    yyless(1);
}
