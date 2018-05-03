/* Code written by Vakaris */
using namespace std;
class Variable {
    public:
    string name,type;
    string strVal;
    int intVal;
    Variable(string name1, string value){
        name = name1;
        type = "string";
        strVal = value;
    }
    Variable(string name1, int value){
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