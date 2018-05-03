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
        intVal = 0;
    }
    Variable(char* name1, int value){
        name = name1;
        type = "int";
        intVal = value;
        strVal = "";
    }
    Variable(){
        name = "";
        type = "undefined";
        strVal = "";
        intVal = 0;
    }
};