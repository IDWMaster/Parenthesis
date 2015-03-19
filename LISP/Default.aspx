<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="LISP.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lots of Insipid and Stupid Parenthesis</title>
    <script type="text/javascript" src="Scripts/jquery-2.1.3.js"></script>
    <script type="text/javascript" src="esprima.js"></script>
    <script type="text/javascript">
        /*
        Test case:
        var fib = function(n) {
if(n<=1) {
return n;
}else {
return fib(n-1)+fib(n-2);
}
}
        */

        var lnum = 0;

        $(document).ready(function () {
            var input = $('#input');
            input.keyup(function () {
                var tree = esprima.parse(input.val());
                var Types = esprima.Syntax;
                var iter = function (list,separator) {
                    var retval = '';
                    if (!separator) {
                        separator = '';
                    }
                    for (var i = 0; i < list.length; i++) {
                        retval+=convert(list[i])+separator;
                    }

                    return retval.substr(0,retval.length-separator.length);
                };
                String.prototype.prefix = function () {
                    if (this.length>0) {
                        return ' ' + this;
                    }
                };
                var convert = function (node) {
                    switch (node.type) {
                        case Types.Identifier:
                            return node.name;
                            break;
                        case Types.Literal:
                            return node.value;
                            break;
                        case Types.VariableDeclaration:
                            //Declare variable
                            return '(define '+convert(node.declarations[0].id)+' '+convert(node.declarations[0].init)+')';
                            break;
                        case Types.FunctionExpression:
                            return '(lambda ('+iter(node.params,' ')+') '+convert(node.body)+')';
                            break;
                        case Types.BinaryExpression:
                            return '('+node.operator+' '+convert(node.left)+' '+convert(node.right)+')';
                            break;
                        case Types.BlockStatement:
                            return iter(node.body);
                            break;
                        case Types.ReturnStatement:
                            return convert(node.argument);
                            break;
                        case Types.CallExpression:
                            return '('+convert(node.callee)+iter(node.arguments,' ').prefix()+')';
                            break;
                        case Types.IfStatement:
                            if (node.alternate) {
                                return '(if ' + convert(node.test) + ' (begin ' + convert(node.consequent) + ') (begin ' + convert(node.alternate) + '))';
                            } else {

                                return '(if ' + convert(node.test) + ' (begin ' + convert(node.consequent) + ') (void)'+ ')';
                            }
                            break;
                        case Types.WhileStatement:
                            throw 'Parenthesis are VERY innefficient! You can\'t use loops, you MUST use recursion (using a TON more memory than even Java!)!';
                            break;
                        case Types.ExpressionStatement:
                            return convert(node.expression);
                            break;
                    }
                    return '';
                };
                try {
                    $('#json').text(JSON.stringify(tree.body));
                    $('#output').text(iter(tree.body));
                } catch (er) {
                    $('#output').text(er);
                }
            });
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <h1>Lots of Insipid and Stupid Parenthesis</h1>
        <h3>When your professor makes you write your own parse tree</h3>
        <hr />
        Human-readable code:
        <br /><textarea id="input"></textarea>
        <br />Parenthesis
        <hr /><pre id="output"></pre>
        <h2>JSON debug</h2>
        <hr />
        <pre id="json"></pre>
        <hr />
        This program is written with the intent of making the lives of many college student programmers a <b><u>LOT</u></b> easier. This utility converts from human-readable JavaScript code into a bunch of very junky parenthesis that are hard to read. <u><b>PLEASE CONTRIBUTE! The following features haven't yet been completed:</b></u>
        <br />(((((((((((((((((((((((((s(k(c(u(S((P(S(I(L))))))))))))))))))))))))))))))))))
        <br /><bl>

            <li>
                Looping constructs (it is possible to simulate this through recursion)
            </li>
            <li>Objects (is this even possible to do with just two characters?)</li>
              </bl>
    </div>
    </form>
</body>
</html>
