#include <iostream>
#include <vector>
#include <unordered_map>
#include <set>
#include <regex>
#include <cctype>
#include <fstream>
using namespace std;

bool is_temp(const string &str)
{
    regex rgx("^t[0-9]*$");
    return regex_match(str, rgx);
}

bool is_identifier(const string &str)
{
    regex rgx("^[A-Za-z][A-Za-z0-9_]*$");
    return regex_match(str, rgx);
}

vector<string> whitespace_split(const string &str)
{
    regex rgx("\\s+");
    vector<string> tokens;

    sregex_token_iterator iter(
        str.begin(),
        str.end(),
        rgx,
        -1
    );

    sregex_token_iterator end;

    for (; iter != end; ++iter)
        tokens.push_back(*iter);
    
    return tokens;
}

long int eval(const string &op1, const string &op2, const string &op)
{
    long int a = stoi(op1);
    long int b = stoi(op2);
    long int res;

    if (op == "+") res = a + b;
    else if (op == "-") res = a - b;
    else if (op == "*") res = a * b;
    else if (op == "/") res = a / b;
    else if (op == "&") res = a & b;
    else if (op == "|") res = a | b;
    else if (op == "^") res = a ^ b;
    else if (op == "==") res = a == b;
    else if (op == ">=") res = a >= b;
    else if (op == "<=") res = a <= b;
    else if (op == "!=") res = a != b;
    else if (op == ">") res = a > b;
    else if (op == "<") res = a < b;

    return res;
}

unordered_map<string, string> create_subexpr(const vector<string> &lines)
{
    unordered_map<string, string> expressions;
    unordered_map<string, string> variables;
    vector<string> tokens;
    string var, expr_rhs;

    for (const string &line: lines)
    {
        tokens = whitespace_split(line);

        if (tokens.size() == 5)
        {
            if (variables.find(tokens[0]) != variables.end())
            {
                var = variables.at(tokens[0]);
                if (expressions.find(var) != expressions.end())
                {
                    cout << tokens[0] << " ";
                    cout << var << " ";
                    cout << expressions.at(var) << "\n";

                    expressions.erase(var);
                }
            }

            expr_rhs = tokens[2] + " " + tokens[3] + " " + tokens[4];

            if (expressions.find(expr_rhs) == expressions.end())
            {
                expressions[expr_rhs] = tokens[0];

                if (is_identifier(tokens[2]))
                    variables[tokens[2]] = expr_rhs;
                
                if (is_identifier(tokens[4]))
                    variables[tokens[4]] = expr_rhs;
            }
        }
    }

    return expressions;
}

string eval_expr(const string &expr)
{
    vector<string> tokens = whitespace_split(expr);

    if (tokens.size() != 5)
        return expr;
    
    set<string> op {"+", "-", "*", "/", "&", "|", "^", "==", ">=", "<=", "!=", ">", "<"};

    if (
        (tokens[1] != "=") or
        (op.find(tokens[3]) == op.end())
    )
        return expr;

    string res("");
    
    if (
        isdigit(tokens[2][0]) and
        isdigit(tokens[4][0])
    )
    {
        res += tokens[0] + " ";
        res += tokens[1] + " ";
        res += to_string(eval(tokens[2], tokens[4], tokens[3]));

        return res;
    }

    if (
        isdigit(tokens[2][0]) or
        isdigit(tokens[4][0])
    )
    {
        string op1(is_identifier(tokens[2]) ? "5" : tokens[2]);
        string op2(is_identifier(tokens[4]) ? "5" : tokens[4]);
        string op(tokens[3]);

        try
        {
            int result = eval(op1, op2, op);

            if (result == 0)
            {
                res += tokens[0] + " ";
                res += tokens[1] + " ";
                res += "0";

                return res;
            }
            else if (result == 5)
            {
                if (
                    is_identifier(tokens[2]) and
                    isdigit(tokens[4][0])
                )
                {
                    res += tokens[0] + " ";
                    res += tokens[1] + " ";
                    res += tokens[2];

                    return res;
                }

                else if (
                    is_identifier(tokens[4]) and
                    isdigit(tokens[2][0])
                )
                {
                    res += tokens[0] + " ";
                    res += tokens[1] + " ";
                    res += tokens[4];

                    return res;
                }
            }
            else if ((result == -5) and (tokens[2] == "0"))
            {
                res += tokens[0] + " ";
                res += tokens[1] + " ";
                res += "-" + tokens[4];

                return res;
            }

            for (const string &token: tokens)
                res += token + " ";
            res.erase(res.length() - 1);

            return res;
        }
        catch (const exception &exc)
        {
            return expr;
        }
    }

    return expr;
}

void eliminate_common_subexpr(vector<string> &lines)
{
    unordered_map<string, string> expressions = create_subexpr(lines);
    vector<string> tokens;
    string expr_rhs;

    for (size_t i = 0; i < lines.size(); ++i)
    {
        tokens = whitespace_split(lines[i]);

        if (tokens.size() == 5)
        {
            expr_rhs = tokens[2] + " " + tokens[3] + " " + tokens[4];

            if (expressions.find(expr_rhs) != expressions.end())
            {
                if (expressions.at(expr_rhs) != tokens[0])
                {
                    lines[i] = tokens[0] + " ";
                    lines[i] += tokens[1] + " ";
                    lines[i] += expressions.at(expr_rhs);
                }
            }
        }
    }
}

void constant_folding(vector<string> &lines)
{
    for (string &line: lines)
        line = eval_expr(line);
}

void eliminate_dead_code(vector<string> &lines)
{
    set<string> defined_temp_vars;
    set<string> useful_temp_vars;
    set<string> unwanted_temp_vars;
    vector<string> tokens, updated_lines;

    for (const string &line: lines)
    {
        tokens = whitespace_split(line);

        if (is_temp(tokens[0]))
            defined_temp_vars.insert(tokens[0]);
        
        if (tokens.size() > 1)
        {
            if (is_temp(tokens[1]))
                useful_temp_vars.insert(tokens[1]);
        }

        if (tokens.size() > 2)
        {
            if (is_temp(tokens[2]))
                useful_temp_vars.insert(tokens[2]);
        }
    }

    set_difference(
        defined_temp_vars.begin(), defined_temp_vars.end(),
        useful_temp_vars.begin(), useful_temp_vars.end(),
        inserter(unwanted_temp_vars, unwanted_temp_vars.end())
    );

    for (string &line: lines)
    {
        tokens = whitespace_split(line);

        if (unwanted_temp_vars.find(tokens[0]) == unwanted_temp_vars.end())
            updated_lines.push_back(line);
    }

    if (updated_lines.size() != lines.size())
        eliminate_dead_code(updated_lines);

    lines = updated_lines;
}

void optimize_3ac(const char *infile)
{
    string line;
    vector<string> lines;

    ifstream fin(infile);
    regex rgx("\\s*");

    while (getline(fin, line))
    {
        if (not regex_match(line, rgx))
            lines.push_back(line);
    }

    fin.close();

    size_t n_lines = lines.size();

    eliminate_common_subexpr(lines);
    constant_folding(lines);
    eliminate_dead_code(lines);

    for (const string &line: lines)
    {
        if (not regex_match(line, rgx))
            cout << line << "\n";
    }

    n_lines -= lines.size();
    cout << "\nOptimization done by eliminating " << n_lines << " lines\n";
}

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        cerr << "Usage:\n";
        cerr << argv[0] << " <input_file>\n";
        return 1;
    }

    optimize_3ac(argv[1]);
    return 0;
}
