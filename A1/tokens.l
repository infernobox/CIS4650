/**
 * Author: Vanessa White
 * File: tokens.l
 * Class: CIS*4650 Compilers
 * Purpose: Flex Specification for the news article written in SGML
 * Date: February 2nd, 2017
*/

%{

    #include "globals.h"
    #include "util.h"
    #include "scan.h"

    string normalizedText;
    struct GlobalStack normalizedStack;
    struct TokenStruct tokenValue;
    bool relevant = false;
    bool isOutputted = false;
    array<string, 7> relevantTags = { "DOC", "TEXT", "P", "DOCNO", "DATE", "HEADLINE", "LENGTH"};
%}

letter                                  [a-zA-z]
real                                    ([0-9]+"."[0-9]+)|([0-9]*"."[0-9]+)
digit                                   [0-9]
sign                                    ("+"|"-")?
open-tag                                ("<")[a-zA-z0-9=\" ]+(">")
close-tag                               ("</"){1}[a-zA-z0-9 ]+(">"){1}
word                                    ({digit}*{letter}+{digit}*)+
number                                  ({sign}{real}|{sign}{digit}+|{digit}+|{real})
apostrophized                           ([a-zA-z0-9]+("'"){1})+[a-zA-z0-9]+
hyphenated                              ([a-zA-z0-9]+("-"){1})+[a-zA-z0-9]+
punctuation                             [!@#$%{}\:.,;?></\^&`~*()_="'-]

whitespace                              [ \t]+
newline                                 \n

%%

{open-tag}                                  {
                                                tokenValue.row = rowno;
                                                yytext = toUpperCase(yytext);
                                                normalizedText = parseTag(yytext); // remove <, / and >
                                                relevant = checkRelevancy(normalizedText); // check that it is a relevant tag
                                                isOutputted = toOutput(); //check if the text should be outputted based on the stack contents

                                                normalizedStack.value.push_back(normalizedText); // push the value onto the stack
                                                
                                                if(relevant && isOutputted)
                                                {
                                                   return OPENTAG;
                                                }
                                            }
{close-tag}                                 {
                                                tokenValue.row = rowno;
                                                yytext = toUpperCase(yytext);
                                                normalizedText = parseTag(yytext);

                                                relevant = checkRelevancy(normalizedText);
                                                isOutputted = toOutput();

                                                /*Check that the closing tag and open tag match 
                                                If they do, pop it off the stack. Else it is an error*/
                                                if(!normalizedStack.value.empty() && normalizedStack.value.back().compare(normalizedText) == 0)
                                                {
                                                    normalizedStack.value.pop_back(); // pop value off of the stack

                                                    if(relevant && isOutputted)
                                                    {
                                                        tokenValue.value = normalizedText; 
                                                        return CLOSETAG;
                                                    }
                                                }
                                                else if(normalizedText.compare("DOC") == 0) //always output the DOC tag
                                                {
                                                    tokenValue.value = normalizedText;

                                                    if(!normalizedStack.value.empty()) //making sure the stack is not empty before erasing
                                                    {
                                                        // erase so if any unmatched tags are present, the DOC one will not be printed
                                                        normalizedStack.value.erase(normalizedStack.value.begin());
                                                    }
                                                    return CLOSETAG;
                                                }
                                                else if(relevant && isOutputted) // a close tag with no matching opentag
                                                {
                                                    tokenValue.value = yytext;
                                                    return ERROR;
                                                } 
                                            }
{word}                                      {  
                                                tokenValue.row = rowno;
                                                isOutputted = toOutput();

                                                if(!normalizedStack.value.empty() && checkRelevancy(normalizedStack.value.back()) && isOutputted)
                                                {
                                                    tokenValue.value = yytext;
                                                    return WORD;
                                                }
                                            }
{number}                                    {   
                                                tokenValue.row = rowno;
                                                isOutputted = toOutput();

                                                if(!normalizedStack.value.empty() && checkRelevancy(normalizedStack.value.back()) && isOutputted)
                                                {
                                                    tokenValue.value = yytext;
                                                    return NUMBER;
                                                }
                                            }
                                            
{apostrophized}                             {   
                                                tokenValue.row = rowno;
                                                isOutputted = toOutput();

                                                if(!normalizedStack.value.empty() && checkRelevancy(normalizedStack.value.back()) && isOutputted)
                                                {
                                                    tokenValue.value = yytext;
                                                    return APOSTROPHIZED;
                                                }
                                            }
{hyphenated}                                {  
                                                tokenValue.row = rowno; 
                                                isOutputted = toOutput();

                                                if(!normalizedStack.value.empty() && checkRelevancy(normalizedStack.value.back()) && isOutputted)
                                                {
                                                    tokenValue.value = yytext;
                                                    return HYPHENATED;
                                                }
                                            }
{punctuation}                               {  
                                                tokenValue.row = rowno;
                                                isOutputted = toOutput(); 

                                                if(!normalizedStack.value.empty() && checkRelevancy(normalizedStack.value.back()) && isOutputted)
                                                {
                                                    tokenValue.value = yytext;
                                                    return PUNCTUATION;
                                                }
                                            }
{whitespace}                                {   /* skip whitespace*/    }
{newline}                                   {   rowno++;    }

%%

/* Function given by Fei Song
    Allows output to be casted to the type of filters declared in globals.h
*/
enum Filters getToken(void) {
    return (enum Filters)yylex();
}

/* Checks if the tag is relevant 
    Returns true if it is
    Returns false is the tag is irrelevant
*/
bool checkRelevancy(string token) {

    for(int i = 0; i < relevantTags.size(); ++i)
    {
        if(token.compare(relevantTags.at(i)) == 0) // if the tag in in the array (declared at top of file)
        {
            return true;
        }
    }

    return false;
}

/* Checks that the stack has either all relevant or all irrelevant tags in it 
    Returns false if an irrelevant tag is in the stack
    Else returns true
*/
bool toOutput() {

    vector<string>::iterator it;
    bool found = false;

    for(it = normalizedStack.value.begin(); it != normalizedStack.value.end(); ++it)
    {
        found = false;

        for(int i = 0; i < relevantTags.size(); ++i)
        {
            if(relevantTags.at(i).compare(*it) == 0)
            {
                found = true;
                break;
            }

            if(!found && i == relevantTags.size() - 1)
            {
                return false;
            }

        }
    }

    return true;
}

/* Converts lowercase string to all upper case
    Returns the string in uppercase
*/
char * toUpperCase(char * str) {

    int i = 0;

    while(str[i])
    {
        str[i] = toupper(str[i]);
        i++;
    }

    return str;
}

/* Parses the OPEN-TAG and CLOSE-TAG to remove th '<', '>' and '/'
    Allows the normalized text to be extracted
    Return the string containing the normalized text

    currently does not account for tags with attributes such as <text align="left">
*/
string parseTag(char * tag) {

    string str(tag);
    string normalized;

    string::iterator it; //an iterator to traverse through the string

    for(it = str.begin(); it != str.end(); ++it)
    {
        if(isalnum(*it))
        {
            normalized = normalized + *it;
        }
    }

    return normalized;
}