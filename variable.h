/* Code written by Vakaris */
using namespace std;
class Variable {
    public:
    char* name;
	char* type;
    char* strVal;
    int intVal;
    Variable(char* name1, char* value){
        name = name1;
        type = "string";
        strVal = value;
    }
    Variable(char* name1, int value){
        name = name1;
        type = "int";
        intVal = value;
    }
    Variable(){
        name = "";
        type = "undefined";
        strVal = "";
        intVal = 0;
    }
};